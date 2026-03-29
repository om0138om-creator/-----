import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_picker/image_picker.dart';

import '../models/project_model.dart';
import '../models/layer_model.dart';

class ProjectProvider extends ChangeNotifier {
  ProjectModel? _currentProject;
  List<ProjectModel> _recentProjects = [];
  bool _isLoading = false;
  String? _error;
  bool _hasUnsavedChanges = false;
  
  // للتراجع والإعادة
  List<ProjectModel> _undoStack = [];
  List<ProjectModel> _redoStack = [];
  static const int _maxUndoSteps = 50;

  // Getters
  ProjectModel? get currentProject => _currentProject;
  List<ProjectModel> get recentProjects => _recentProjects;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasUnsavedChanges => _hasUnsavedChanges;
  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  /// تهيئة المزود
  Future<void> initialize() async {
    await _loadRecentProjects();
  }

  /// إنشاء مشروع جديد
  Future<void> createProject({
    required String name,
    required double width,
    required double height,
    Color backgroundColor = Colors.white,
  }) async {
    _saveToUndoStack();
    
    _currentProject = ProjectModel(
      name: name,
      canvasWidth: width,
      canvasHeight: height,
      backgroundColor: backgroundColor,
      layers: [],
    );
    
    _hasUnsavedChanges = true;
    notifyListeners();
  }

  /// إنشاء مشروع من قالب
  Future<void> createFromTemplate(ProjectTemplate template) async {
    await createProject(
      name: template.nameAr,
      width: template.width,
      height: template.height,
    );
  }

  /// فتح مشروع
  Future<void> openProject(ProjectModel project) async {
    _saveToUndoStack();
    _currentProject = project;
    _hasUnsavedChanges = false;
    notifyListeners();
  }

  /// حفظ المشروع
  Future<void> saveProject() async {
    if (_currentProject == null) return;
    
    try {
      _isLoading = true;
      notifyListeners();

      final appDir = await getApplicationDocumentsDirectory();
      final projectsDir = Directory('${appDir.path}/projects');
      if (!await projectsDir.exists()) {
        await projectsDir.create(recursive: true);
      }

      final file = File('${projectsDir.path}/${_currentProject!.id}.json');
      await file.writeAsString(jsonEncode(_currentProject!.toJson()));

      // تحديث المشاريع الأخيرة
      _recentProjects.removeWhere((p) => p.id == _currentProject!.id);
      _recentProjects.insert(0, _currentProject!);
      if (_recentProjects.length > 10) {
        _recentProjects = _recentProjects.sublist(0, 10);
      }
      await _saveRecentProjects();

      _hasUnsavedChanges = false;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// تصدير المشروع كصورة
  Future<String?> exportAsImage(GlobalKey canvasKey, {
    double pixelRatio = 3.0,
    String format = 'png',
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final boundary = canvasKey.currentContext?.findRenderObject() 
          as RenderRepaintBoundary?;
      
      if (boundary == null) {
        throw Exception('Could not find canvas');
      }

      final image = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(
        format: format == 'png' ? ui.ImageByteFormat.png : ui.ImageByteFormat.rawRgba,
      );
      
      if (byteData == null) {
        throw Exception('Could not convert to image');
      }

      final bytes = byteData.buffer.asUint8List();

      // حفظ الصورة
      final appDir = await getApplicationDocumentsDirectory();
      final exportsDir = Directory('${appDir.path}/exports');
      if (!await exportsDir.exists()) {
        await exportsDir.create(recursive: true);
      }

      final fileName = '${_currentProject?.name ?? 'export'}_${DateTime.now().millisecondsSinceEpoch}.$format';
      final file = File('${exportsDir.path}/$fileName');
      await file.writeAsBytes(bytes);

      _isLoading = false;
      notifyListeners();

      return file.path;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// مشاركة المشروع
  Future<void> shareProject(String imagePath) async {
    await Share.shareXFiles(
      [XFile(imagePath)],
      text: _currentProject?.name ?? 'Font Studio Design',
    );
  }

  /// إضافة صورة خلفية
  Future<void> setBackgroundImage() async {
    if (_currentProject == null) return;
    
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image == null) return;

      _saveToUndoStack();
      
      // نسخ الصورة لمجلد التطبيق
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${appDir.path}/images');
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final fileName = 'bg_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedPath = '${imagesDir.path}/$fileName';
      await File(image.path).copy(savedPath);

      _currentProject = _currentProject!.copyWith(backgroundImage: savedPath);
      _hasUnsavedChanges = true;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// إزالة صورة الخلفية
  void removeBackgroundImage() {
    if (_currentProject == null) return;
    
    _saveToUndoStack();
    _currentProject = _currentProject!.copyWith(backgroundImage: null);
    _hasUnsavedChanges = true;
    notifyListeners();
  }

  /// تغيير لون الخلفية
  void setBackgroundColor(Color color) {
    if (_currentProject == null) return;
    
    _saveToUndoStack();
    _currentProject = _currentProject!.copyWith(backgroundColor: color);
    _hasUnsavedChanges = true;
    notifyListeners();
  }

  /// تغيير أبعاد اللوحة
  void setCanvasSize(double width, double height) {
    if (_currentProject == null) return;
    
    _saveToUndoStack();
    _currentProject = _currentProject!.copyWith(
      canvasWidth: width,
      canvasHeight: height,
    );
    _hasUnsavedChanges = true;
    notifyListeners();
  }

  /// تحديث الطبقات
  void updateLayers(List<LayerModel> layers) {
    if (_currentProject == null) return;
    
    _saveToUndoStack();
    _currentProject = _currentProject!.copyWith(layers: layers);
    _hasUnsavedChanges = true;
    notifyListeners();
  }

  /// تراجع
  void undo() {
    if (_undoStack.isEmpty) return;
    
    _redoStack.add(_currentProject!.copyWith());
    _currentProject = _undoStack.removeLast();
    _hasUnsavedChanges = true;
    notifyListeners();
  }

  /// إعادة
  void redo() {
    if (_redoStack.isEmpty) return;
    
    _undoStack.add(_currentProject!.copyWith());
    _currentProject = _redoStack.removeLast();
    _hasUnsavedChanges = true;
    notifyListeners();
  }

  /// حفظ للتراجع
  void _saveToUndoStack() {
    if (_currentProject == null) return;
    
    _undoStack.add(_currentProject!.copyWith());
    if (_undoStack.length > _maxUndoSteps) {
      _undoStack.removeAt(0);
    }
    _redoStack.clear();
  }

  /// حفظ حالة (للاستخدام الخارجي)
  void saveState() {
    _saveToUndoStack();
    _hasUnsavedChanges = true;
    notifyListeners();
  }

  /// تحميل المشاريع الأخيرة
  Future<void> _loadRecentProjects() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final projectsJson = prefs.getStringList('recent_projects') ?? [];
      
      _recentProjects = projectsJson
          .map((json) => ProjectModel.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      print('Error loading recent projects: $e');
    }
  }

  /// حفظ المشاريع الأخيرة
  Future<void> _saveRecentProjects() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final projectsJson = _recentProjects
          .map((p) => jsonEncode(p.toJson()))
          .toList();
      await prefs.setStringList('recent_projects', projectsJson);
    } catch (e) {
      print('Error saving recent projects: $e');
    }
  }

  /// حذف مشروع
  Future<void> deleteProject(String projectId) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final file = File('${appDir.path}/projects/$projectId.json');
      if (await file.exists()) {
        await file.delete();
      }
      
      _recentProjects.removeWhere((p) => p.id == projectId);
      await _saveRecentProjects();
      
      if (_currentProject?.id == projectId) {
        _currentProject = null;
      }
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/font_model.dart';
import '../services/font_parser_service.dart';
import '../constants/opentype_features.dart';

class FontProvider extends ChangeNotifier {
  final FontParserService _parser = FontParserService();
  
  List<FontModel> _fonts = [];
  List<FontModel> _customFonts = [];
  FontModel? _selectedFont;
  bool _isLoading = false;
  String? _error;
  
  // OpenType Features المفعلة للخط الحالي
  Map<String, bool> _activeFeatures = {};
  
  // Variable Font axes values
  Map<String, double> _axisValues = {};

  // Getters
  List<FontModel> get fonts => _fonts;
  List<FontModel> get customFonts => _customFonts;
  FontModel? get selectedFont => _selectedFont;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, bool> get activeFeatures => _activeFeatures;
  Map<String, double> get axisValues => _axisValues;
  
  /// الخصائص المدعومة في الخط الحالي
  List<OpenTypeFeature> get supportedFeatures {
    if (_selectedFont == null) return [];
    return _selectedFont!.supportedFeatures
        .where((tag) => OpenTypeFeatures.allFeatures.containsKey(tag))
        .map((tag) => OpenTypeFeatures.allFeatures[tag]!)
        .toList();
  }
  
  /// الخصائص المدعومة مجمعة حسب الفئة
  Map<FeatureCategory, List<OpenTypeFeature>> get supportedFeaturesByCategory {
    final map = <FeatureCategory, List<OpenTypeFeature>>{};
    
    for (final feature in supportedFeatures) {
      map.putIfAbsent(feature.category, () => []);
      map[feature.category]!.add(feature);
    }
    
    return map;
  }

  /// تحميل الخطوط عند بدء التطبيق
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // تحميل الخطوط المخصصة المحفوظة
      await _loadSavedCustomFonts();
      
      // إضافة الخطوط الافتراضية
      _addDefaultFonts();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// إضافة الخطوط الافتراضية
  void _addDefaultFonts() {
    _fonts = [
      FontModel(
        id: 'default_cairo',
        name: 'Cairo',
        family: 'Cairo',
        isCustom: false,
        supportedFeatures: ['liga', 'kern', 'calt', 'locl'],
      ),
      FontModel(
        id: 'default_roboto',
        name: 'Roboto',
        family: 'Roboto',
        isCustom: false,
        supportedFeatures: ['liga', 'kern', 'calt'],
      ),
      ..._customFonts,
    ];
  }

  /// تحميل الخطوط المخصصة المحفوظة
  Future<void> _loadSavedCustomFonts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final fontsJson = prefs.getStringList('custom_fonts') ?? [];
      
      _customFonts = [];
      
      for (final json in fontsJson) {
        try {
          final data = jsonDecode(json);
          final font = FontModel.fromJson(data);
          
          // التحقق من وجود الملف
          if (font.path != null && await File(font.path!).exists()) {
            // إعادة قراءة البايتات
            final bytes = await File(font.path!).readAsBytes();
            _customFonts.add(font.copyWith(bytes: bytes));
          }
        } catch (_) {}
      }
    } catch (e) {
      print('Error loading saved fonts: $e');
    }
  }

  /// حفظ الخطوط المخصصة
  Future<void> _saveCustomFonts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final fontsJson = _customFonts
          .map((f) => jsonEncode(f.toJson()))
          .toList();
      await prefs.setStringList('custom_fonts', fontsJson);
    } catch (e) {
      print('Error saving fonts: $e');
    }
  }

  /// استيراد خط جديد
  Future<FontModel?> importFont() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // اختيار الملف
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['ttf', 'otf', 'woff', 'woff2', 'ttc'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        _isLoading = false;
        notifyListeners();
        return null;
      }

      final file = result.files.first;
      Uint8List bytes;
      String? savedPath;

      if (file.bytes != null) {
        bytes = file.bytes!;
      } else if (file.path != null) {
        bytes = await File(file.path!).readAsBytes();
      } else {
        throw Exception('Could not read font file');
      }

      // حفظ الخط في مجلد التطبيق
      final appDir = await getApplicationDocumentsDirectory();
      final fontsDir = Directory('${appDir.path}/fonts');
      if (!await fontsDir.exists()) {
        await fontsDir.create(recursive: true);
      }
      
      savedPath = '${fontsDir.path}/${file.name}';
      await File(savedPath).writeAsBytes(bytes);

      // تحليل الخط
      final font = await _parser.parseFromBytes(bytes, path: savedPath);
      
      if (font == null) {
        throw Exception('Could not parse font file');
      }

      // تسجيل الخط في Flutter
      final fontLoader = FontLoader(font.family);
      fontLoader.addFont(Future.value(ByteData.view(bytes.buffer)));
      await fontLoader.load();

      // إضافة للقائمة
      _customFonts.add(font);
      _fonts.add(font);
      
      // حفظ
      await _saveCustomFonts();

      _isLoading = false;
      notifyListeners();
      
      return font;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// حذف خط مخصص
  Future<void> deleteCustomFont(String fontId) async {
    try {
      final font = _customFonts.firstWhere((f) => f.id == fontId);
      
      // حذف الملف
      if (font.path != null) {
        final file = File(font.path!);
        if (await file.exists()) {
          await file.delete();
        }
      }
      
      _customFonts.removeWhere((f) => f.id == fontId);
      _fonts.removeWhere((f) => f.id == fontId);
      
      if (_selectedFont?.id == fontId) {
        _selectedFont = _fonts.isNotEmpty ? _fonts.first : null;
      }
      
      await _saveCustomFonts();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// اختيار خط
  void selectFont(FontModel font) {
    _selectedFont = font;
    
    // إعادة تعيين الخصائص المفعلة
    _activeFeatures = {};
    for (final tag in font.supportedFeatures) {
      final feature = OpenTypeFeatures.allFeatures[tag];
      if (feature != null) {
        _activeFeatures[tag] = feature.defaultEnabled;
      }
    }
    
    // إعادة تعيين قيم المحاور
    _axisValues = {};
    for (final axis in font.variableAxes) {
      _axisValues[axis.tag] = axis.defaultValue;
    }
    
    notifyListeners();
  }

  /// تفعيل/تعطيل خاصية OpenType
  void toggleFeature(String tag, bool enabled) {
    _activeFeatures[tag] = enabled;
    notifyListeners();
  }

  /// تعيين قيمة محور Variable Font
  void setAxisValue(String tag, double value) {
    _axisValues[tag] = value;
    notifyListeners();
  }

  /// الحصول على FontFeatures للنص
  List<FontFeature> getFontFeatures() {
    return _activeFeatures.entries
        .map((e) => e.value 
            ? FontFeature.enable(e.key) 
            : FontFeature.disable(e.key))
        .toList();
  }

  /// الحصول على FontVariations للنص
  List<FontVariation> getFontVariations() {
    return _axisValues.entries
        .map((e) => FontVariation(e.key, e.value))
        .toList();
  }

  /// إعادة تعيين جميع الخصائص للقيم الافتراضية
  void resetFeatures() {
    if (_selectedFont == null) return;
    
    _activeFeatures = {};
    for (final tag in _selectedFont!.supportedFeatures) {
      final feature = OpenTypeFeatures.allFeatures[tag];
      if (feature != null) {
        _activeFeatures[tag] = feature.defaultEnabled;
      }
    }
    
    notifyListeners();
  }

  /// إعادة تعيين محاور Variable Font
  void resetAxes() {
    if (_selectedFont == null) return;
    
    _axisValues = {};
    for (final axis in _selectedFont!.variableAxes) {
      _axisValues[axis.tag] = axis.defaultValue;
    }
    
    notifyListeners();
  }

  /// تفعيل جميع الخصائص
  void enableAllFeatures() {
    for (final key in _activeFeatures.keys) {
      _activeFeatures[key] = true;
    }
    notifyListeners();
  }

  /// تعطيل جميع الخصائص
  void disableAllFeatures() {
    for (final key in _activeFeatures.keys) {
      _activeFeatures[key] = false;
    }
    notifyListeners();
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../models/layer_model.dart';
import '../models/text_style_model.dart';

class LayerProvider extends ChangeNotifier {
  List<LayerModel> _layers = [];
  LayerModel? _selectedLayer;
  int _selectedIndex = -1;
  bool _isMultiSelect = false;
  List<String> _selectedIds = [];

  // Getters
  List<LayerModel> get layers => _layers;
  LayerModel? get selectedLayer => _selectedLayer;
  int get selectedIndex => _selectedIndex;
  bool get isMultiSelect => _isMultiSelect;
  List<String> get selectedIds => _selectedIds;
  
  List<LayerModel> get visibleLayers => 
      _layers.where((l) => l.isVisible).toList();
  
  List<LayerModel> get selectedLayers =>
      _layers.where((l) => _selectedIds.contains(l.id)).toList();

  /// تعيين الطبقات
  void setLayers(List<LayerModel> layers) {
    _layers = layers;
    notifyListeners();
  }

  /// إضافة طبقة نص
  LayerModel addTextLayer({
    String text = 'نص جديد',
    TextStyleModel? style,
    double? x,
    double? y,
  }) {
    final layer = LayerModel.text(
      text: text,
      style: style,
      x: x ?? 100,
      y: y ?? 100 + (_layers.length * 50),
    );
    
    _layers.add(layer);
    selectLayer(layer.id);
    notifyListeners();
    
    return layer;
  }

  /// إضافة طبقة صورة
  Future<LayerModel?> addImageLayer() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image == null) return null;

      // حفظ الصورة
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${appDir.path}/layer_images');
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final fileName = 'img_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedPath = '${imagesDir.path}/$fileName';
      await File(image.path).copy(savedPath);

      final layer = LayerModel.image(
        imagePath: savedPath,
        x: 50,
        y: 50 + (_layers.length * 50),
        width: 300,
        height: 300,
      );
      
      _layers.add(layer);
      selectLayer(layer.id);
      notifyListeners();
      
      return layer;
    } catch (e) {
      print('Error adding image layer: $e');
      return null;
    }
  }

  /// إضافة طبقة شكل
  LayerModel addShapeLayer({
    required ShapeType shapeType,
    Color fillColor = const Color(0xFF6C63FF),
    double? x,
    double? y,
  }) {
    final layer = LayerModel.shape(
      shapeType: shapeType,
      fillColor: fillColor,
      x: x ?? 100,
      y: y ?? 100 + (_layers.length * 50),
    );
    
    _layers.add(layer);
    selectLayer(layer.id);
    notifyListeners();
    
    return layer;
  }

  /// اختيار طبقة
  void selectLayer(String? layerId) {
    if (layerId == null) {
      _selectedLayer = null;
      _selectedIndex = -1;
      _selectedIds.clear();
    } else {
      _selectedIndex = _layers.indexWhere((l) => l.id == layerId);
      _selectedLayer = _selectedIndex >= 0 ? _layers[_selectedIndex] : null;
      
      if (!_isMultiSelect) {
        _selectedIds = [layerId];
      } else {
        if (_selectedIds.contains(layerId)) {
          _selectedIds.remove(layerId);
        } else {
          _selectedIds.add(layerId);
        }
      }
      
      // تحديث حالة الاختيار
      for (var layer in _layers) {
        layer.isSelected = _selectedIds.contains(layer.id);
      }
    }
    notifyListeners();
  }

  /// تفعيل/تعطيل الاختيار المتعدد
  void toggleMultiSelect() {
    _isMultiSelect = !_isMultiSelect;
    if (!_isMultiSelect) {
      _selectedIds = _selectedLayer != null ? [_selectedLayer!.id] : [];
    }
    notifyListeners();
  }

  /// تحديث طبقة
  void updateLayer(LayerModel updatedLayer) {
    final index = _layers.indexWhere((l) => l.id == updatedLayer.id);
    if (index >= 0) {
      _layers[index] = updatedLayer;
      if (_selectedLayer?.id == updatedLayer.id) {
        _selectedLayer = updatedLayer;
      }
      notifyListeners();
    }
  }

  /// تحديث نص الطبقة
  void updateLayerText(String layerId, String text) {
    final index = _layers.indexWhere((l) => l.id == layerId);
    if (index >= 0) {
      _layers[index] = _layers[index].copyWith(text: text);
      if (_selectedLayer?.id == layerId) {
        _selectedLayer = _layers[index];
      }
      notifyListeners();
    }
  }

  /// تحديث نمط النص
  void updateTextStyle(String layerId, TextStyleModel style) {
    final index = _layers.indexWhere((l) => l.id == layerId);
    if (index >= 0) {
      _layers[index] = _layers[index].copyWith(textStyle: style);
      if (_selectedLayer?.id == layerId) {
        _selectedLayer = _layers[index];
      }
      notifyListeners();
    }
  }

  /// تحديث موقع الطبقة
  void updateLayerPosition(String layerId, double x, double y) {
    final index = _layers.indexWhere((l) => l.id == layerId);
    if (index >= 0) {
      _layers[index] = _layers[index].copyWith(x: x, y: y);
      if (_selectedLayer?.id == layerId) {
        _selectedLayer = _layers[index];
      }
      notifyListeners();
    }
  }

  /// تحديث حجم الطبقة
  void updateLayerSize(String layerId, double width, double height) {
    final index = _layers.indexWhere((l) => l.id == layerId);
    if (index >= 0) {
      _layers[index] = _layers[index].copyWith(width: width, height: height);
      if (_selectedLayer?.id == layerId) {
        _selectedLayer = _layers[index];
      }
      notifyListeners();
    }
  }

  /// تحديث دوران الطبقة
  void updateLayerRotation(String layerId, double rotation) {
    final index = _layers.indexWhere((l) => l.id == layerId);
    if (index >= 0) {
      _layers[index] = _layers[index].copyWith(rotation: rotation);
      if (_selectedLayer?.id == layerId) {
        _selectedLayer = _layers[index];
      }
      notifyListeners();
    }
  }

  /// تحديث شفافية الطبقة
  void updateLayerOpacity(String layerId, double opacity) {
    final index = _layers.indexWhere((l) => l.id == layerId);
    if (index >= 0) {
      _layers[index] = _layers[index].copyWith(opacity: opacity);
      if (_selectedLayer?.id == layerId) {
        _selectedLayer = _layers[index];
      }
      notifyListeners();
    }
  }

  /// إظهار/إخفاء طبقة
  void toggleLayerVisibility(String layerId) {
    final index = _layers.indexWhere((l) => l.id == layerId);
    if (index >= 0) {
      _layers[index] = _layers[index].copyWith(
        isVisible: !_layers[index].isVisible,
      );
      notifyListeners();
    }
  }

  /// قفل/فتح طبقة
  void toggleLayerLock(String layerId) {
    final index = _layers.indexWhere((l) => l.id == layerId);
    if (index >= 0) {
      _layers[index] = _layers[index].copyWith(
        isLocked: !_layers[index].isLocked,
      );
      notifyListeners();
    }
  }

  /// حذف طبقة
  void deleteLayer(String layerId) {
    _layers.removeWhere((l) => l.id == layerId);
    _selectedIds.remove(layerId);
    
    if (_selectedLayer?.id == layerId) {
      _selectedLayer = _layers.isNotEmpty ? _layers.last : null;
      _selectedIndex = _layers.isNotEmpty ? _layers.length - 1 : -1;
    }
    
    notifyListeners();
  }

  /// حذف الطبقات المحددة
  void deleteSelectedLayers() {
    _layers.removeWhere((l) => _selectedIds.contains(l.id));
    _selectedIds.clear();
    _selectedLayer = null;
    _selectedIndex = -1;
    notifyListeners();
  }

  /// نسخ طبقة
  void duplicateLayer(String layerId) {
    final index = _layers.indexWhere((l) => l.id == layerId);
    if (index >= 0) {
      final original = _layers[index];
      final copy = original.copyWith(
        id: null, // سيُنشأ id جديد
        x: original.x + 20,
        y: original.y + 20,
        name: '${original.name} (نسخة)',
      );
      _layers.insert(index + 1, copy);
      selectLayer(copy.id);
      notifyListeners();
    }
  }

  /// نقل طبقة للأعلى
  void moveLayerUp(String layerId) {
    final index = _layers.indexWhere((l) => l.id == layerId);
    if (index < _layers.length - 1) {
      final layer = _layers.removeAt(index);
      _layers.insert(index + 1, layer);
      notifyListeners();
    }
  }

  /// نقل طبقة للأسفل
  void moveLayerDown(String layerId) {
    final index = _layers.indexWhere((l) => l.id == layerId);
    if (index > 0) {
      final layer = _layers.removeAt(index);
      _layers.insert(index - 1, layer);
      notifyListeners();
    }
  }

  /// نقل طبقة للأعلى تماماً
  void moveLayerToTop(String layerId) {
    final index = _layers.indexWhere((l) => l.id == layerId);
    if (index >= 0 && index < _layers.length - 1) {
      final layer = _layers.removeAt(index);
      _layers.add(layer);
      notifyListeners();
    }
  }

  /// نقل طبقة للأسفل تماماً
  void moveLayerToBottom(String layerId) {
    final index = _layers.indexWhere((l) => l.id == layerId);
    if (index > 0) {
      final layer = _layers.removeAt(index);
      _layers.insert(0, layer);
      notifyListeners();
    }
  }

  /// إعادة ترتيب الطبقات
  void reorderLayers(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final layer = _layers.removeAt(oldIndex);
    _layers.insert(newIndex, layer);
    notifyListeners();
  }

  /// تحديد الكل
  void selectAll() {
    _isMultiSelect = true;
    _selectedIds = _layers.map((l) => l.id).toList();
    for (var layer in _layers) {
      layer.isSelected = true;
    }
    notifyListeners();
  }

  /// إلغاء تحديد الكل
  void deselectAll() {
    _selectedIds.clear();
    _selectedLayer = null;
    _selectedIndex = -1;
    _isMultiSelect = false;
    for (var layer in _layers) {
      layer.isSelected = false;
    }
    notifyListeners();
  }

  /// مسح كل الطبقات
  void clearAllLayers() {
    _layers.clear();
    _selectedIds.clear();
    _selectedLayer = null;
    _selectedIndex = -1;
    notifyListeners();
  }
}

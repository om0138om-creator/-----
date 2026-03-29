import 'package:flutter/material.dart';

enum ToolType {
  select,
  text,
  shape,
  image,
  draw,
  eraser,
  crop,
  hand,
}

enum ShapeToolType {
  rectangle,
  circle,
  triangle,
  star,
  polygon,
  line,
  arrow,
}

class ToolProvider extends ChangeNotifier {
  ToolType _currentTool = ToolType.select;
  ShapeToolType _shapeToolType = ShapeToolType.rectangle;
  
  // ألوان
  Color _primaryColor = const Color(0xFF6C63FF);
  Color _secondaryColor = const Color(0xFF00D9FF);
  
  // فرشاة
  double _brushSize = 5.0;
  double _brushOpacity = 1.0;
  bool _brushSmoothing = true;
  
  // ممحاة
  double _eraserSize = 20.0;
  
  // شبكة ومساعدات
  bool _showGrid = false;
  bool _snapToGrid = false;
  double _gridSize = 20.0;
  bool _showRulers = false;
  bool _showGuides = true;
  
  // تكبير
  double _zoom = 1.0;
  Offset _panOffset = Offset.zero;

  // Getters
  ToolType get currentTool => _currentTool;
  ShapeToolType get shapeToolType => _shapeToolType;
  Color get primaryColor => _primaryColor;
  Color get secondaryColor => _secondaryColor;
  double get brushSize => _brushSize;
  double get brushOpacity => _brushOpacity;
  bool get brushSmoothing => _brushSmoothing;
  double get eraserSize => _eraserSize;
  bool get showGrid => _showGrid;
  bool get snapToGrid => _snapToGrid;
  double get gridSize => _gridSize;
  bool get showRulers => _showRulers;
  bool get showGuides => _showGuides;
  double get zoom => _zoom;
  Offset get panOffset => _panOffset;

  /// تعيين الأداة الحالية
  void setTool(ToolType tool) {
    _currentTool = tool;
    notifyListeners();
  }

  /// تعيين نوع الشكل
  void setShapeToolType(ShapeToolType type) {
    _shapeToolType = type;
    notifyListeners();
  }

  /// تعيين اللون الأساسي
  void setPrimaryColor(Color color) {
    _primaryColor = color;
    notifyListeners();
  }

  /// تعيين اللون الثانوي
  void setSecondaryColor(Color color) {
    _secondaryColor = color;
    notifyListeners();
  }

  /// تبديل الألوان
  void swapColors() {
    final temp = _primaryColor;
    _primaryColor = _secondaryColor;
    _secondaryColor = temp;
    notifyListeners();
  }

  /// تعيين حجم الفرشاة
  void setBrushSize(double size) {
    _brushSize = size.clamp(1.0, 100.0);
    notifyListeners();
  }

  /// تعيين شفافية الفرشاة
  void setBrushOpacity(double opacity) {
    _brushOpacity = opacity.clamp(0.0, 1.0);
    notifyListeners();
  }

  /// تفعيل/تعطيل تنعيم الفرشاة
  void toggleBrushSmoothing() {
    _brushSmoothing = !_brushSmoothing;
    notifyListeners();
  }

  /// تعيين حجم الممحاة
  void setEraserSize(double size) {
    _eraserSize = size.clamp(5.0, 100.0);
    notifyListeners();
  }

  /// إظهار/إخفاء الشبكة
  void toggleGrid() {
    _showGrid = !_showGrid;
    notifyListeners();
  }

  /// تفعيل/تعطيل الالتقاط بالشبكة
  void toggleSnapToGrid() {
    _snapToGrid = !_snapToGrid;
    notifyListeners();
  }

  /// تعيين حجم الشبكة
  void setGridSize(double size) {
    _gridSize = size.clamp(5.0, 100.0);
    notifyListeners();
  }

  /// إظهار/إخفاء المساطر
  void toggleRulers() {
    _showRulers = !_showRulers;
    notifyListeners();
  }

  /// إظهار/إخفاء خطوط الإرشاد
  void toggleGuides() {
    _showGuides = !_showGuides;
    notifyListeners();
  }

  /// تعيين التكبير
  void setZoom(double zoom) {
    _zoom = zoom.clamp(0.1, 5.0);
    notifyListeners();
  }

  /// تكبير
  void zoomIn() {
    setZoom(_zoom * 1.2);
  }

  /// تصغير
  void zoomOut() {
    setZoom(_zoom / 1.2);
  }

  /// إعادة التكبير للوضع الطبيعي
  void resetZoom() {
    _zoom = 1.0;
    _panOffset = Offset.zero;
    notifyListeners();
  }

  /// تعيين الإزاحة
  void setPanOffset(Offset offset) {
    _panOffset = offset;
    notifyListeners();
  }

  /// تحديث الإزاحة
  void updatePanOffset(Offset delta) {
    _panOffset += delta;
    notifyListeners();
  }

  /// الالتقاط بالشبكة
  Offset snapToGridPoint(Offset point) {
    if (!_snapToGrid) return point;
    
    return Offset(
      (point.dx / _gridSize).round() * _gridSize,
      (point.dy / _gridSize).round() * _gridSize,
    );
  }
}

import 'dart:ui';
import 'package:uuid/uuid.dart';
import 'text_style_model.dart';

enum LayerType {
  text,
  image,
  shape,
  group,
}

class LayerModel {
  final String id;
  String name;
  LayerType type;
  double x;
  double y;
  double width;
  double height;
  double rotation;
  double scale;
  double opacity;
  bool isVisible;
  bool isLocked;
  bool isSelected;
  
  // للنصوص
  String? text;
  TextStyleModel? textStyle;
  
  // للصور
  String? imagePath;
  BoxFit? imageFit;
  
  // للأشكال
  ShapeType? shapeType;
  Color? fillColor;
  Color? strokeColor;
  double? strokeWidth;
  double? cornerRadius;
  
  // للمجموعات
  List<LayerModel>? children;

  LayerModel({
    String? id,
    required this.name,
    required this.type,
    this.x = 0,
    this.y = 0,
    this.width = 100,
    this.height = 100,
    this.rotation = 0,
    this.scale = 1,
    this.opacity = 1,
    this.isVisible = true,
    this.isLocked = false,
    this.isSelected = false,
    this.text,
    this.textStyle,
    this.imagePath,
    this.imageFit,
    this.shapeType,
    this.fillColor,
    this.strokeColor,
    this.strokeWidth,
    this.cornerRadius,
    this.children,
  }) : id = id ?? const Uuid().v4();

  /// إنشاء طبقة نص
  factory LayerModel.text({
    required String text,
    TextStyleModel? style,
    double x = 100,
    double y = 100,
  }) {
    return LayerModel(
      name: 'نص جديد',
      type: LayerType.text,
      x: x,
      y: y,
      width: 300,
      height: 100,
      text: text,
      textStyle: style ?? TextStyleModel(),
    );
  }

  /// إنشاء طبقة صورة
  factory LayerModel.image({
    required String imagePath,
    double x = 0,
    double y = 0,
    double width = 300,
    double height = 300,
  }) {
    return LayerModel(
      name: 'صورة جديدة',
      type: LayerType.image,
      x: x,
      y: y,
      width: width,
      height: height,
      imagePath: imagePath,
      imageFit: BoxFit.cover,
    );
  }

  /// إنشاء طبقة شكل
  factory LayerModel.shape({
    required ShapeType shapeType,
    double x = 100,
    double y = 100,
    double width = 150,
    double height = 150,
    Color fillColor = const Color(0xFF6C63FF),
    Color? strokeColor,
    double strokeWidth = 0,
    double cornerRadius = 0,
  }) {
    return LayerModel(
      name: _getShapeName(shapeType),
      type: LayerType.shape,
      x: x,
      y: y,
      width: width,
      height: height,
      shapeType: shapeType,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      cornerRadius: cornerRadius,
    );
  }

  static String _getShapeName(ShapeType type) {
    switch (type) {
      case ShapeType.rectangle:
        return 'مستطيل';
      case ShapeType.circle:
        return 'دائرة';
      case ShapeType.triangle:
        return 'مثلث';
      case ShapeType.star:
        return 'نجمة';
      case ShapeType.polygon:
        return 'مضلع';
      case ShapeType.line:
        return 'خط';
      case ShapeType.arrow:
        return 'سهم';
    }
  }

  /// نسخة من الطبقة
  LayerModel copyWith({
    String? id,
    String? name,
    LayerType? type,
    double? x,
    double? y,
    double? width,
    double? height,
    double? rotation,
    double? scale,
    double? opacity,
    bool? isVisible,
    bool? isLocked,
    bool? isSelected,
    String? text,
    TextStyleModel? textStyle,
    String? imagePath,
    BoxFit? imageFit,
    ShapeType? shapeType,
    Color? fillColor,
    Color? strokeColor,
    double? strokeWidth,
    double? cornerRadius,
    List<LayerModel>? children,
  }) {
    return LayerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      rotation: rotation ?? this.rotation,
      scale: scale ?? this.scale,
      opacity: opacity ?? this.opacity,
      isVisible: isVisible ?? this.isVisible,
      isLocked: isLocked ?? this.isLocked,
      isSelected: isSelected ?? this.isSelected,
      text: text ?? this.text,
      textStyle: textStyle ?? this.textStyle?.copyWith(),
      imagePath: imagePath ?? this.imagePath,
      imageFit: imageFit ?? this.imageFit,
      shapeType: shapeType ?? this.shapeType,
      fillColor: fillColor ?? this.fillColor,
      strokeColor: strokeColor ?? this.strokeColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      children: children ?? this.children?.map((c) => c.copyWith()).toList(),
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.index,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'rotation': rotation,
      'scale': scale,
      'opacity': opacity,
      'isVisible': isVisible,
      'isLocked': isLocked,
      'text': text,
      'textStyle': textStyle?.toJson(),
      'imagePath': imagePath,
      'imageFit': imageFit?.index,
      'shapeType': shapeType?.index,
      'fillColor': fillColor?.value,
      'strokeColor': strokeColor?.value,
      'strokeWidth': strokeWidth,
      'cornerRadius': cornerRadius,
      'children': children?.map((c) => c.toJson()).toList(),
    };
  }

  /// من JSON
  factory LayerModel.fromJson(Map<String, dynamic> json) {
    return LayerModel(
      id: json['id'],
      name: json['name'],
      type: LayerType.values[json['type']],
      x: json['x']?.toDouble() ?? 0,
      y: json['y']?.toDouble() ?? 0,
      width: json['width']?.toDouble() ?? 100,
      height: json['height']?.toDouble() ?? 100,
      rotation: json['rotation']?.toDouble() ?? 0,
      scale: json['scale']?.toDouble() ?? 1,
      opacity: json['opacity']?.toDouble() ?? 1,
      isVisible: json['isVisible'] ?? true,
      isLocked: json['isLocked'] ?? false,
      text: json['text'],
      textStyle: json['textStyle'] != null
          ? TextStyleModel.fromJson(json['textStyle'])
          : null,
      imagePath: json['imagePath'],
      imageFit: json['imageFit'] != null
          ? BoxFit.values[json['imageFit']]
          : null,
      shapeType: json['shapeType'] != null
          ? ShapeType.values[json['shapeType']]
          : null,
      fillColor: json['fillColor'] != null
          ? Color(json['fillColor'])
          : null,
      strokeColor: json['strokeColor'] != null
          ? Color(json['strokeColor'])
          : null,
      strokeWidth: json['strokeWidth']?.toDouble(),
      cornerRadius: json['cornerRadius']?.toDouble(),
      children: json['children'] != null
          ? (json['children'] as List)
              .map((c) => LayerModel.fromJson(c))
              .toList()
          : null,
    );
  }
}

enum ShapeType {
  rectangle,
  circle,
  triangle,
  star,
  polygon,
  line,
  arrow,
}

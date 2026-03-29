import 'dart:ui';
import 'package:flutter/material.dart';

class TextStyleModel {
  String fontFamily;
  String? fontPath; // مسار الخط المخصص
  double fontSize;
  FontWeight fontWeight;
  FontStyle fontStyle;
  Color color;
  Color? backgroundColor;
  double letterSpacing;
  double wordSpacing;
  double height;
  TextAlign textAlign;
  TextDirection textDirection;
  
  // تأثيرات النص
  bool hasShadow;
  Color shadowColor;
  double shadowBlurRadius;
  Offset shadowOffset;
  
  bool hasStroke;
  Color strokeColor;
  double strokeWidth;
  
  bool hasGradient;
  List<Color> gradientColors;
  GradientType gradientType;
  
  // خصائص OpenType المفعلة
  Map<String, bool> openTypeFeatures;
  
  // متغيرات Variable Font
  Map<String, double> variableAxes;

  TextStyleModel({
    this.fontFamily = 'Cairo',
    this.fontPath,
    this.fontSize = 32,
    this.fontWeight = FontWeight.normal,
    this.fontStyle = FontStyle.normal,
    this.color = Colors.white,
    this.backgroundColor,
    this.letterSpacing = 0,
    this.wordSpacing = 0,
    this.height = 1.5,
    this.textAlign = TextAlign.center,
    this.textDirection = TextDirection.rtl,
    this.hasShadow = false,
    this.shadowColor = Colors.black54,
    this.shadowBlurRadius = 4,
    this.shadowOffset = const Offset(2, 2),
    this.hasStroke = false,
    this.strokeColor = Colors.black,
    this.strokeWidth = 2,
    this.hasGradient = false,
    this.gradientColors = const [Color(0xFF6C63FF), Color(0xFF00D9FF)],
    this.gradientType = GradientType.linear,
    Map<String, bool>? openTypeFeatures,
    Map<String, double>? variableAxes,
  })  : openTypeFeatures = openTypeFeatures ?? {},
        variableAxes = variableAxes ?? {};

  /// تحويل إلى TextStyle Flutter
  TextStyle toTextStyle() {
    List<Shadow>? shadows;
    if (hasShadow) {
      shadows = [
        Shadow(
          color: shadowColor,
          blurRadius: shadowBlurRadius,
          offset: shadowOffset,
        ),
      ];
    }

    // بناء قائمة FontFeature من openTypeFeatures
    List<FontFeature> fontFeatures = [];
    openTypeFeatures.forEach((tag, enabled) {
      if (enabled) {
        fontFeatures.add(FontFeature.enable(tag));
      } else {
        fontFeatures.add(FontFeature.disable(tag));
      }
    });

    // بناء قائمة FontVariation من variableAxes
    List<FontVariation> fontVariations = [];
    variableAxes.forEach((axis, value) {
      fontVariations.add(FontVariation(axis, value));
    });

    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      color: hasGradient ? null : color,
      backgroundColor: backgroundColor,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      height: height,
      shadows: shadows,
      fontFeatures: fontFeatures.isNotEmpty ? fontFeatures : null,
      fontVariations: fontVariations.isNotEmpty ? fontVariations : null,
    );
  }

  /// نسخة من النموذج
  TextStyleModel copyWith({
    String? fontFamily,
    String? fontPath,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    Color? color,
    Color? backgroundColor,
    double? letterSpacing,
    double? wordSpacing,
    double? height,
    TextAlign? textAlign,
    TextDirection? textDirection,
    bool? hasShadow,
    Color? shadowColor,
    double? shadowBlurRadius,
    Offset? shadowOffset,
    bool? hasStroke,
    Color? strokeColor,
    double? strokeWidth,
    bool? hasGradient,
    List<Color>? gradientColors,
    GradientType? gradientType,
    Map<String, bool>? openTypeFeatures,
    Map<String, double>? variableAxes,
  }) {
    return TextStyleModel(
      fontFamily: fontFamily ?? this.fontFamily,
      fontPath: fontPath ?? this.fontPath,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      fontStyle: fontStyle ?? this.fontStyle,
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      wordSpacing: wordSpacing ?? this.wordSpacing,
      height: height ?? this.height,
      textAlign: textAlign ?? this.textAlign,
      textDirection: textDirection ?? this.textDirection,
      hasShadow: hasShadow ?? this.hasShadow,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowBlurRadius: shadowBlurRadius ?? this.shadowBlurRadius,
      shadowOffset: shadowOffset ?? this.shadowOffset,
      hasStroke: hasStroke ?? this.hasStroke,
      strokeColor: strokeColor ?? this.strokeColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      hasGradient: hasGradient ?? this.hasGradient,
      gradientColors: gradientColors ?? List.from(this.gradientColors),
      gradientType: gradientType ?? this.gradientType,
      openTypeFeatures: openTypeFeatures ?? Map.from(this.openTypeFeatures),
      variableAxes: variableAxes ?? Map.from(this.variableAxes),
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'fontFamily': fontFamily,
      'fontPath': fontPath,
      'fontSize': fontSize,
      'fontWeight': fontWeight.index,
      'fontStyle': fontStyle.index,
      'color': color.value,
      'backgroundColor': backgroundColor?.value,
      'letterSpacing': letterSpacing,
      'wordSpacing': wordSpacing,
      'height': height,
      'textAlign': textAlign.index,
      'textDirection': textDirection.index,
      'hasShadow': hasShadow,
      'shadowColor': shadowColor.value,
      'shadowBlurRadius': shadowBlurRadius,
      'shadowOffsetX': shadowOffset.dx,
      'shadowOffsetY': shadowOffset.dy,
      'hasStroke': hasStroke,
      'strokeColor': strokeColor.value,
      'strokeWidth': strokeWidth,
      'hasGradient': hasGradient,
      'gradientColors': gradientColors.map((c) => c.value).toList(),
      'gradientType': gradientType.index,
      'openTypeFeatures': openTypeFeatures,
      'variableAxes': variableAxes,
    };
  }

  /// من JSON
  factory TextStyleModel.fromJson(Map<String, dynamic> json) {
    return TextStyleModel(
      fontFamily: json['fontFamily'] ?? 'Cairo',
      fontPath: json['fontPath'],
      fontSize: json['fontSize']?.toDouble() ?? 32,
      fontWeight: FontWeight.values[json['fontWeight'] ?? 3],
      fontStyle: FontStyle.values[json['fontStyle'] ?? 0],
      color: Color(json['color'] ?? 0xFFFFFFFF),
      backgroundColor:
          json['backgroundColor'] != null ? Color(json['backgroundColor']) : null,
      letterSpacing: json['letterSpacing']?.toDouble() ?? 0,
      wordSpacing: json['wordSpacing']?.toDouble() ?? 0,
      height: json['height']?.toDouble() ?? 1.5,
      textAlign: TextAlign.values[json['textAlign'] ?? 2],
      textDirection: TextDirection.values[json['textDirection'] ?? 1],
      hasShadow: json['hasShadow'] ?? false,
      shadowColor: Color(json['shadowColor'] ?? 0x88000000),
      shadowBlurRadius: json['shadowBlurRadius']?.toDouble() ?? 4,
      shadowOffset: Offset(
        json['shadowOffsetX']?.toDouble() ?? 2,
        json['shadowOffsetY']?.toDouble() ?? 2,
      ),
      hasStroke: json['hasStroke'] ?? false,
      strokeColor: Color(json['strokeColor'] ?? 0xFF000000),
      strokeWidth: json['strokeWidth']?.toDouble() ?? 2,
      hasGradient: json['hasGradient'] ?? false,
      gradientColors: json['gradientColors'] != null
          ? (json['gradientColors'] as List).map((c) => Color(c)).toList()
          : const [Color(0xFF6C63FF), Color(0xFF00D9FF)],
      gradientType: GradientType.values[json['gradientType'] ?? 0],
      openTypeFeatures: json['openTypeFeatures'] != null
          ? Map<String, bool>.from(json['openTypeFeatures'])
          : {},
      variableAxes: json['variableAxes'] != null
          ? Map<String, double>.from(json['variableAxes'])
          : {},
    );
  }
}

enum GradientType {
  linear,
  radial,
  sweep,
}

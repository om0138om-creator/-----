import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/models/layer_model.dart';
import '../../../core/models/text_style_model.dart';

class CanvasLayer extends StatefulWidget {
  final LayerModel layer;
  final bool isSelected;
  final VoidCallback onSelect;
  final Function(LayerModel) onUpdate;

  const CanvasLayer({
    super.key,
    required this.layer,
    required this.isSelected,
    required this.onSelect,
    required this.onUpdate,
  });

  @override
  State<CanvasLayer> createState() => _CanvasLayerState();
}

class _CanvasLayerState extends State<CanvasLayer> {
  late Offset _position;
  late double _rotation;
  late double _scale;
  Offset _startPosition = Offset.zero;
  double _startRotation = 0;
  double _startScale = 1;

  @override
  void initState() {
    super.initState();
    _position = Offset(widget.layer.x, widget.layer.y);
    _rotation = widget.layer.rotation;
    _scale = widget.layer.scale;
  }

  @override
  void didUpdateWidget(CanvasLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.layer.id != widget.layer.id) {
      _position = Offset(widget.layer.x, widget.layer.y);
      _rotation = widget.layer.rotation;
      _scale = widget.layer.scale;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onTap: widget.onSelect,
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: Transform.rotate(
          angle: _rotation * (math.pi / 180),
          child: Transform.scale(
            scale: _scale,
            child: Opacity(
              opacity: widget.layer.opacity,
              child: Stack(
                children: [
                  // Layer Content
                  _buildLayerContent(),
                  
                  // Selection Border
                  if (widget.isSelected) _buildSelectionBorder(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLayerContent() {
    switch (widget.layer.type) {
      case LayerType.text:
        return _buildTextLayer();
      case LayerType.image:
        return _buildImageLayer();
      case LayerType.shape:
        return _buildShapeLayer();
      case LayerType.group:
        return _buildGroupLayer();
    }
  }

  Widget _buildTextLayer() {
    final textStyle = widget.layer.textStyle ?? TextStyleModel();
    
    Widget textWidget = Text(
      widget.layer.text ?? '',
      style: textStyle.toTextStyle(),
      textAlign: textStyle.textAlign,
      textDirection: textStyle.textDirection,
    );

    // Stroke Effect
    if (textStyle.hasStroke) {
      textWidget = Stack(
        children: [
          // Stroke
          Text(
            widget.layer.text ?? '',
            style: textStyle.toTextStyle().copyWith(
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = textStyle.strokeWidth
                ..color = textStyle.strokeColor,
            ),
            textAlign: textStyle.textAlign,
            textDirection: textStyle.textDirection,
          ),
          // Fill
          textWidget,
        ],
      );
    }

    // Gradient Effect
    if (textStyle.hasGradient) {
      textWidget = ShaderMask(
        shaderCallback: (bounds) {
          return _getGradient(textStyle, bounds).createShader(bounds);
        },
        child: Text(
          widget.layer.text ?? '',
          style: textStyle.toTextStyle().copyWith(color: Colors.white),
          textAlign: textStyle.textAlign,
          textDirection: textStyle.textDirection,
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(
        maxWidth: widget.layer.width,
      ),
      child: textWidget,
    );
  }

  Gradient _getGradient(TextStyleModel style, Rect bounds) {
    switch (style.gradientType) {
      case GradientType.linear:
        return LinearGradient(colors: style.gradientColors);
      case GradientType.radial:
        return RadialGradient(colors: style.gradientColors);
      case GradientType.sweep:
        return SweepGradient(colors: style.gradientColors);
    }
  }

  Widget _buildImageLayer() {
    if (widget.layer.imagePath == null) {
      return Container(
        width: widget.layer.width,
        height: widget.layer.height,
        color: Colors.grey.withOpacity(0.3),
        child: const Icon(Icons.image, size: 50),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.layer.cornerRadius ?? 0),
      child: Image.file(
        File(widget.layer.imagePath!),
        width: widget.layer.width,
        height: widget.layer.height,
        fit: widget.layer.imageFit ?? BoxFit.cover,
      ),
    );
  }

  Widget _buildShapeLayer() {
    return CustomPaint(
      size: Size(widget.layer.width, widget.layer.height),
      painter: ShapePainter(
        shapeType: widget.layer.shapeType ?? ShapeType.rectangle,
        fillColor: widget.layer.fillColor ?? AppTheme.primaryColor,
        strokeColor: widget.layer.strokeColor,
        strokeWidth: widget.layer.strokeWidth ?? 0,
        cornerRadius: widget.layer.cornerRadius ?? 0,
      ),
    );
  }

  Widget _buildGroupLayer() {
    return SizedBox(
      width: widget.layer.width,
      height: widget.layer.height,
      child: Stack(
        children: widget.layer.children?.map((child) {
          return CanvasLayer(
            layer: child,
            isSelected: false,
            onSelect: () {},
            onUpdate: (updated) {},
          );
        }).toList() ?? [],
      ),
    );
  }

  Widget _buildSelectionBorder() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.primaryColor,
            width: 2,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Corner handles
            _buildHandle(Alignment.topLeft),
            _buildHandle(Alignment.topRight),
            _buildHandle(Alignment.bottomLeft),
            _buildHandle(Alignment.bottomRight),
            
            // Edge handles
            _buildHandle(Alignment.topCenter),
            _buildHandle(Alignment.bottomCenter),
            _buildHandle(Alignment.centerLeft),
            _buildHandle(Alignment.centerRight),
            
            // Rotation handle
            Positioned(
              top: -40,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onPanUpdate: _onRotate,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.rotate_right,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle(Alignment alignment) {
    double? top, bottom, left, right;
    
    if (alignment.y == -1) top = -6;
    if (alignment.y == 1) bottom = -6;
    if (alignment.y == 0) {
      top = 0;
      bottom = 0;
    }
    
    if (alignment.x == -1) left = -6;
    if (alignment.x == 1) right = -6;
    if (alignment.x == 0) {
      left = 0;
      right = 0;
    }

    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: GestureDetector(
        onPanUpdate: (details) => _onResize(details, alignment),
        child: Center(
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppTheme.primaryColor, width: 2),
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    if (widget.layer.isLocked) return;
    _startPosition = _position;
    widget.onSelect();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (widget.layer.isLocked) return;
    
    setState(() {
      _position = Offset(
        _position.dx + details.delta.dx,
        _position.dy + details.delta.dy,
      );
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (widget.layer.isLocked) return;
    
    widget.onUpdate(widget.layer.copyWith(
      x: _position.dx,
      y: _position.dy,
    ));
  }

  void _onRotate(DragUpdateDetails details) {
    if (widget.layer.isLocked) return;
    
    setState(() {
      _rotation += details.delta.dx;
    });
    
    widget.onUpdate(widget.layer.copyWith(rotation: _rotation));
  }

  void _onResize(DragUpdateDetails details, Alignment alignment) {
    if (widget.layer.isLocked) return;
    
    double newWidth = widget.layer.width;
    double newHeight = widget.layer.height;
    double newX = widget.layer.x;
    double newY = widget.layer.y;
    
    if (alignment.x == 1) {
      newWidth += details.delta.dx;
    } else if (alignment.x == -1) {
      newWidth -= details.delta.dx;
      newX += details.delta.dx;
    }
    
    if (alignment.y == 1) {
      newHeight += details.delta.dy;
    } else if (alignment.y == -1) {
      newHeight -= details.delta.dy;
      newY += details.delta.dy;
    }
    
    if (newWidth > 10 && newHeight > 10) {
      widget.onUpdate(widget.layer.copyWith(
        x: newX,
        y: newY,
        width: newWidth,
        height: newHeight,
      ));
    }
  }
}

class ShapePainter extends CustomPainter {
  final ShapeType shapeType;
  final Color fillColor;
  final Color? strokeColor;
  final double strokeWidth;
  final double cornerRadius;

  ShapePainter({
    required this.shapeType,
    required this.fillColor,
    this.strokeColor,
    required this.strokeWidth,
    required this.cornerRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = strokeColor ?? Colors.transparent
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    switch (shapeType) {
      case ShapeType.rectangle:
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(cornerRadius),
        );
        canvas.drawRRect(rect, fillPaint);
        if (strokeWidth > 0) canvas.drawRRect(rect, strokePaint);
        break;

      case ShapeType.circle:
        final center = Offset(size.width / 2, size.height / 2);
        final radius = math.min(size.width, size.height) / 2;
        canvas.drawCircle(center, radius, fillPaint);
        if (strokeWidth > 0) canvas.drawCircle(center, radius, strokePaint);
        break;

      case ShapeType.triangle:
        final path = Path()
          ..moveTo(size.width / 2, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();
        canvas.drawPath(path, fillPaint);
        if (strokeWidth > 0) canvas.drawPath(path, strokePaint);
        break;

      case ShapeType.star:
        final path = _createStarPath(size, 5, 0.5);
        canvas.drawPath(path, fillPaint);
        if (strokeWidth > 0) canvas.drawPath(path, strokePaint);
        break;

      case ShapeType.polygon:
        final path = _createPolygonPath(size, 6);
        canvas.drawPath(path, fillPaint);
        if (strokeWidth > 0) canvas.drawPath(path, strokePaint);
        break;

      case ShapeType.line:
        canvas.drawLine(
          Offset(0, size.height / 2),
          Offset(size.width, size.height / 2),
          strokePaint..strokeWidth = math.max(strokeWidth, 2),
        );
        break;

      case ShapeType.arrow:
        _drawArrow(canvas, size, strokePaint..strokeWidth = math.max(strokeWidth, 2));
        break;
    }
  }

  Path _createStarPath(Size size, int points, double innerRadiusRatio) {
    final path = Path();
    final cx = size.width / 2;
    final cy = size.height / 2;
    final outerRadius = math.min(cx, cy);
    final innerRadius = outerRadius * innerRadiusRatio;

    for (int i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = (i * math.pi / points) - math.pi / 2;
      final x = cx + radius * math.cos(angle);
      final y = cy + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  Path _createPolygonPath(Size size, int sides) {
    final path = Path();
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = math.min(cx, cy);

    for (int i = 0; i < sides; i++) {
      final angle = (i * 2 * math.pi / sides) - math.pi / 2;
      final x = cx + radius * math.cos(angle);
      final y = cy + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  void _drawArrow(Canvas canvas, Size size, Paint paint) {
    final startX = 0.0;
    final endX = size.width;
    final y = size.height / 2;
    final arrowSize = 15.0;

    // Line
    canvas.drawLine(Offset(startX, y), Offset(endX - arrowSize, y), paint);

    // Arrow head
    final path = Path()
      ..moveTo(endX, y)
      ..lineTo(endX - arrowSize, y - arrowSize / 2)
      ..lineTo(endX - arrowSize, y + arrowSize / 2)
      ..close();
    canvas.drawPath(path, paint..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant ShapePainter oldDelegate) {
    return oldDelegate.shapeType != shapeType ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.strokeColor != strokeColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.cornerRadius != cornerRadius;
  }
}

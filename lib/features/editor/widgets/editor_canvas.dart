import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/providers/layer_provider.dart';
import '../../../core/providers/tool_provider.dart';
import '../../../core/models/project_model.dart';
import '../../../core/models/layer_model.dart';
import 'canvas_layer.dart';

class EditorCanvas extends StatelessWidget {
  final ProjectModel project;

  const EditorCanvas({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<LayerProvider, ToolProvider>(
      builder: (context, layerProvider, toolProvider, child) {
        return Container(
          width: project.canvasWidth,
          height: project.canvasHeight,
          decoration: BoxDecoration(
            color: project.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipRect(
            child: Stack(
              children: [
                // Background Image
                if (project.backgroundImage != null)
                  Positioned.fill(
                    child: Image.file(
                      File(project.backgroundImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                
                // Grid
                if (toolProvider.showGrid)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: GridPainter(
                        gridSize: toolProvider.gridSize,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                
                // Layers
                ...layerProvider.layers.map((layer) {
                  if (!layer.isVisible) return const SizedBox.shrink();
                  
                  return CanvasLayer(
                    layer: layer,
                    isSelected: layerProvider.selectedLayer?.id == layer.id,
                    onSelect: () {
                      if (!layer.isLocked) {
                        layerProvider.selectLayer(layer.id);
                      }
                    },
                    onUpdate: (updatedLayer) {
                      layerProvider.updateLayer(updatedLayer);
                    },
                  );
                }).toList(),
                
                // Center Guides
                if (toolProvider.showGuides)
                  _buildGuides(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGuides() {
    return Stack(
      children: [
        // Horizontal Center
        Positioned(
          left: 0,
          right: 0,
          top: project.canvasHeight / 2,
          child: Container(
            height: 1,
            color: AppTheme.primaryColor.withOpacity(0.3),
          ),
        ),
        // Vertical Center
        Positioned(
          top: 0,
          bottom: 0,
          left: project.canvasWidth / 2,
          child: Container(
            width: 1,
            color: AppTheme.primaryColor.withOpacity(0.3),
          ),
        ),
      ],
    );
  }
}

class GridPainter extends CustomPainter {
  final double gridSize;
  final Color color;

  GridPainter({
    required this.gridSize,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;

    // Vertical lines
    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) {
    return oldDelegate.gridSize != gridSize || oldDelegate.color != color;
  }
}

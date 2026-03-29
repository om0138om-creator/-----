import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/providers/tool_provider.dart';
import '../../../core/providers/layer_provider.dart';
import '../../../core/models/layer_model.dart';

class BottomTools extends StatelessWidget {
  const BottomTools({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ToolProvider>(
      builder: (context, toolProvider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTool(
                context,
                icon: Icons.pan_tool_outlined,
                label: 'تحديد',
                isSelected: toolProvider.currentTool == ToolType.select,
                onTap: () => toolProvider.setTool(ToolType.select),
              ),
              _buildTool(
                context,
                icon: Icons.text_fields,
                label: 'نص',
                isSelected: toolProvider.currentTool == ToolType.text,
                onTap: () {
                  toolProvider.setTool(ToolType.text);
                  _addTextLayer(context);
                },
              ),
              _buildTool(
                context,
                icon: Icons.image_outlined,
                label: 'صورة',
                isSelected: toolProvider.currentTool == ToolType.image,
                onTap: () {
                  toolProvider.setTool(ToolType.image);
                  _addImageLayer(context);
                },
              ),
              _buildTool(
                context,
                icon: Icons.category_outlined,
                label: 'أشكال',
                isSelected: toolProvider.currentTool == ToolType.shape,
                onTap: () => _showShapesMenu(context, toolProvider),
              ),
              _buildTool(
                context,
                icon: Icons.brush_outlined,
                label: 'رسم',
                isSelected: toolProvider.currentTool == ToolType.draw,
                onTap: () => toolProvider.setTool(ToolType.draw),
              ),
              _buildTool(
                context,
                icon: Icons.grid_on,
                label: 'شبكة',
                isSelected: toolProvider.showGrid,
                onTap: () => toolProvider.toggleGrid(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTool(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppTheme.primaryColor.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: AppTheme.primaryColor, width: 1)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryColor : Colors.white70,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? AppTheme.primaryColor : Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addTextLayer(BuildContext context) {
    context.read<LayerProvider>().addTextLayer();
  }

  void _addImageLayer(BuildContext context) {
    context.read<LayerProvider>().addImageLayer();
  }

  void _showShapesMenu(BuildContext context, ToolProvider toolProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'اختر شكلاً',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 15,
              runSpacing: 15,
              children: [
                _buildShapeOption(
                  context,
                  icon: Icons.square_outlined,
                  label: 'مستطيل',
                  shapeType: ShapeType.rectangle,
                ),
                _buildShapeOption(
                  context,
                  icon: Icons.circle_outlined,
                  label: 'دائرة',
                  shapeType: ShapeType.circle,
                ),
                _buildShapeOption(
                  context,
                  icon: Icons.change_history,
                  label: 'مثلث',
                  shapeType: ShapeType.triangle,
                ),
                _buildShapeOption(
                  context,
                  icon: Icons.star_outline,
                  label: 'نجمة',
                  shapeType: ShapeType.star,
                ),
                _buildShapeOption(
                  context,
                  icon: Icons.hexagon_outlined,
                  label: 'مضلع',
                  shapeType: ShapeType.polygon,
                ),
                _buildShapeOption(
                  context,
                  icon: Icons.horizontal_rule,
                  label: 'خط',
                  shapeType: ShapeType.line,
                ),
                _buildShapeOption(
                  context,
                  icon: Icons.arrow_forward,
                  label: 'سهم',
                  shapeType: ShapeType.arrow,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildShapeOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required ShapeType shapeType,
  }) {
    return GestureDetector(
      onTap: () {
        context.read<LayerProvider>().addShapeLayer(shapeType: shapeType);
        Navigator.pop(context);
      },
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/providers/layer_provider.dart';
import '../../../core/models/layer_model.dart';
import '../../../core/models/text_style_model.dart';

class PropertiesPanel extends StatelessWidget {
  const PropertiesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LayerProvider>(
      builder: (context, provider, child) {
        final layer = provider.selectedLayer;
        
        if (layer == null) {
          return _buildNoSelection();
        }
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(layer),
              const SizedBox(height: 20),
              
              // Transform Section
              _buildSection(
                title: 'التحويل',
                children: [
                  _buildPositionControls(context, provider, layer),
                  const SizedBox(height: 12),
                  _buildSizeControls(context, provider, layer),
                  const SizedBox(height: 12),
                  _buildRotationControl(context, provider, layer),
                  const SizedBox(height: 12),
                  _buildOpacityControl(context, provider, layer),
                ],
              ),
              
              // Type-specific properties
              if (layer.type == LayerType.text)
                _buildTextProperties(context, provider, layer),
              
              if (layer.type == LayerType.shape)
                _buildShapeProperties(context, provider, layer),
              
              if (layer.type == LayerType.image)
                _buildImageProperties(context, provider, layer),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoSelection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.touch_app_outlined,
            size: 48,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 12),
          Text(
            'اختر طبقة',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'لعرض خصائصها',
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(LayerModel layer) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _getLayerIcon(layer.type),
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'الخصائص',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                layer.name,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getLayerIcon(LayerType type) {
    switch (type) {
      case LayerType.text:
        return Icons.text_fields;
      case LayerType.image:
        return Icons.image;
      case LayerType.shape:
        return Icons.category;
      case LayerType.group:
        return Icons.folder;
    }
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 12),
        ...children,
        const SizedBox(height: 20),
        Divider(color: Colors.white.withOpacity(0.1)),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildPositionControls(
    BuildContext context,
    LayerProvider provider,
    LayerModel layer,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildNumberField(
            label: 'X',
            value: layer.x,
            onChanged: (value) {
              provider.updateLayerPosition(layer.id, value, layer.y);
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildNumberField(
            label: 'Y',
            value: layer.y,
            onChanged: (value) {
              provider.updateLayerPosition(layer.id, layer.x, value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSizeControls(
    BuildContext context,
    LayerProvider provider,
    LayerModel layer,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildNumberField(
            label: 'العرض',
            value: layer.width,
            onChanged: (value) {
              provider.updateLayerSize(layer.id, value, layer.height);
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildNumberField(
            label: 'الارتفاع',
            value: layer.height,
            onChanged: (value) {
              provider.updateLayerSize(layer.id, layer.width, value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRotationControl(
    BuildContext context,
    LayerProvider provider,
    LayerModel layer,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('الدوران', style: TextStyle(fontSize: 12)),
            Text(
              '${layer.rotation.toStringAsFixed(0)}°',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
          ),
          child: Slider(
            value: layer.rotation,
            min: -180,
            max: 180,
            onChanged: (value) {
              provider.updateLayerRotation(layer.id, value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOpacityControl(
    BuildContext context,
    LayerProvider provider,
    LayerModel layer,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('الشفافية', style: TextStyle(fontSize: 12)),
            Text(
              '${(layer.opacity * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
          ),
          child: Slider(
            value: layer.opacity,
            min: 0,
            max: 1,
            onChanged: (value) {
              provider.updateLayerOpacity(layer.id, value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextProperties(
    BuildContext context,
    LayerProvider provider,
    LayerModel layer,
  ) {
    final style = layer.textStyle ?? TextStyleModel();
    
    return _buildSection(
      title: 'النص',
      children: [
        // Font Size
        _buildNumberField(
          label: 'حجم الخط',
          value: style.fontSize,
          onChanged: (value) {
            provider.updateTextStyle(
              layer.id,
              style.copyWith(fontSize: value),
            );
          },
        ),
        const SizedBox(height: 12),
        
        // Letter Spacing
        _buildNumberField(
          label: 'تباعد الحروف',
          value: style.letterSpacing,
          min: -20,
          max: 50,
          onChanged: (value) {
            provider.updateTextStyle(
              layer.id,
              style.copyWith(letterSpacing: value),
            );
          },
        ),
        const SizedBox(height: 12),
        
        // Line Height
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ارتفاع السطر', style: TextStyle(fontSize: 12)),
                Text(
                  style.height.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Slider(
              value: style.height,
              min: 0.5,
              max: 3,
              onChanged: (value) {
                provider.updateTextStyle(
                  layer.id,
                  style.copyWith(height: value),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Text Color
        _buildColorPicker(
          context: context,
          label: 'لون النص',
          color: style.color,
          onChanged: (color) {
            provider.updateTextStyle(
              layer.id,
              style.copyWith(color: color),
            );
          },
        ),
        const SizedBox(height: 12),
        
        // Text Alignment
        Row(
          children: [
            const Text('المحاذاة', style: TextStyle(fontSize: 12)),
            const Spacer(),
            _buildAlignmentButton(
              icon: Icons.format_align_right,
              isSelected: style.textAlign == TextAlign.right,
              onTap: () {
                provider.updateTextStyle(
                  layer.id,
                  style.copyWith(textAlign: TextAlign.right),
                );
              },
            ),
            _buildAlignmentButton(
              icon: Icons.format_align_center,
              isSelected: style.textAlign == TextAlign.center,
              onTap: () {
                provider.updateTextStyle(
                  layer.id,
                  style.copyWith(textAlign: TextAlign.center),
                );
              },
            ),
            _buildAlignmentButton(
              icon: Icons.format_align_left,
              isSelected: style.textAlign == TextAlign.left,
              onTap: () {
                provider.updateTextStyle(
                  layer.id,
                  style.copyWith(textAlign: TextAlign.left),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAlignmentButton({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppTheme.primaryColor.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isSelected ? AppTheme.primaryColor : Colors.white54,
        ),
      ),
    );
  }

  Widget _buildShapeProperties(
    BuildContext context,
    LayerProvider provider,
    LayerModel layer,
  ) {
    return _buildSection(
      title: 'الشكل',
      children: [
        // Fill Color
        _buildColorPicker(
          context: context,
          label: 'لون التعبئة',
          color: layer.fillColor ?? AppTheme.primaryColor,
          onChanged: (color) {
            provider.updateLayer(layer.copyWith(fillColor: color));
          },
        ),
        const SizedBox(height: 12),
        
        // Corner Radius (for rectangle)
        if (layer.shapeType == ShapeType.rectangle)
          _buildNumberField(
            label: 'نصف قطر الزوايا',
            value: layer.cornerRadius ?? 0,
            min: 0,
            max: 100,
            onChanged: (value) {
              provider.updateLayer(layer.copyWith(cornerRadius: value));
            },
          ),
      ],
    );
  }

  Widget _buildImageProperties(
    BuildContext context,
    LayerProvider provider,
    LayerModel layer,
  ) {
    return _buildSection(
      title: 'الصورة',
      children: [
        // Corner Radius
        _buildNumberField(
          label: 'نصف قطر الزوايا',
          value: layer.cornerRadius ?? 0,
          min: 0,
          max: 100,
          onChanged: (value) {
            provider.updateLayer(layer.copyWith(cornerRadius: value));
          },
        ),
      ],
    );
  }

  Widget _buildNumberField({
    required String label,
    required double value,
    double min = 0,
    double max = 2000,
    required Function(double) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 6),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: TextEditingController(text: value.toStringAsFixed(0)),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
            ),
            onSubmitted: (text) {
              final newValue = double.tryParse(text);
              if (newValue != null) {
                onChanged(newValue.clamp(min, max));
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildColorPicker({
    required BuildContext context,
    required String label,
    required Color color,
    required Function(Color) onChanged,
  }) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const Spacer(),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(label),
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: color,
                    onColorChanged: onChanged,
                    pickerAreaHeightPercent: 0.8,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('تم'),
                  ),
                ],
              ),
            );
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

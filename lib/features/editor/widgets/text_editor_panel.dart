import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/providers/layer_provider.dart';
import '../../../core/providers/font_provider.dart';
import '../../../core/models/layer_model.dart';
import '../../../core/models/text_style_model.dart';

class TextEditorPanel extends StatefulWidget {
  final LayerModel layer;

  const TextEditorPanel({
    super.key,
    required this.layer,
  });

  @override
  State<TextEditorPanel> createState() => _TextEditorPanelState();
}

class _TextEditorPanelState extends State<TextEditorPanel> {
  late TextEditingController _textController;
  late TextStyleModel _style;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.layer.text);
    _style = widget.layer.textStyle ?? TextStyleModel();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'تحرير النص',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _saveChanges,
                  child: const Text('حفظ'),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text Input
                  _buildTextInput(),
                  const SizedBox(height: 20),
                  
                  // Font Selection
                  _buildFontSelection(),
                  const SizedBox(height: 20),
                  
                  // Font Size & Weight
                  _buildFontSizeWeight(),
                  const SizedBox(height: 20),
                  
                  // Colors
                  _buildColors(),
                  const SizedBox(height: 20),
                  
                  // Text Alignment
                  _buildAlignment(),
                  const SizedBox(height: 20),
                  
                  // Spacing
                  _buildSpacing(),
                  const SizedBox(height: 20),
                  
                  // Effects
                  _buildEffects(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'النص',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _textController,
          maxLines: 5,
          minLines: 3,
          textDirection: _style.textDirection,
          style: TextStyle(
            fontFamily: _style.fontFamily,
            fontSize: 18,
          ),
          decoration: InputDecoration(
            hintText: 'اكتب النص هنا...',
            filled: true,
            fillColor: AppTheme.cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFontSelection() {
    return Consumer<FontProvider>(
      builder: (context, fontProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الخط',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _style.fontFamily,
                  isExpanded: true,
                  dropdownColor: AppTheme.cardColor,
                  items: fontProvider.fonts.map((font) {
                    return DropdownMenuItem(
                      value: font.family,
                      child: Text(
                        font.name,
                        style: TextStyle(fontFamily: font.family),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _style = _style.copyWith(fontFamily: value);
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFontSizeWeight() {
    return Row(
      children: [
        // Font Size
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('حجم الخط', style: TextStyle(fontSize: 12)),
                  Text(
                    '${_style.fontSize.toInt()}',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Slider(
                value: _style.fontSize,
                min: 8,
                max: 200,
                onChanged: (value) {
                  setState(() {
                    _style = _style.copyWith(fontSize: value);
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        
        // Font Weight
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('وزن الخط', style: TextStyle(fontSize: 12)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<FontWeight>(
                    value: _style.fontWeight,
                    isExpanded: true,
                    dropdownColor: AppTheme.cardColor,
                    items: const [
                      DropdownMenuItem(
                        value: FontWeight.w100,
                        child: Text('Thin'),
                      ),
                      DropdownMenuItem(
                        value: FontWeight.w300,
                        child: Text('Light'),
                      ),
                      DropdownMenuItem(
                        value: FontWeight.w400,
                        child: Text('Regular'),
                      ),
                      DropdownMenuItem(
                        value: FontWeight.w500,
                        child: Text('Medium'),
                      ),
                      DropdownMenuItem(
                        value: FontWeight.w600,
                        child: Text('SemiBold'),
                      ),
                      DropdownMenuItem(
                        value: FontWeight.w700,
                        child: Text('Bold'),
                      ),
                      DropdownMenuItem(
                        value: FontWeight.w900,
                        child: Text('Black'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _style = _style.copyWith(fontWeight: value);
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الألوان',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Text Color
            Expanded(
              child: _buildColorButton(
                label: 'لون النص',
                color: _style.color,
                onTap: () => _showColorPicker(
                  currentColor: _style.color,
                  onColorChanged: (color) {
                    setState(() {
                      _style = _style.copyWith(color: color);
                    });
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Background Color
            Expanded(
              child: _buildColorButton(
                label: 'لون الخلفية',
                color: _style.backgroundColor ?? Colors.transparent,
                onTap: () => _showColorPicker(
                  currentColor: _style.backgroundColor ?? Colors.white,
                  onColorChanged: (color) {
                    setState(() {
                      _style = _style.copyWith(backgroundColor: color);
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        
        // Gradient Toggle
        const SizedBox(height: 12),
        SwitchListTile(
          value: _style.hasGradient,
          onChanged: (value) {
            setState(() {
              _style = _style.copyWith(hasGradient: value);
            });
          },
          title: const Text('تدرج لوني'),
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
        
        if (_style.hasGradient) _buildGradientPicker(),
      ],
    );
  }

  Widget _buildColorButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white24),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientPicker() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          // Gradient Type
          Row(
            children: [
              _buildGradientTypeButton(
                label: 'خطي',
                type: GradientType.linear,
              ),
              const SizedBox(width: 8),
              _buildGradientTypeButton(
                label: 'دائري',
                type: GradientType.radial,
              ),
              const SizedBox(width: 8),
              _buildGradientTypeButton(
                label: 'مسح',
                type: GradientType.sweep,
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Gradient Colors
          Row(
            children: [
              Expanded(
                child: _buildColorButton(
                  label: 'اللون 1',
                  color: _style.gradientColors[0],
                  onTap: () => _showColorPicker(
                    currentColor: _style.gradientColors[0],
                    onColorChanged: (color) {
                      setState(() {
                        final colors = List<Color>.from(_style.gradientColors);
                        colors[0] = color;
                        _style = _style.copyWith(gradientColors: colors);
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildColorButton(
                  label: 'اللون 2',
                  color: _style.gradientColors.length > 1
                      ? _style.gradientColors[1]
                      : Colors.white,
                  onTap: () => _showColorPicker(
                    currentColor: _style.gradientColors.length > 1
                        ? _style.gradientColors[1]
                        : Colors.white,
                    onColorChanged: (color) {
                      setState(() {
                        final colors = List<Color>.from(_style.gradientColors);
                        if (colors.length > 1) {
                          colors[1] = color;
                        } else {
                          colors.add(color);
                        }
                        _style = _style.copyWith(gradientColors: colors);
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGradientTypeButton({
    required String label,
    required GradientType type,
  }) {
    final isSelected = _style.gradientType == type;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _style = _style.copyWith(gradientType: type);
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryColor.withOpacity(0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: isSelected
                ? Border.all(color: AppTheme.primaryColor)
                : Border.all(color: Colors.white24),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? AppTheme.primaryColor : Colors.white70,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlignment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'المحاذاة',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Text Direction
            Expanded(
              child: Row(
                children: [
                  _buildDirectionButton(
                    icon: Icons.format_textdirection_r_to_l,
                    isSelected: _style.textDirection == TextDirection.rtl,
                    onTap: () {
                      setState(() {
                        _style = _style.copyWith(textDirection: TextDirection.rtl);
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildDirectionButton(
                    icon: Icons.format_textdirection_l_to_r,
                    isSelected: _style.textDirection == TextDirection.ltr,
                    onTap: () {
                      setState(() {
                        _style = _style.copyWith(textDirection: TextDirection.ltr);
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            
            // Text Alignment
            Expanded(
              child: Row(
                children: [
                  _buildAlignButton(Icons.format_align_right, TextAlign.right),
                  const SizedBox(width: 8),
                  _buildAlignButton(Icons.format_align_center, TextAlign.center),
                  const SizedBox(width: 8),
                  _buildAlignButton(Icons.format_align_left, TextAlign.left),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDirectionButton({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.2)
              : AppTheme.cardColor,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: AppTheme.primaryColor)
              : null,
        ),
        child: Icon(
          icon,
          color: isSelected ? AppTheme.primaryColor : Colors.white70,
        ),
      ),
    );
  }

  Widget _buildAlignButton(IconData icon, TextAlign align) {
    final isSelected = _style.textAlign == align;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _style = _style.copyWith(textAlign: align);
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.2)
              : AppTheme.cardColor,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: AppTheme.primaryColor)
              : null,
        ),
        child: Icon(
          icon,
          size: 20,
          color: isSelected ? AppTheme.primaryColor : Colors.white70,
        ),
      ),
    );
  }

  Widget _buildSpacing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'التباعد',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        // Letter Spacing
        _buildSlider(
          label: 'تباعد الحروف',
          value: _style.letterSpacing,
          min: -10,
          max: 30,
          onChanged: (value) {
            setState(() {
              _style = _style.copyWith(letterSpacing: value);
            });
          },
        ),
        
        // Word Spacing
        _buildSlider(
          label: 'تباعد الكلمات',
          value: _style.wordSpacing,
          min: -10,
          max: 50,
          onChanged: (value) {
            setState(() {
              _style = _style.copyWith(wordSpacing: value);
            });
          },
        ),
        
        // Line Height
        _buildSlider(
          label: 'ارتفاع السطر',
          value: _style.height,
          min: 0.5,
          max: 3,
          divisions: 25,
          onChanged: (value) {
            setState(() {
              _style = _style.copyWith(height: value);
            });
          },
        ),
      ],
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    int? divisions,
    required Function(double) onChanged,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              value.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildEffects() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'التأثيرات',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        // Shadow
        SwitchListTile(
          value: _style.hasShadow,
          onChanged: (value) {
            setState(() {
              _style = _style.copyWith(hasShadow: value);
            });
          },
          title: const Text('ظل'),
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
        
        if (_style.hasShadow) _buildShadowControls(),
        
        // Stroke
        SwitchListTile(
          value: _style.hasStroke,
          onChanged: (value) {
            setState(() {
              _style = _style.copyWith(hasStroke: value);
            });
          },
          title: const Text('حدود'),
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
        
        if (_style.hasStroke) _buildStrokeControls(),
      ],
    );
  }

  Widget _buildShadowControls() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          // Shadow Color
          _buildColorButton(
            label: 'لون الظل',
            color: _style.shadowColor,
            onTap: () => _showColorPicker(
              currentColor: _style.shadowColor,
              onColorChanged: (color) {
                setState(() {
                  _style = _style.copyWith(shadowColor: color);
                });
              },
            ),
          ),
          const SizedBox(height: 12),
          
          // Blur Radius
          _buildSlider(
            label: 'نصف قطر التمويه',
            value: _style.shadowBlurRadius,
            min: 0,
            max: 30,
            onChanged: (value) {
              setState(() {
                _style = _style.copyWith(shadowBlurRadius: value);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStrokeControls() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          // Stroke Color
          _buildColorButton(
            label: 'لون الحدود',
            color: _style.strokeColor,
            onTap: () => _showColorPicker(
              currentColor: _style.strokeColor,
              onColorChanged: (color) {
                setState(() {
                  _style = _style.copyWith(strokeColor: color);
                });
              },
            ),
          ),
          const SizedBox(height: 12),
          
          // Stroke Width
          _buildSlider(
            label: 'سمك الحدود',
            value: _style.strokeWidth,
            min: 0.5,
            max: 10,
            onChanged: (value) {
              setState(() {
                _style = _style.copyWith(strokeWidth: value);
              });
            },
          ),
        ],
      ),
    );
  }

  void _showColorPicker({
    required Color currentColor,
    required Function(Color) onColorChanged,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختر لوناً'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: currentColor,
            onColorChanged: onColorChanged,
            pickerAreaHeightPercent: 0.8,
            enableAlpha: true,
            displayThumbColor: true,
            paletteType: PaletteType.hsvWithHue,
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
  }

  void _saveChanges() {
    final layerProvider = context.read<LayerProvider>();
    
    // Update text
    layerProvider.updateLayerText(widget.layer.id, _textController.text);
    
    // Update style
    layerProvider.updateTextStyle(widget.layer.id, _style);
    
    Navigator.pop(context);
  }
}

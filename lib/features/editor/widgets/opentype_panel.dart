import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/providers/font_provider.dart';
import '../../../core/providers/layer_provider.dart';
import '../../../core/constants/opentype_features.dart';
import '../../../core/models/font_model.dart';
import '../../../core/models/text_style_model.dart';

class OpenTypePanel extends StatefulWidget {
  const OpenTypePanel({super.key});

  @override
  State<OpenTypePanel> createState() => _OpenTypePanelState();
}

class _OpenTypePanelState extends State<OpenTypePanel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _previewText = 'مرحباً بالعالم Hello World 123';
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<FontProvider, LayerProvider>(
      builder: (context, fontProvider, layerProvider, child) {
        final selectedLayer = layerProvider.selectedLayer;
        final isTextLayer = selectedLayer?.type == LayerType.text;
        
        return Column(
          children: [
            // Header
            _buildHeader(fontProvider),
            
            // Preview Area
            _buildPreviewArea(fontProvider),
            
            // Tabs
            _buildTabs(),
            
            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildFeaturesTab(fontProvider, layerProvider),
                  _buildVariableAxesTab(fontProvider, layerProvider),
                  _buildInfoTab(fontProvider),
                ],
              ),
            ),
            
            // Apply Button
            if (isTextLayer) _buildApplyButton(fontProvider, layerProvider),
          ],
        );
      },
    );
  }

  Widget _buildHeader(FontProvider fontProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.text_fields,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'OpenType Features',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'خصائص الخط المتقدمة',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Font Selector
          _buildFontSelector(fontProvider),
        ],
      ),
    );
  }

  Widget _buildFontSelector(FontProvider fontProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<FontModel>(
          value: fontProvider.selectedFont,
          isExpanded: true,
          hint: const Text('اختر خطاً'),
          dropdownColor: AppTheme.cardColor,
          items: fontProvider.fonts.map((font) {
            return DropdownMenuItem(
              value: font,
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        'ف',
                        style: TextStyle(
                          fontFamily: font.family,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          font.name,
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          '${font.supportedFeatures.length} خاصية',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (font.isVariable)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Variable',
                        style: TextStyle(
                          fontSize: 9,
                          color: AppTheme.secondaryColor,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
          onChanged: (font) {
            if (font != null) {
              fontProvider.selectFont(font);
            }
          },
        ),
      ),
    );
  }

  Widget _buildPreviewArea(FontProvider fontProvider) {
    final font = fontProvider.selectedFont;
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          // Preview Text
          TextField(
            controller: TextEditingController(text: _previewText),
            onChanged: (value) => setState(() => _previewText = value),
            style: TextStyle(
              fontFamily: font?.family ?? 'Cairo',
              fontSize: 24,
              color: Colors.black,
              fontFeatures: fontProvider.getFontFeatures(),
              fontVariations: fontProvider.getFontVariations(),
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'اكتب نصاً للمعاينة...',
              hintStyle: TextStyle(color: Colors.grey),
            ),
            maxLines: 3,
            minLines: 2,
          ),
          
          const Divider(),
          
          // Features Count
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFeatureBadge(
                label: 'مفعّلة',
                count: fontProvider.activeFeatures.values
                    .where((v) => v).length,
                color: AppTheme.successColor,
              ),
              const SizedBox(width: 20),
              _buildFeatureBadge(
                label: 'متاحة',
                count: font?.supportedFeatures.length ?? 0,
                color: AppTheme.primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureBadge({
    required String label,
    required int count,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$count $label',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(4),
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        tabs: const [
          Tab(text: 'الخصائص'),
          Tab(text: 'المحاور'),
          Tab(text: 'المعلومات'),
        ],
      ),
    );
  }

  Widget _buildFeaturesTab(
    FontProvider fontProvider,
    LayerProvider layerProvider,
  ) {
    final featuresByCategory = fontProvider.supportedFeaturesByCategory;
    
    if (featuresByCategory.isEmpty) {
      return _buildEmptyState(
        icon: Icons.text_fields,
        title: 'لا توجد خصائص',
        subtitle: 'اختر خطاً يدعم OpenType Features',
      );
    }
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Quick Actions
        _buildQuickActions(fontProvider),
        const SizedBox(height: 16),
        
        // Features by Category
        ...featuresByCategory.entries.map((entry) {
          return _buildFeatureCategory(
            category: entry.key,
            features: entry.value,
            fontProvider: fontProvider,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildQuickActions(FontProvider fontProvider) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.check_circle_outline,
            label: 'تفعيل الكل',
            onTap: () => fontProvider.enableAllFeatures(),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildActionButton(
            icon: Icons.cancel_outlined,
            label: 'تعطيل الكل',
            onTap: () => fontProvider.disableAllFeatures(),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildActionButton(
            icon: Icons.refresh,
            label: 'إعادة تعيين',
            onTap: () => fontProvider.resetFeatures(),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: Colors.white70),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCategory({
    required FeatureCategory category,
    required List<OpenTypeFeature> features,
    required FontProvider fontProvider,
  }) {
    return ExpansionTile(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _getCategoryColor(category).withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              _getCategoryIcon(category),
              size: 16,
              color: _getCategoryColor(category),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            category.nameAr,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${features.length}',
              style: const TextStyle(fontSize: 11),
            ),
          ),
        ],
      ),
      initiallyExpanded: category == FeatureCategory.ligatures ||
          category == FeatureCategory.arabic,
      children: features.map((feature) {
        return _buildFeatureTile(feature, fontProvider);
      }).toList(),
    );
  }

  Widget _buildFeatureTile(
    OpenTypeFeature feature,
    FontProvider fontProvider,
  ) {
    final isEnabled = fontProvider.activeFeatures[feature.tag] ?? false;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 4, left: 16, right: 16),
      decoration: BoxDecoration(
        color: isEnabled
            ? AppTheme.primaryColor.withOpacity(0.1)
            : Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(8),
        border: isEnabled
            ? Border.all(color: AppTheme.primaryColor.withOpacity(0.3))
            : null,
      ),
      child: SwitchListTile(
        value: isEnabled,
        onChanged: (value) {
          fontProvider.toggleFeature(feature.tag, value);
        },
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                feature.tag,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                feature.nameAr,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        subtitle: Text(
          feature.descriptionAr,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
        activeColor: AppTheme.primaryColor,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
    );
  }

  Widget _buildVariableAxesTab(
    FontProvider fontProvider,
    LayerProvider layerProvider,
  ) {
    final font = fontProvider.selectedFont;
    
    if (font == null || !font.isVariable) {
      return _buildEmptyState(
        icon: Icons.tune,
        title: 'ليس خطاً متغيراً',
        subtitle: 'Variable Fonts تدعم تعديل المحاور',
      );
    }
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Reset Button
        Center(
          child: TextButton.icon(
            onPressed: () => fontProvider.resetAxes(),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('إعادة تعيين المحاور'),
          ),
        ),
        const SizedBox(height: 16),
        
        // Axes
        ...font.variableAxes.map((axis) {
          return _buildAxisSlider(axis, fontProvider);
        }).toList(),
      ],
    );
  }

  Widget _buildAxisSlider(VariableAxis axis, FontProvider fontProvider) {
    final value = fontProvider.axisValues[axis.tag] ?? axis.defaultValue;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  axis.tag,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.secondaryColor,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                axis.nameAr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  value.toStringAsFixed(0),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                axis.minValue.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppTheme.secondaryColor,
                    inactiveTrackColor: AppTheme.secondaryColor.withOpacity(0.2),
                    thumbColor: AppTheme.secondaryColor,
                    overlayColor: AppTheme.secondaryColor.withOpacity(0.2),
                  ),
                  child: Slider(
                    value: value.clamp(axis.minValue, axis.maxValue),
                    min: axis.minValue,
                    max: axis.maxValue,
                    onChanged: (newValue) {
                      fontProvider.setAxisValue(axis.tag, newValue);
                    },
                  ),
                ),
              ),
              Text(
                axis.maxValue.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
          
          // Quick Values
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickValue(
                label: 'Min',
                value: axis.minValue,
                isSelected: value == axis.minValue,
                onTap: () => fontProvider.setAxisValue(axis.tag, axis.minValue),
              ),
              _buildQuickValue(
                label: 'Default',
                value: axis.defaultValue,
                isSelected: value == axis.defaultValue,
                onTap: () => fontProvider.setAxisValue(axis.tag, axis.defaultValue),
              ),
              _buildQuickValue(
                label: 'Max',
                value: axis.maxValue,
                isSelected: value == axis.maxValue,
                onTap: () => fontProvider.setAxisValue(axis.tag, axis.maxValue),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickValue({
    required String label,
    required double value,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.secondaryColor.withOpacity(0.3)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(6),
          border: isSelected
              ? Border.all(color: AppTheme.secondaryColor)
              : null,
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected
                    ? AppTheme.secondaryColor
                    : Colors.white.withOpacity(0.5),
              ),
            ),
            Text(
              value.toStringAsFixed(0),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? AppTheme.secondaryColor
                    : Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTab(FontProvider fontProvider) {
    final font = fontProvider.selectedFont;
    
    if (font == null) {
      return _buildEmptyState(
        icon: Icons.info_outline,
        title: 'لا يوجد خط محدد',
        subtitle: 'اختر خطاً لعرض معلوماته',
      );
    }
    
    final metadata = font.metadata;
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Font Icon
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                'ف',
                style: TextStyle(
                  fontFamily: font.family,
                  fontSize: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Font Name
        Center(
          child: Text(
            font.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Center(
          child: Text(
            font.family,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // Info Cards
        if (metadata.version != null)
          _buildInfoCard('الإصدار', metadata.version!),
        if (metadata.designer != null)
          _buildInfoCard('المصمم', metadata.designer!),
        if (metadata.manufacturer != null)
          _buildInfoCard('الشركة', metadata.manufacturer!),
        if (metadata.copyright != null)
          _buildInfoCard('حقوق النشر', metadata.copyright!),
        if (metadata.license != null)
          _buildInfoCard('الرخصة', metadata.license!),
        if (metadata.description != null)
          _buildInfoCard('الوصف', metadata.description!),
        
        const SizedBox(height: 16),
        
        // Technical Info
        _buildTechnicalInfo(font),
        
        const SizedBox(height: 16),
        
        // Supported Features Summary
        _buildFeaturesSummary(font),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicalInfo(FontModel font) {
    final metadata = font.metadata;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'معلومات تقنية',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildTechRow('Units Per Em', '${metadata.unitsPerEm ?? "N/A"}'),
          _buildTechRow('Ascender', '${metadata.ascender ?? "N/A"}'),
          _buildTechRow('Descender', '${metadata.descender ?? "N/A"}'),
          _buildTechRow('Line Gap', '${metadata.lineGap ?? "N/A"}'),
          _buildTechRow('Glyphs', '${metadata.numGlyphs ?? "N/A"}'),
          _buildTechRow('Variable', font.isVariable ? 'نعم' : 'لا'),
          if (font.isVariable)
            _buildTechRow('Axes', '${font.variableAxes.length}'),
        ],
      ),
    );
  }

  Widget _buildTechRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSummary(FontModel font) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'الخصائص المدعومة',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${font.supportedFeatures.length}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: font.supportedFeatures.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    fontSize: 11,
                    fontFamily: 'monospace',
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildApplyButton(
    FontProvider fontProvider,
    LayerProvider layerProvider,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: ElevatedButton(
        onPressed: () => _applyToSelectedLayer(fontProvider, layerProvider),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check),
            SizedBox(width: 8),
            Text(
              'تطبيق على الطبقة المحددة',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _applyToSelectedLayer(
    FontProvider fontProvider,
    LayerProvider layerProvider,
  ) {
    final layer = layerProvider.selectedLayer;
    if (layer == null || layer.type != LayerType.text) return;
    
    final font = fontProvider.selectedFont;
    if (font == null) return;
    
    final currentStyle = layer.textStyle ?? TextStyleModel();
    final newStyle = currentStyle.copyWith(
      fontFamily: font.family,
      fontPath: font.path,
      openTypeFeatures: Map.from(fontProvider.activeFeatures),
      variableAxes: Map.from(fontProvider.axisValues),
    );
    
    layerProvider.updateTextStyle(layer.id, newStyle);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم تطبيق الخصائص بنجاح'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 60,
            color: Colors.white.withOpacity(0.2),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(FeatureCategory category) {
    switch (category) {
      case FeatureCategory.ligatures:
        return AppTheme.primaryColor;
      case FeatureCategory.alternates:
        return AppTheme.secondaryColor;
      case FeatureCategory.stylisticSets:
        return AppTheme.accentColor;
      case FeatureCategory.arabic:
        return Colors.green;
      case FeatureCategory.numeric:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(FeatureCategory category) {
    switch (category) {
      case FeatureCategory.ligatures:
        return Icons.link;
      case FeatureCategory.alternates:
        return Icons.swap_horiz;
      case FeatureCategory.stylisticSets:
        return Icons.style;
      case FeatureCategory.arabic:
        return Icons.language;
      case FeatureCategory.numeric:
        return Icons.numbers;
      case FeatureCategory.spacing:
        return Icons.space_bar;
      case FeatureCategory.position:
        return Icons.vertical_align_center;
      default:
        return Icons.text_fields;
    }
  }
}

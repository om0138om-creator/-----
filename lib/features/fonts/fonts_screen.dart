import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/providers/font_provider.dart';
import '../../core/models/font_model.dart';
import '../../core/constants/opentype_features.dart';

class FontsScreen extends StatefulWidget {
  final FontModel? selectedFont;

  const FontsScreen({
    super.key,
    this.selectedFont,
  });

  @override
  State<FontsScreen> createState() => _FontsScreenState();
}

class _FontsScreenState extends State<FontsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _previewText = 'مرحباً بالعالم\nHello World\n٠١٢٣٤٥٦٧٨٩';
  double _previewSize = 32;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    if (widget.selectedFont != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<FontProvider>().selectFont(widget.selectedFont!);
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الخطوط'),
        actions: [
          IconButton(
            onPressed: _importFont,
            icon: const Icon(Icons.add),
            tooltip: 'استيراد خط',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'الخطوط'),
            Tab(text: 'المعاينة'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFontsTab(),
          _buildPreviewTab(),
        ],
      ),
    );
  }

  Widget _buildFontsTab() {
    return Consumer<FontProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Import Button
            _buildImportButton(),
            const SizedBox(height: 20),
            
            // System Fonts
            _buildSectionHeader('خطوط النظام', provider.fonts.where((f) => !f.isCustom).length),
            ...provider.fonts.where((f) => !f.isCustom).map((font) {
              return _buildFontCard(font, provider);
            }).toList(),
            
            const SizedBox(height: 20),
            
            // Custom Fonts
            _buildSectionHeader('خطوط مخصصة', provider.customFonts.length),
            if (provider.customFonts.isEmpty)
              _buildEmptyCustomFonts()
            else
              ...provider.customFonts.map((font) {
                return _buildFontCard(font, provider, isCustom: true);
              }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildImportButton() {
    return InkWell(
      onTap: _importFont,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryColor.withOpacity(0.2),
              AppTheme.secondaryColor.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.primaryColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'استيراد خط جديد',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'TTF, OTF, WOFF, WOFF2',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFontCard(FontModel font, FontProvider provider, {bool isCustom = false}) {
    final isSelected = provider.selectedFont?.id == font.id;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? const BorderSide(color: AppTheme.primaryColor, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => provider.selectFont(font),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Font Preview
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'أ',
                    style: TextStyle(
                      fontFamily: font.family,
                      fontSize: 32,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Font Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            font.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
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
                            child: const Text(
                              'Variable',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.secondaryColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      font.family,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildInfoChip(
                          icon: Icons.text_fields,
                          label: '${font.supportedFeatures.length} خاصية',
                        ),
                        if (font.isVariable) ...[
                          const SizedBox(width: 8),
                          _buildInfoChip(
                            icon: Icons.tune,
                            label: '${font.variableAxes.length} محور',
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              
              // Actions
              if (isCustom)
                IconButton(
                  onPressed: () => _deleteFont(font),
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.red.withOpacity(0.7),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white70),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCustomFonts() {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Icon(
            Icons.font_download_outlined,
            size: 48,
            color: Colors.white.withOpacity(0.2),
          ),
          const SizedBox(height: 12),
          Text(
            'لا توجد خطوط مخصصة',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اضغط على "استيراد خط" لإضافة خطوط',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewTab() {
    return Consumer<FontProvider>(
      builder: (context, provider, child) {
        final font = provider.selectedFont;
        
        if (font == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.touch_app,
                  size: 60,
                  color: Colors.white.withOpacity(0.2),
                ),
                const SizedBox(height: 16),
                Text(
                  'اختر خطاً للمعاينة',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          );
        }
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Font Header
              _buildFontHeader(font),
              const SizedBox(height: 20),
              
              // Preview Text Input
              _buildPreviewInput(font, provider),
              const SizedBox(height: 20),
              
              // Size Slider
              _buildSizeSlider(),
              const SizedBox(height: 20),
              
              // OpenType Features Preview
              _buildFeaturesPreview(font, provider),
              const SizedBox(height: 20),
              
              // Character Map
              _buildCharacterMap(font),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFontHeader(FontModel font) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                'ف',
                style: TextStyle(
                  fontFamily: font.family,
                  fontSize: 36,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  font.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  font.family,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildBadge('${font.supportedFeatures.length} Features'),
                    if (font.isVariable) ...[
                      const SizedBox(width: 8),
                      _buildBadge('Variable'),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPreviewInput(FontModel font, FontProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: TextEditingController(text: _previewText),
        onChanged: (value) => setState(() => _previewText = value),
        maxLines: null,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontFamily: font.family,
          fontSize: _previewSize,
          color: Colors.black,
          fontFeatures: provider.getFontFeatures(),
          fontVariations: provider.getFontVariations(),
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'اكتب نصاً للمعاينة...',
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildSizeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('حجم المعاينة'),
            Text(
              '${_previewSize.toInt()} px',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: _previewSize,
          min: 12,
          max: 100,
          onChanged: (value) => setState(() => _previewSize = value),
        ),
      ],
    );
  }

  Widget _buildFeaturesPreview(FontModel font, FontProvider provider) {
    if (font.supportedFeatures.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'خصائص OpenType المتاحة',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: font.supportedFeatures.map((tag) {
            final feature = OpenTypeFeatures.allFeatures[tag];
            final isEnabled = provider.activeFeatures[tag] ?? false;
            
            return FilterChip(
              label: Text(
                '${feature?.nameAr ?? tag} ($tag)',
                style: const TextStyle(fontSize: 11),
              ),
              selected: isEnabled,
              onSelected: (value) {
                provider.toggleFeature(tag, value);
              },
              selectedColor: AppTheme.primaryColor.withOpacity(0.3),
              checkmarkColor: AppTheme.primaryColor,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCharacterMap(FontModel font) {
    const arabicChars = 'ابتثجحخدذرزسشصضطظعغفقكلمنهويءآأإئؤةى';
    const latinChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    const numbers = '0123456789٠١٢٣٤٥٦٧٨٩';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'خريطة الحروف',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        // Arabic
        _buildCharRow('العربية', arabicChars, font),
        const SizedBox(height: 12),
        
        // Latin
        _buildCharRow('اللاتينية', latinChars, font),
        const SizedBox(height: 12),
        
        // Numbers
        _buildCharRow('الأرقام', numbers, font),
      ],
    );
  }

  Widget _buildCharRow(String label, String chars, FontModel font) {
    return Container(
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
              fontSize: 12,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: chars.split('').map((char) {
              return Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    char,
                    style: TextStyle(
                      fontFamily: font.family,
                      fontSize: 18,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Future<void> _importFont() async {
    final provider = context.read<FontProvider>();
    final font = await provider.importFont();
    
    if (font != null && mounted) {
      provider.selectFont(font);
      _tabController.animateTo(1); // Switch to preview tab
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم استيراد "${font.name}" بنجاح!'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  void _deleteFont(FontModel font) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الخط'),
        content: Text('هل تريد حذف "${font.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<FontProvider>().deleteCustomFont(font.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const FontStudioApp());
}

// ==================== التطبيق الرئيسي ====================
class FontStudioApp extends StatelessWidget {
  const FontStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'Font Studio',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          fontFamily: 'Roboto',
          primaryColor: const Color(0xFF6C63FF),
          scaffoldBackgroundColor: const Color(0xFF1a1a2e),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF6C63FF),
            secondary: Color(0xFF00D9FF),
            surface: Color(0xFF16213e),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

// ==================== حالة التطبيق ====================
class AppState extends ChangeNotifier {
  String text = 'مرحباً بالعالم\nHello World';
  double fontSize = 40;
  Color textColor = Colors.white;
  Color backgroundColor = const Color(0xFF0f3460);
  TextAlign textAlign = TextAlign.center;
  double letterSpacing = 0;
  double wordSpacing = 0;
  double lineHeight = 1.5;
  FontWeight fontWeight = FontWeight.normal;

  // OpenType Features
  Map<String, bool> features = {
    'liga': true,
    'kern': true,
    'calt': true,
    'locl': true,
    'rlig': true,
    'dlig': false,
    'ss01': false,
    'ss02': false,
    'ss03': false,
    'swsh': false,
    'salt': false,
    'smcp': false,
    'onum': false,
    'lnum': false,
    'tnum': false,
    'frac': false,
  };

  // تحديث النص
  void updateText(String value) {
    text = value;
    notifyListeners();
  }

  // تحديث حجم الخط
  void updateFontSize(double value) {
    fontSize = value;
    notifyListeners();
  }

  // تحديث لون النص
  void updateTextColor(Color value) {
    textColor = value;
    notifyListeners();
  }

  // تحديث لون الخلفية
  void updateBackgroundColor(Color value) {
    backgroundColor = value;
    notifyListeners();
  }

  // تبديل خاصية OpenType
  void toggleFeature(String tag, bool value) {
    features[tag] = value;
    notifyListeners();
  }

  // تحديث المحاذاة
  void updateTextAlign(TextAlign value) {
    textAlign = value;
    notifyListeners();
  }

  // تحديث تباعد الحروف
  void updateLetterSpacing(double value) {
    letterSpacing = value;
    notifyListeners();
  }

  // تحديث تباعد الكلمات
  void updateWordSpacing(double value) {
    wordSpacing = value;
    notifyListeners();
  }

  // تحديث ارتفاع السطر
  void updateLineHeight(double value) {
    lineHeight = value;
    notifyListeners();
  }

  // تحديث وزن الخط
  void updateFontWeight(FontWeight value) {
    fontWeight = value;
    notifyListeners();
  }

  // الحصول على FontFeatures
  List<ui.FontFeature> getFontFeatures() {
    List<ui.FontFeature> result = [];
    features.forEach((tag, enabled) {
      if (enabled) {
        result.add(ui.FontFeature.enable(tag));
      }
    });
    return result;
  }

  // تفعيل الكل
  void enableAllFeatures() {
    features.updateAll((key, value) => true);
    notifyListeners();
  }

  // تعطيل الكل
  void disableAllFeatures() {
    features.updateAll((key, value) => false);
    notifyListeners();
  }

  // إعادة تعيين
  void resetFeatures() {
    features = {
      'liga': true,
      'kern': true,
      'calt': true,
      'locl': true,
      'rlig': true,
      'dlig': false,
      'ss01': false,
      'ss02': false,
      'ss03': false,
      'swsh': false,
      'salt': false,
      'smcp': false,
      'onum': false,
      'lnum': false,
      'tnum': false,
      'frac': false,
    };
    notifyListeners();
  }
}

// ==================== شاشة البداية ====================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6C63FF), Color(0xFF00D9FF)],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6C63FF).withOpacity(0.5),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.font_download_rounded,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Font Studio',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'فونت ستوديو',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ==================== الشاشة الرئيسية ====================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFF00D9FF)],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.font_download_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Font Studio',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'فونت ستوديو',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: const Color(0xFF16213e),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6C63FF).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            size: 50,
                            color: Color(0xFF6C63FF),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'صمم بإبداع',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'استخدم خصائص OpenType المتقدمة\nلإنشاء تصاميم احترافية',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white54,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildFeature(Icons.text_fields, 'OpenType'),
                            _buildFeature(Icons.tune, 'تنسيق'),
                            _buildFeature(Icons.color_lens, 'ألوان'),
                          ],
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const EditorScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C63FF),
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 10,
                              shadowColor:
                                  const Color(0xFF6C63FF).withOpacity(0.5),
                            ),
                            child: const Text(
                              'ابدأ التصميم',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: Colors.white70, size: 28),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 14),
        ),
      ],
    );
  }
}

// ==================== شاشة المحرر ====================
class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  bool _showOpenType = false;
  bool _showTextSettings = false;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _textController.text = context.read<AppState>().text;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF1a1a2e),
          appBar: AppBar(
            backgroundColor: const Color(0xFF16213e),
            elevation: 0,
            title: const Text(
              'Font Studio',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.text_format,
                  color: _showTextSettings
                      ? const Color(0xFF00D9FF)
                      : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _showTextSettings = !_showTextSettings;
                    if (_showTextSettings) _showOpenType = false;
                  });
                },
                tooltip: 'إعدادات النص',
              ),
              IconButton(
                icon: Icon(
                  Icons.text_fields,
                  color:
                      _showOpenType ? const Color(0xFF6C63FF) : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _showOpenType = !_showOpenType;
                    if (_showOpenType) _showTextSettings = false;
                  });
                },
                tooltip: 'OpenType Features',
              ),
            ],
          ),
          body: Column(
            children: [
              // Canvas Area
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: state.backgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        state.text,
                        style: TextStyle(
                          fontSize: state.fontSize,
                          color: state.textColor,
                          fontWeight: state.fontWeight,
                          letterSpacing: state.letterSpacing,
                          wordSpacing: state.wordSpacing,
                          height: state.lineHeight,
                          fontFeatures: state.getFontFeatures(),
                        ),
                        textAlign: state.textAlign,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                ),
              ),

              // Controls Panel
              Expanded(
                flex: _showOpenType || _showTextSettings ? 4 : 2,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF16213e),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text Input
                        TextField(
                          controller: _textController,
                          onChanged: state.updateText,
                          maxLines: 2,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: 'اكتب النص هنا...',
                            hintStyle: const TextStyle(color: Colors.white38),
                            filled: true,
                            fillColor: const Color(0xFF0f3460),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: const Icon(
                              Icons.edit,
                              color: Colors.white54,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Font Size
                        _buildSliderRow(
                          icon: Icons.format_size,
                          label: 'حجم الخط',
                          value: state.fontSize,
                          min: 12,
                          max: 100,
                          onChanged: state.updateFontSize,
                        ),

                        const SizedBox(height: 15),

                        // Colors Row
                        Row(
                          children: [
                            Expanded(
                              child: _buildColorButton(
                                context,
                                'لون النص',
                                state.textColor,
                                state.updateTextColor,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildColorButton(
                                context,
                                'لون الخلفية',
                                state.backgroundColor,
                                state.updateBackgroundColor,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        // Text Alignment
                        Row(
                          children: [
                            const Text(
                              'المحاذاة:',
                              style: TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(width: 15),
                            _buildAlignButton(
                              Icons.format_align_right,
                              TextAlign.right,
                              state,
                            ),
                            _buildAlignButton(
                              Icons.format_align_center,
                              TextAlign.center,
                              state,
                            ),
                            _buildAlignButton(
                              Icons.format_align_left,
                              TextAlign.left,
                              state,
                            ),
                          ],
                        ),

                        // Text Settings
                        if (_showTextSettings) ...[
                          const SizedBox(height: 20),
                          _buildTextSettingsPanel(state),
                        ],

                        // OpenType Features
                        if (_showOpenType) ...[
                          const SizedBox(height: 20),
                          _buildOpenTypePanel(state),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSliderRow({
    required IconData icon,
    required String label,
    required double value,
    required double min,
    required double max,
    required Function(double) onChanged,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white54),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(color: Colors.white70)),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            activeColor: const Color(0xFF6C63FF),
            inactiveColor: const Color(0xFF6C63FF).withOpacity(0.3),
            onChanged: onChanged,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF6C63FF).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${value.toInt()}',
            style: const TextStyle(
              color: Color(0xFF6C63FF),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColorButton(
    BuildContext context,
    String label,
    Color color,
    Function(Color) onColorChanged,
  ) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF16213e),
            title: Text(label, style: const TextStyle(color: Colors.white)),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: color,
                onColorChanged: onColorChanged,
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
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF0f3460),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white24),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlignButton(IconData icon, TextAlign align, AppState state) {
    final isSelected = state.textAlign == align;
    return IconButton(
      onPressed: () => state.updateTextAlign(align),
      icon: Icon(
        icon,
        color: isSelected ? const Color(0xFF6C63FF) : Colors.white54,
      ),
      style: IconButton.styleFrom(
        backgroundColor:
            isSelected ? const Color(0xFF6C63FF).withOpacity(0.2) : null,
      ),
    );
  }

  Widget _buildTextSettingsPanel(AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'إعدادات النص',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),

        // Letter Spacing
        _buildMiniSlider(
          'تباعد الحروف',
          state.letterSpacing,
          -5,
          20,
          state.updateLetterSpacing,
        ),

        // Word Spacing
        _buildMiniSlider(
          'تباعد الكلمات',
          state.wordSpacing,
          -5,
          30,
          state.updateWordSpacing,
        ),

        // Line Height
        _buildMiniSlider(
          'ارتفاع السطر',
          state.lineHeight,
          0.5,
          3,
          state.updateLineHeight,
        ),

        const SizedBox(height: 10),

        // Font Weight
        const Text(
          'وزن الخط:',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            _buildWeightChip('خفيف', FontWeight.w300, state),
            _buildWeightChip('عادي', FontWeight.normal, state),
            _buildWeightChip('متوسط', FontWeight.w500, state),
            _buildWeightChip('عريض', FontWeight.bold, state),
            _buildWeightChip('أسود', FontWeight.w900, state),
          ],
        ),
      ],
    );
  }

  Widget _buildMiniSlider(
    String label,
    double value,
    double min,
    double max,
    Function(double) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
          Expanded(
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              activeColor: const Color(0xFF00D9FF),
              inactiveColor: const Color(0xFF00D9FF).withOpacity(0.3),
              onChanged: onChanged,
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              value.toStringAsFixed(1),
              style: const TextStyle(
                color: Color(0xFF00D9FF),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightChip(String label, FontWeight weight, AppState state) {
    final isSelected = state.fontWeight == weight;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: isSelected ? Colors.white : Colors.white70,
          fontWeight: weight,
        ),
      ),
      selected: isSelected,
      onSelected: (_) => state.updateFontWeight(weight),
      selectedColor: const Color(0xFF00D9FF),
      backgroundColor: const Color(0xFF0f3460),
    );
  }

  Widget _buildOpenTypePanel(AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'خصائص OpenType',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: state.enableAllFeatures,
                  child: const Text(
                    'تفعيل الكل',
                    style: TextStyle(color: Color(0xFF6C63FF), fontSize: 12),
                  ),
                ),
                TextButton(
                  onPressed: state.disableAllFeatures,
                  child: const Text(
                    'تعطيل الكل',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Ligatures
        _buildFeatureSection('الربط (Ligatures)', [
          _buildFeatureChip('liga', 'الربط القياسي', state),
          _buildFeatureChip('rlig', 'الربط المطلوب', state),
          _buildFeatureChip('dlig', 'الربط الاختياري', state),
        ]),

        // Alternates
        _buildFeatureSection('البدائل (Alternates)', [
          _buildFeatureChip('calt', 'البدائل السياقية', state),
          _buildFeatureChip('salt', 'البدائل الأسلوبية', state),
          _buildFeatureChip('swsh', 'الزخرفة', state),
        ]),

        // Stylistic Sets
        _buildFeatureSection('المجموعات الأسلوبية', [
          _buildFeatureChip('ss01', 'المجموعة 1', state),
          _buildFeatureChip('ss02', 'المجموعة 2', state),
          _buildFeatureChip('ss03', 'المجموعة 3', state),
        ]),

        // Other
        _buildFeatureSection('أخرى', [
          _buildFeatureChip('kern', 'تقنين المسافات', state),
          _buildFeatureChip('locl', 'الأشكال المحلية', state),
          _buildFeatureChip('smcp', 'حروف صغيرة', state),
        ]),

        // Numbers
        _buildFeatureSection('الأرقام', [
          _buildFeatureChip('onum', 'أرقام تقليدية', state),
          _buildFeatureChip('lnum', 'أرقام مصفوفة', state),
          _buildFeatureChip('tnum', 'أرقام جدولية', state),
          _buildFeatureChip('frac', 'كسور', state),
        ]),
      ],
    );
  }

  Widget _buildFeatureSection(String title, List<Widget> chips) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: chips,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String tag, String label, AppState state) {
    final isEnabled = state.features[tag] ?? false;

    return FilterChip(
      label: Text(
        '$label ($tag)',
        style: TextStyle(
          fontSize: 11,
          color: isEnabled ? Colors.white : Colors.white70,
        ),
      ),
      selected: isEnabled,
      onSelected: (value) => state.toggleFeature(tag, value),
      selectedColor: const Color(0xFF6C63FF),
      backgroundColor: const Color(0xFF0f3460),
      checkmarkColor: Colors.white,
      side: BorderSide(
        color: isEnabled ? const Color(0xFF6C63FF) : Colors.transparent,
      ),
    );
  }
}

import 'dart:ui';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
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
          primaryColor: const Color(0xFF6C63FF),
          scaffoldBackgroundColor: const Color(0xFF1a1a2e),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF6C63FF),
            secondary: Color(0xFF00D9FF),
            surface: Color(0xFF16213e),
          ),
          textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme),
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
  String fontFamily = 'Cairo';
  TextAlign textAlign = TextAlign.center;

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

  // Variable Font Axes
  Map<String, double> axes = {
    'wght': 400,
    'wdth': 100,
    'slnt': 0,
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

  // تحديث محور Variable Font
  void updateAxis(String tag, double value) {
    axes[tag] = value;
    notifyListeners();
  }

  // تحديث المحاذاة
  void updateTextAlign(TextAlign value) {
    textAlign = value;
    notifyListeners();
  }

  // الحصول على FontFeatures
  List<FontFeature> getFontFeatures() {
    List<FontFeature> result = [];
    features.forEach((tag, enabled) {
      if (enabled) {
        result.add(FontFeature.enable(tag));
      }
    });
    return result;
  }

  // الحصول على FontVariations
  List<FontVariation> getFontVariations() {
    List<FontVariation> result = [];
    axes.forEach((tag, value) {
      result.add(FontVariation(tag, value));
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
                      Text(
                        'Font Studio',
                        style: GoogleFonts.cairo(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'فونت ستوديو',
                        style: GoogleFonts.cairo(
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
                // Header
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Font Studio',
                          style: GoogleFonts.cairo(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'فونت ستوديو',
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Main Card
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
                        Text(
                          'صمم بإبداع',
                          style: GoogleFonts.cairo(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'استخدم خصائص OpenType المتقدمة\nلإنشاء تصاميم احترافية',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            color: Colors.white54,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Features
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildFeature(Icons.text_fields, 'OpenType'),
                            _buildFeature(Icons.tune, 'Variable'),
                            _buildFeature(Icons.layers, 'طبقات'),
                          ],
                        ),

                        const Spacer(),

                        // Start Button
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
                            child: Text(
                              'ابدأ التصميم',
                              style: GoogleFonts.cairo(
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
          style: GoogleFonts.cairo(color: Colors.white54, fontSize: 14),
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
  bool _showVariableAxes = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF1a1a2e),
          appBar: AppBar(
            backgroundColor: const Color(0xFF16213e),
            elevation: 0,
            title: Text(
              'Font Studio',
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.tune,
                  color:
                      _showVariableAxes ? const Color(0xFF00D9FF) : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _showVariableAxes = !_showVariableAxes;
                    if (_showVariableAxes) _showOpenType = false;
                  });
                },
                tooltip: 'Variable Axes',
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
                    if (_showOpenType) _showVariableAxes = false;
                  });
                },
                tooltip: 'OpenType Features',
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'سيتم إضافة خاصية المشاركة قريباً',
                        style: GoogleFonts.cairo(),
                      ),
                      backgroundColor: const Color(0xFF6C63FF),
                    ),
                  );
                },
                tooltip: 'مشاركة',
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
                        style: GoogleFonts.cairo(
                          fontSize: state.fontSize,
                          color: state.textColor,
                          fontFeatures: state.getFontFeatures(),
                          fontVariations: state.getFontVariations(),
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
                flex: _showOpenType || _showVariableAxes ? 4 : 2,
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
                          onChanged: state.updateText,
                          controller: TextEditingController(text: state.text),
                          maxLines: 2,
                          textDirection: TextDirection.rtl,
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: 'اكتب النص هنا...',
                            hintStyle: GoogleFonts.cairo(color: Colors.white38),
                            filled: true,
                            fillColor: const Color(0xFF0f3460),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon:
                                const Icon(Icons.edit, color: Colors.white54),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Font Size
                        Row(
                          children: [
                            const Icon(
                              Icons.format_size,
                              color: Colors.white54,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'حجم الخط',
                              style: GoogleFonts.cairo(color: Colors.white70),
                            ),
                            Expanded(
                              child: Slider(
                                value: state.fontSize,
                                min: 12,
                                max: 100,
                                activeColor: const Color(0xFF6C63FF),
                                inactiveColor:
                                    const Color(0xFF6C63FF).withOpacity(0.3),
                                onChanged: state.updateFontSize,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6C63FF).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${state.fontSize.toInt()}',
                                style: GoogleFonts.cairo(
                                  color: const Color(0xFF6C63FF),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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
                                (color) => state.updateTextColor(color),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildColorButton(
                                context,
                                'لون الخلفية',
                                state.backgroundColor,
                                (color) => state.updateBackgroundColor(color),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        // Text Alignment
                        Row(
                          children: [
                            Text(
                              'المحاذاة:',
                              style: GoogleFonts.cairo(color: Colors.white70),
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

                        // OpenType Features
                        if (_showOpenType) ...[
                          const SizedBox(height: 20),
                          _buildOpenTypePanel(state),
                        ],

                        // Variable Axes
                        if (_showVariableAxes) ...[
                          const SizedBox(height: 20),
                          _buildVariableAxesPanel(state),
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
            title: Text(label, style: GoogleFonts.cairo()),
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
                child: Text('تم', style: GoogleFonts.cairo()),
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
                style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12),
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

  Widget _buildOpenTypePanel(AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'خصائص OpenType',
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: state.enableAllFeatures,
                  child: Text(
                    'تفعيل الكل',
                    style: GoogleFonts.cairo(
                      color: const Color(0xFF6C63FF),
                      fontSize: 12,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: state.disableAllFeatures,
                  child: Text(
                    'تعطيل الكل',
                    style: GoogleFonts.cairo(color: Colors.white54, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildFeatureChip('liga', 'الربط القياسي', state),
            _buildFeatureChip('kern', 'تقنين المسافات', state),
            _buildFeatureChip('calt', 'البدائل السياقية', state),
            _buildFeatureChip('locl', 'الأشكال المحلية', state),
            _buildFeatureChip('rlig', 'الربط المطلوب', state),
            _buildFeatureChip('dlig', 'الربط الاختياري', state),
            _buildFeatureChip('ss01', 'المجموعة 1', state),
            _buildFeatureChip('ss02', 'المجموعة 2', state),
            _buildFeatureChip('ss03', 'المجموعة 3', state),
            _buildFeatureChip('swsh', 'الزخرفة', state),
            _buildFeatureChip('salt', 'البدائل الأسلوبية', state),
            _buildFeatureChip('smcp', 'حروف صغيرة', state),
            _buildFeatureChip('onum', 'أرقام تقليدية', state),
            _buildFeatureChip('lnum', 'أرقام مصفوفة', state),
            _buildFeatureChip('tnum', 'أرقام جدولية', state),
            _buildFeatureChip('frac', 'كسور', state),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureChip(String tag, String label, AppState state) {
    final isEnabled = state.features[tag] ?? false;

    return FilterChip(
      label: Text(
        '$label ($tag)',
        style: GoogleFonts.cairo(
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

  Widget _buildVariableAxesPanel(AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'محاور Variable Font',
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        _buildAxisSlider('wght', 'الوزن (Weight)', 100, 900, state),
        _buildAxisSlider('wdth', 'العرض (Width)', 50, 200, state),
        _buildAxisSlider('slnt', 'الميل (Slant)', -90, 90, state),
      ],
    );
  }

  Widget _buildAxisSlider(
    String tag,
    String label,
    double min,
    double max,
    AppState state,
  ) {
    final value = state.axes[tag] ?? min;

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.cairo(color: Colors.white70, fontSize: 13),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF00D9FF).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  value.toInt().toString(),
                  style: GoogleFonts.cairo(
                    color: const Color(0xFF00D9FF),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            activeColor: const Color(0xFF00D9FF),
            inactiveColor: const Color(0xFF00D9FF).withOpacity(0.3),
            onChanged: (v) => state.updateAxis(tag, v),
          ),
        ],
      ),
    );
  }
}

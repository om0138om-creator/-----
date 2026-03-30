import 'dart:ui' as ui;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Font Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1a1a2e),
        primaryColor: const Color(0xFF6C63FF),
      ),
      home: const EditorScreen(),
    );
  }
}

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  String text = 'مرحباً بالعالم\nHello World 123';
  double fontSize = 36;
  Color textColor = Colors.white;
  Color bgColor = const Color(0xFF0f3460);
  bool showFeatures = false;

  Map<String, bool> features = {
    'liga': true,
    'kern': true,
    'calt': true,
    'dlig': false,
    'ss01': false,
    'ss02': false,
    'swsh': false,
    'smcp': false,
    'onum': false,
    'frac': false,
  };

  List<ui.FontFeature> getFeatures() {
    return features.entries
        .where((e) => e.value)
        .map((e) => ui.FontFeature.enable(e.key))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213e),
        title: const Text('Font Studio - فونت ستوديو'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.text_fields,
              color: showFeatures ? const Color(0xFF6C63FF) : Colors.white,
            ),
            onPressed: () => setState(() => showFeatures = !showFeatures),
          ),
        ],
      ),
      body: Column(
        children: [
          // Canvas
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: textColor,
                      fontFeatures: getFeatures(),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Controls
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF16213e),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Text Input
                TextField(
                  onChanged: (v) => setState(() => text = v),
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                    hintText: 'اكتب النص هنا...',
                    filled: true,
                    fillColor: const Color(0xFF0f3460),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Font Size
                Row(
                  children: [
                    const Icon(Icons.format_size, color: Colors.white54),
                    Expanded(
                      child: Slider(
                        value: fontSize,
                        min: 12,
                        max: 80,
                        activeColor: const Color(0xFF6C63FF),
                        onChanged: (v) => setState(() => fontSize = v),
                      ),
                    ),
                    Text('${fontSize.toInt()}',
                        style: const TextStyle(color: Color(0xFF6C63FF))),
                  ],
                ),

                // OpenType Features
                if (showFeatures) ...[
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text('خصائص OpenType:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: features.keys.map((tag) {
                      return FilterChip(
                        label: Text(tag),
                        selected: features[tag]!,
                        onSelected: (v) =>
                            setState(() => features[tag] = v),
                        selectedColor: const Color(0xFF6C63FF),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

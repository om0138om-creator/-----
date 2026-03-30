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
  String text = 'مرحباً بالعالم\nHello World';
  double fontSize = 36;
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
        title: const Text('Font Studio'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.text_fields,
              color: showFeatures ? Colors.amber : Colors.white,
            ),
            onPressed: () => setState(() => showFeatures = !showFeatures),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0f3460),
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
                      color: Colors.white,
                      fontFeatures: getFeatures(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF16213e),
            child: Column(
              children: [
                TextField(
                  onChanged: (v) => setState(() => text = v),
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'اكتب هنا...',
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: const Color(0xFF0f3460),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('الحجم:', style: TextStyle(color: Colors.white70)),
                    Expanded(
                      child: Slider(
                        value: fontSize,
                        min: 12,
                        max: 72,
                        onChanged: (v) => setState(() => fontSize = v),
                      ),
                    ),
                    Text('${fontSize.toInt()}', style: const TextStyle(color: Colors.white)),
                  ],
                ),
                if (showFeatures)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: features.keys.map((tag) {
                      return FilterChip(
                        label: Text(tag),
                        selected: features[tag]!,
                        onSelected: (v) => setState(() => features[tag] = v),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

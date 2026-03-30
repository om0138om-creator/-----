import 'package:flutter_test/flutter_test.dart';
import 'package:font_studio/main.dart';

void main() {
  testWidgets('App starts correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const FontStudioApp());
    
    // Verify splash screen appears
    expect(find.text('Font Studio'), findsOneWidget);
  });
}

import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:nfc_app/main.dart'; // Import your main app file

void main() {
  testWidgets('Test responsiveness across screen sizes',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Define common screen sizes (e.g., small, medium, large devices)
    var screenSizes = [
      const Size(320, 640),
      const Size(375, 667),
      const Size(414, 896)
    ];

    for (var size in screenSizes) {
      await tester.binding.setSurfaceSize(size); // Set each screen size
      await tester.pump(); // Rebuild the widget with the new size
      expect(find.textContaining('A RenderFlex overflowed'),
          findsNothing); // Ensure no overflow
    }
  });
}

// import 'dart:ui';

// import 'package:flutter_test/flutter_test.dart';
// import 'package:nfc_app/main.dart'; // Import the main file or specific screen

// void main() {
//   testWidgets('Test for UI overflow issues', (WidgetTester tester) async {
//     // Load your app or screen
//     await tester.pumpWidget(
//         MyApp()); // Replace MyApp with your specific screen if needed

//     // Set a specific screen size to test responsiveness
//     await tester.binding
//         .setSurfaceSize(Size(320, 640)); // For smaller screen testing

//     // Rebuild the widget
//     await tester.pump();

//     // Find any overflow or UI error messages
//     expect(find.textContaining('A RenderFlex overflowed'),
//         findsNothing); // No overflow should be found
//   });
// }

// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:emi_calculator/main.dart';

void main() {
  testWidgets('EMI Calculator smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EMIApp());

    // Verify that the title shows up.
    expect(find.text('EMI Calculator'), findsOneWidget);

    // Verify that the input fields are present.
    expect(find.text('Loan Amount'), findsOneWidget);
    expect(find.text('Interest Rate (%)'), findsOneWidget);
    expect(find.text('Tenure (Years)'), findsOneWidget);

    // Verify that the Calculate button is present.
    expect(find.text('Calculate EMI'), findsOneWidget);
  });
}

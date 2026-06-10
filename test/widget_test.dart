import 'package:flutter_test/flutter_test.dart';
import 'package:antomi/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AndomiApp());
    expect(find.byType(AndomiApp), findsOneWidget);
  });
}

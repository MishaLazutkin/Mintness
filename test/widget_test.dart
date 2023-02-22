import 'package:flutter_test/flutter_test.dart';

import 'package:mintness/app.dart';

void main() {
  testWidgets('Useless test', (WidgetTester tester) async {
    await tester.pumpWidget(App());
    expect(find.text('Test'), findsNothing);
  });
}

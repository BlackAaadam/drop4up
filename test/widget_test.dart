import 'package:flutter_test/flutter_test.dart';

import 'package:drop4up/main.dart';

void main() {
  testWidgets('renders Phase 3 shell preview and switches tabs', (tester) async {
    await tester.pumpWidget(const Drop4UpPreviewApp());

    expect(find.text('Drop4Up'), findsOneWidget);
    expect(find.text('Home shell preview'), findsOneWidget);
    expect(find.text('Shell surface'), findsOneWidget);
    expect(find.text('Grace'), findsOneWidget);

    await tester.tap(find.text('Drop'));
    await tester.pumpAndSettle();

    expect(find.text('Drop shell preview'), findsOneWidget);
    expect(find.text('Journal'), findsOneWidget);
  });
}

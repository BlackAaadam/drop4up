import 'package:drop4up/ui/drop4up_date_picker.dart';
import 'package:drop4up/ui/drop4up_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('date picker does not allow future dates', (tester) async {
    DateTime? pickedDate;

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          textTheme: Drop4UpTokens.textTheme(),
        ),
        home: Builder(
          builder: (context) {
            return TextButton(
              key: const Key('open_date_picker'),
              onPressed: () async {
                pickedDate = await showDrop4UpDatePicker(
                  context,
                  initialDate: DateTime(2026, 5, 7),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2026, 5, 7),
                );
              },
              child: const Text('Open'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('open_date_picker')));
    await _pumpUi(tester);
    await tester.tap(find.byKey(const ValueKey('date_picker_day_2026-05-08')));
    await _pumpUi(tester);
    await tester.tap(find.byKey(const Key('date_picker_confirm_button')));
    await _pumpUi(tester);

    expect(pickedDate, DateTime(2026, 5, 7));
  });
}

Future<void> _pumpUi(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 350));
}

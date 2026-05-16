import 'package:drop4up/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_reflection_entry_repository.dart';

void main() {
  testWidgets('renders baseline screens and switches tabs', (tester) async {
    tester.view.physicalSize = const Size(393, 873);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      Drop4UpPreviewApp(repository: TestReflectionEntryRepository()),
    );
    await _pumpUi(tester);

    expect(find.text('Drop4Up'), findsOneWidget);
    expect(find.text('探索標籤'), findsOneWidget);
    expect(find.text('Home shell preview'), findsNothing);

    await tester.tap(find.text('Drop'));
    await _pumpUi(tester);

    expect(find.text('記下一滴\n心裡的回響。'), findsOneWidget);
    expect(find.text('一句話就夠了。'), findsOneWidget);
    expect(find.text('Save Drop'), findsOneWidget);
    expect(find.text('Drop shell preview'), findsNothing);

    await tester.tap(find.text('Journal'));
    await _pumpUi(tester);

    expect(find.text('Journal'), findsWidgets);
    expect(find.text('還沒有儲存的紀錄。'), findsOneWidget);
    expect(find.text('建立視覺卡片'), findsNothing);
    expect(find.text('Journal shell preview'), findsNothing);

    await tester.tap(find.text('Profile'));
    await _pumpUi(tester);

    expect(find.text('Profile'), findsWidgets);
    expect(find.text('備份資料'), findsOneWidget);
    expect(find.text('還原資料'), findsOneWidget);
    expect(find.text('偏好設定'), findsOneWidget);
    expect(find.text('關於 Drop4Up'), findsOneWidget);
    expect(find.text('Profile shell preview'), findsNothing);
  });

  testWidgets('Home and Drop profile buttons open Profile tab', (tester) async {
    tester.view.physicalSize = const Size(393, 873);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      Drop4UpPreviewApp(repository: TestReflectionEntryRepository()),
    );
    await _pumpUi(tester);

    await tester.tap(find.byIcon(Icons.person_outline_rounded));
    await _pumpUi(tester);

    expect(find.text('Profile'), findsWidgets);
    expect(find.text('備份資料'), findsOneWidget);

    await tester.tap(find.text('Drop'));
    await _pumpUi(tester);
    await tester.tap(find.byIcon(Icons.person_outline_rounded));
    await _pumpUi(tester);

    expect(find.text('Profile'), findsWidgets);
    expect(find.text('備份資料'), findsOneWidget);
  });
}

Future<void> _pumpUi(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 350));
}

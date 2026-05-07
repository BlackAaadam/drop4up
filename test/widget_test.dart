import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:drop4up/main.dart';

void main() {
  testWidgets('renders Home screen and switches tabs', (tester) async {
    tester.view.physicalSize = const Size(393, 873);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const Drop4UpPreviewApp());

    expect(find.text('Drop4Up'), findsOneWidget);
    expect(find.text('安靜下來，\n記得祂的同在。'), findsOneWidget);
    expect(find.text('Explore Tags'), findsOneWidget);
    expect(find.text('恩典'), findsOneWidget);
    expect(find.text('Home shell preview'), findsNothing);

    await tester.tap(find.text('Drop'));
    await tester.pumpAndSettle();

    expect(find.text('記下一滴\n心裡的回響。'), findsOneWidget);
    expect(find.text('來源'), findsOneWidget);
    expect(find.text('Save Drop'), findsOneWidget);
    expect(find.text('Drop shell preview'), findsNothing);
    expect(find.text('Journal'), findsOneWidget);

    await tester.tap(find.text('Journal'));
    await tester.pumpAndSettle();

    expect(find.text('Journal'), findsWidgets);
    expect(find.text('搜尋、整理，安靜回看每一滴。'), findsOneWidget);
    expect(find.text('全部'), findsOneWidget);
    expect(find.text('Create Visual Card'), findsOneWidget);
    expect(find.text('Journal shell preview'), findsNothing);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Profile'), findsWidgets);
    expect(find.text('管理資料，保留安靜回看的空間。'), findsOneWidget);
    expect(find.text('Backup JSON'), findsOneWidget);
    expect(find.text('Restore JSON'), findsOneWidget);
    expect(find.text('Preferences'), findsOneWidget);
    expect(find.text('About Drop4Up'), findsOneWidget);
    expect(find.text('Profile shell preview'), findsNothing);
  });
}

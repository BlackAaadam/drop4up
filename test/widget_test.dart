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
  });
}

import 'dart:io';
import 'dart:typed_data';

import 'package:drop4up/data/visual_card_share_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  test('writeAndSharePng creates a png file and shares it', () async {
    final tempDir = await Directory.systemTemp.createTemp(
      'drop4up_visual_card_service_test_',
    );
    addTearDown(() => tempDir.delete(recursive: true));

    ShareParams? sharedParams;
    final service = VisualCardShareService(
      directoryProvider: () async => tempDir,
      shareLauncher: (params) async {
        sharedParams = params;
        return const ShareResult('', ShareResultStatus.success);
      },
    );
    final bytes = Uint8List.fromList(const [137, 80, 78, 71, 13, 10, 26, 10]);
    final exportedAt = DateTime(2026, 5, 9, 12, 34);

    final visualCardFile = await service.writeAndSharePng(
      pngBytes: bytes,
      exportedAt: exportedAt,
    );
    final file = File(visualCardFile.path);

    expect(visualCardFile.fileName, 'Drop4Up_Visual_2026-05-09_1234.png');
    expect(visualCardFile.exportedAt, exportedAt.toUtc());
    expect(file.existsSync(), isTrue);
    expect(await file.readAsBytes(), bytes);
    expect(file.parent.path.endsWith('drop4up_visual_cards'), isTrue);
    expect(sharedParams?.title, visualCardFile.fileName);
    expect(sharedParams?.text, isNull);
    expect(sharedParams?.files, hasLength(1));
    expect(sharedParams?.fileNameOverrides, [visualCardFile.fileName]);
  });

  test('writeAndSharePng can use the injected clock', () async {
    final tempDir = await Directory.systemTemp.createTemp(
      'drop4up_visual_card_clock_test_',
    );
    addTearDown(() => tempDir.delete(recursive: true));

    final service = VisualCardShareService(
      directoryProvider: () async => tempDir,
      shareLauncher: (_) async {
        return const ShareResult('', ShareResultStatus.success);
      },
      clock: () => DateTime(2026, 5, 10, 7, 8),
    );

    final visualCardFile = await service.writeAndSharePng(
      pngBytes: Uint8List.fromList(const [1, 2, 3]),
    );

    expect(visualCardFile.fileName, 'Drop4Up_Visual_2026-05-10_0708.png');
  });
}

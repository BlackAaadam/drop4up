import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

typedef VisualCardDirectoryProvider = Future<Directory> Function();
typedef VisualCardShareLauncher =
    Future<ShareResult> Function(ShareParams params);
typedef VisualCardClock = DateTime Function();

class VisualCardShareService {
  VisualCardShareService({
    VisualCardDirectoryProvider? directoryProvider,
    VisualCardShareLauncher? shareLauncher,
    VisualCardClock? clock,
  }) : _directoryProvider =
           directoryProvider ?? getApplicationDocumentsDirectory,
       _shareLauncher = shareLauncher ?? SharePlus.instance.share,
       _clock = clock ?? (() => DateTime.now().toUtc());

  final VisualCardDirectoryProvider _directoryProvider;
  final VisualCardShareLauncher _shareLauncher;
  final VisualCardClock _clock;

  Future<VisualCardFile> writeAndSharePng({
    required Uint8List pngBytes,
    DateTime? exportedAt,
    Rect? sharePositionOrigin,
  }) async {
    final timestamp = (exportedAt ?? _clock()).toUtc();
    final directory = await _directoryProvider();
    final cardDirectory = Directory(
      '${directory.path}${Platform.pathSeparator}drop4up_visual_cards',
    );
    await cardDirectory.create(recursive: true);

    final fileName = visualCardFileName(timestamp);
    final file = File(
      '${cardDirectory.path}${Platform.pathSeparator}$fileName',
    );
    await file.writeAsBytes(pngBytes, flush: true);

    final visualCardFile = VisualCardFile(
      path: file.path,
      fileName: fileName,
      exportedAt: timestamp,
    );
    await _shareLauncher(
      ShareParams(
        title: fileName,
        files: [XFile(file.path, mimeType: 'image/png')],
        fileNameOverrides: [fileName],
        sharePositionOrigin: sharePositionOrigin,
      ),
    );
    return visualCardFile;
  }
}

class VisualCardFile {
  const VisualCardFile({
    required this.path,
    required this.fileName,
    required this.exportedAt,
  });

  final String path;
  final String fileName;
  final DateTime exportedAt;
}

String visualCardFileName(DateTime exportedAt) {
  final local = exportedAt.toLocal();
  return 'Drop4Up_Visual_'
      '${_twoDigits(local.year, 4)}-'
      '${_twoDigits(local.month)}-'
      '${_twoDigits(local.day)}_'
      '${_twoDigits(local.hour)}'
      '${_twoDigits(local.minute)}.png';
}

String _twoDigits(int value, [int width = 2]) {
  return value.toString().padLeft(width, '0');
}

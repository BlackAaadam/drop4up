import 'package:flutter/material.dart';

import '../data/profile_backup_file_service.dart';
import '../data/reflection_entry.dart';
import '../data/reflection_entry_document.dart';
import '../state/reflection_entries_scope.dart';
import '../ui/drop4up_tactile_surface.dart';
import '../ui/drop4up_tokens.dart';
import '../ui/primary_drop_button.dart';
import '../ui/soft_icon_button.dart';
import '../ui/soft_surface.dart';

enum _ProfileActionKind { backup, restore, preferences, about }

const _profileActions = [
  _ProfileAction(
    kind: _ProfileActionKind.backup,
    title: '備份資料',
    subtitle: '儲存一份本機備份檔。',
    icon: Icons.file_download_outlined,
  ),
  _ProfileAction(
    kind: _ProfileActionKind.restore,
    title: '還原資料',
    subtitle: '貼上備份，取代本機紀錄。',
    icon: Icons.file_upload_outlined,
  ),
  _ProfileAction(
    kind: _ProfileActionKind.preferences,
    title: '偏好設定',
    subtitle: '安靜的本機選項會在之後加入。',
    icon: Icons.tune_rounded,
  ),
  _ProfileAction(
    kind: _ProfileActionKind.about,
    title: '關於 Drop4Up',
    subtitle: '版本、prototype 範圍與資料說明。',
    icon: Icons.info_outline_rounded,
  ),
];

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key, ProfileBackupFileService? backupFileService})
    : backupFileService = backupFileService ?? ProfileBackupFileService();

  final ProfileBackupFileService backupFileService;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final entriesController = ReflectionEntriesScope.of(context);
    final entries = entriesController.entries;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Row(
          children: [
            Text(
              'Drop4Up',
              style: textTheme.titleLarge?.copyWith(
                color: Drop4UpTokens.primaryBlue,
              ),
            ),
            const Spacer(),
            SoftIconButton(
              icon: Icons.settings_outlined,
              label: '偏好設定',
              size: 44,
              iconSize: 20,
              onTap: () => _showPreferencesSheet(context),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          'Profile',
          style: textTheme.headlineLarge?.copyWith(fontSize: 32, height: 1.08),
        ),
        const SizedBox(height: 6),
        Text(
          '管理本機資料，保留安靜回看的空間。',
          style: textTheme.bodyLarge?.copyWith(
            fontSize: 15,
            color: Drop4UpTokens.textSecondary,
          ),
        ),
        const SizedBox(height: 14),
        _ProfileSummaryCard(entries: entries),
        const SizedBox(height: 12),
        for (final action in _profileActions) ...[
          _ProfileActionRow(
            action: action,
            onTap: () => _handleAction(context, action.kind, backupFileService),
          ),
          if (action != _profileActions.last) const SizedBox(height: 8),
        ],
        const SizedBox(height: 12),
        const _ProfileFooter(),
      ],
    );
  }
}

void _handleAction(
  BuildContext context,
  _ProfileActionKind kind,
  ProfileBackupFileService backupFileService,
) {
  switch (kind) {
    case _ProfileActionKind.backup:
      _showBackupSheet(context, backupFileService);
    case _ProfileActionKind.restore:
      _showRestoreSheet(context, backupFileService);
    case _ProfileActionKind.preferences:
      _showPreferencesSheet(context);
    case _ProfileActionKind.about:
      _showAboutSheet(context);
  }
}

class _ProfileSummaryCard extends StatelessWidget {
  const _ProfileSummaryCard({required this.entries});

  final List<ReflectionEntry> entries;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final favoriteCount = entries.where((entry) => entry.isFavorite).length;
    final sourceCount = entries.map((entry) => entry.source).toSet().length;
    final tagCount = entries.expand((entry) => entry.tags).toSet().length;
    final latest = entries.isEmpty ? null : entries.first.createdAt.toLocal();

    return SoftSurface(
      variant: SoftSurfaceVariant.prominent,
      radius: 30,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _ProfileNeutralIconBadge(
                icon: Icons.person_outline_rounded,
                size: 48,
                iconSize: 24,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('本機紀錄', style: textTheme.titleMedium),
                    const SizedBox(height: 6),
                    Text(
                      entries.isEmpty ? '還沒有儲存的紀錄。一句也可以。' : '資料只保存在此裝置。',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        color: Drop4UpTokens.textSecondary,
                        height: 1.34,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ProfileMetric(label: '紀錄', value: '${entries.length}'),
              _ProfileMetric(label: '收藏', value: '$favoriteCount'),
              _ProfileMetric(label: '來源', value: '$sourceCount'),
              _ProfileMetric(label: '標籤', value: '$tagCount'),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            latest == null ? '最近儲存：尚未建立' : '最近儲存：${_formatDate(latest)}',
            style: textTheme.labelMedium?.copyWith(
              color: Drop4UpTokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMetric extends StatelessWidget {
  const _ProfileMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Drop4UpTactileSurface(
      variant: Drop4UpTactileSurfaceVariant.inset,
      radius: 18,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Drop4UpTokens.cardSurface,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: textTheme.labelLarge?.copyWith(
              color: Drop4UpTokens.primaryBlue,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: Drop4UpTokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileActionRow extends StatefulWidget {
  const _ProfileActionRow({required this.action, required this.onTap});

  final _ProfileAction action;
  final VoidCallback onTap;

  @override
  State<_ProfileActionRow> createState() => _ProfileActionRowState();
}

class _ProfileActionRowState extends State<_ProfileActionRow> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      label: widget.action.title,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          duration: Drop4UpTokens.quickDuration,
          curve: Drop4UpTokens.calmCurve,
          scale: _pressed ? 0.988 : 1,
          child: Drop4UpTactileSurface(
            variant: _pressed
                ? Drop4UpTactileSurfaceVariant.pressed
                : Drop4UpTactileSurfaceVariant.raised,
            radius: 24,
            height: 58,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                _ProfileNeutralIconBadge(
                  icon: widget.action.icon,
                  size: 36,
                  iconSize: 19,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.action.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.labelLarge?.copyWith(
                          color: Drop4UpTokens.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.action.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.labelMedium?.copyWith(
                          fontSize: 12.5,
                          color: Drop4UpTokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 23,
                  color: Drop4UpTokens.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileNeutralIconBadge extends StatelessWidget {
  const _ProfileNeutralIconBadge({
    required this.icon,
    required this.size,
    required this.iconSize,
  });

  final IconData icon;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Drop4UpTactileSurface(
      radius: size / 2,
      width: size,
      height: size,
      color: Drop4UpTokens.cardSurface,
      child: Icon(icon, size: iconSize, color: Drop4UpTokens.textSecondary),
    );
  }
}

class _ProfileFooter extends StatelessWidget {
  const _ProfileFooter();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Drop4UpTactileSurface(
      variant: Drop4UpTactileSurfaceVariant.inset,
      radius: 24,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Drop4UpTokens.cardSurface,
      child: Row(
        children: [
          const Icon(
            Icons.water_drop_outlined,
            size: 20,
            color: Drop4UpTokens.primaryBlue,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Prototype 資料只會留在本機，除非你自行複製備份。',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color: Drop4UpTokens.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAction {
  const _ProfileAction({
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final _ProfileActionKind kind;
  final String title;
  final String subtitle;
  final IconData icon;
}

Future<void> _showBackupSheet(
  BuildContext context,
  ProfileBackupFileService backupFileService,
) async {
  await _showProfileSheet(
    context,
    title: '備份資料',
    icon: Icons.file_download_outlined,
    child: _BackupFileForm(backupFileService: backupFileService),
  );
}

Future<void> _showRestoreSheet(
  BuildContext context,
  ProfileBackupFileService backupFileService,
) async {
  await _showProfileSheet(
    context,
    title: '還原資料',
    icon: Icons.file_upload_outlined,
    child: _RestoreDataForm(backupFileService: backupFileService),
  );
}

Future<void> _showPreferencesSheet(BuildContext context) async {
  await _showProfileSheet(
    context,
    title: '偏好設定',
    icon: Icons.tune_rounded,
    child: const _SimpleSheetBody(text: '安靜的本機偏好設定會在之後加入。這一版先專注在資料照護與備份安全。'),
  );
}

Future<void> _showAboutSheet(BuildContext context) async {
  await _showProfileSheet(
    context,
    title: '關於 Drop4Up',
    icon: Icons.info_outline_rounded,
    child: const _SimpleSheetBody(
      text:
          'Drop4Up 是一個安靜的 Flutter UI prototype，用來記下一小段屬靈反思。這個版本沒有登入、雲端同步、後端 AI、OCR、語音轉文字、付款或正式資料庫。',
    ),
  );
}

Future<void> _showProfileSheet(
  BuildContext context, {
  required String title,
  required IconData icon,
  required Widget child,
}) {
  final textTheme = Theme.of(context).textTheme;

  return showDialog<void>(
    context: context,
    builder: (context) {
      return Dialog(
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
        backgroundColor: Colors.transparent,
        child: SoftSurface(
          variant: SoftSurfaceVariant.prominent,
          radius: 30,
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _ProfileNeutralIconBadge(
                      icon: icon,
                      size: 40,
                      iconSize: 21,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: textTheme.titleMedium?.copyWith(
                          color: Drop4UpTokens.textPrimary,
                        ),
                      ),
                    ),
                    SoftIconButton(
                      icon: Icons.close_rounded,
                      label: '關閉',
                      size: 40,
                      iconSize: 20,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                child,
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _BackupFileForm extends StatefulWidget {
  const _BackupFileForm({required this.backupFileService});

  final ProfileBackupFileService backupFileService;

  @override
  State<_BackupFileForm> createState() => _BackupFileFormState();
}

class _BackupFileFormState extends State<_BackupFileForm> {
  bool _isSaving = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '建立一份 Drop4Up 備份檔，可儲存到手機檔案、雲端硬碟，或分享給自己。資料內容只來自此裝置。',
          style: textTheme.bodyMedium?.copyWith(
            color: Drop4UpTokens.textSecondary,
          ),
        ),
        const SizedBox(height: 14),
        Drop4UpTactileSurface(
          variant: Drop4UpTactileSurfaceVariant.inset,
          radius: 22,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          color: Drop4UpTokens.cardSurface,
          child: Row(
            children: [
              const Icon(
                Icons.insert_drive_file_outlined,
                size: 22,
                color: Drop4UpTokens.primaryBlue,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '檔名會以 Drop4Up_Backup 開頭，方便之後找回。',
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 13.5,
                    color: Drop4UpTokens.textSecondary,
                    height: 1.32,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 10),
          Text(
            _error!,
            key: const Key('profile_backup_file_error'),
            style: textTheme.labelMedium?.copyWith(
              color: Drop4UpTokens.textPrimary,
            ),
          ),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _QuietSheetButton(
                label: '取消',
                onTap: _isSaving ? null : () => Navigator.of(context).pop(),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 178,
              child: PrimaryDropButton(
                key: const Key('profile_backup_file_button'),
                label: _isSaving ? '建立中' : '儲存備份檔',
                icon: Icons.ios_share_rounded,
                onTap: _isSaving ? () {} : _saveBackupFile,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _saveBackupFile() async {
    setState(() {
      _isSaving = true;
      _error = null;
    });

    try {
      final document = ReflectionEntriesScope.read(context).exportDocument();
      final backupFile = await widget.backupFileService.writeAndShareBackup(
        document,
      );
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('備份檔已建立：${backupFile.fileName}')));
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = '目前無法建立備份檔，請稍後再試。';
        _isSaving = false;
      });
    }
  }
}

class _RestoreDataForm extends StatefulWidget {
  const _RestoreDataForm({required this.backupFileService});

  final ProfileBackupFileService backupFileService;

  @override
  State<_RestoreDataForm> createState() => _RestoreDataFormState();
}

class _RestoreDataFormState extends State<_RestoreDataForm> {
  final TextEditingController _controller = TextEditingController();
  String? _error;
  bool _isRestoring = false;
  bool _isPickingFile = false;
  ReflectionEntryDocument? _pendingFileDocument;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '選擇一份 Drop4Up 備份檔，或貼上備份資料。還原會取代此裝置上的本機 prototype 紀錄。',
          style: textTheme.bodyMedium?.copyWith(
            color: Drop4UpTokens.textSecondary,
          ),
        ),
        const SizedBox(height: 14),
        PrimaryDropButton(
          key: const Key('profile_restore_file_button'),
          label: _isPickingFile ? '選擇中' : '選擇備份檔',
          icon: Icons.folder_open_rounded,
          onTap: _isPickingFile || _isRestoring ? () {} : _restoreFromFile,
        ),
        if (_pendingFileDocument != null) ...[
          const SizedBox(height: 12),
          _RestorePreviewCard(document: _pendingFileDocument!),
        ],
        const SizedBox(height: 12),
        Drop4UpTactileSurface(
          variant: Drop4UpTactileSurfaceVariant.inset,
          radius: 24,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          color: Drop4UpTokens.cardSurface,
          child: TextField(
            key: const Key('profile_restore_json_input'),
            controller: _controller,
            minLines: 6,
            maxLines: 8,
            style: textTheme.bodyMedium?.copyWith(
              color: Drop4UpTokens.textPrimary,
              fontFamily: 'monospace',
              fontSize: 13,
              height: 1.35,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              counterText: '',
              hintText: '貼上備份資料',
              hintStyle: textTheme.bodyMedium?.copyWith(
                color: Drop4UpTokens.textSecondary.withValues(alpha: 0.72),
                fontSize: 13,
              ),
            ),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 10),
          Text(
            _error!,
            key: const Key('profile_restore_error'),
            style: textTheme.labelMedium?.copyWith(
              color: Drop4UpTokens.textPrimary,
            ),
          ),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _QuietSheetButton(
                label: '取消',
                onTap: _isRestoring ? null : () => Navigator.of(context).pop(),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 150,
              child: PrimaryDropButton(
                key: const Key('profile_restore_confirm_button'),
                label: _isRestoring
                    ? '還原中'
                    : _pendingFileDocument == null
                    ? '還原'
                    : '確認還原',
                icon: Icons.restore_rounded,
                onTap: _isRestoring
                    ? () {}
                    : _pendingFileDocument == null
                    ? _restore
                    : _confirmFileRestore,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _restore() async {
    setState(() {
      _error = null;
      _isRestoring = true;
      _pendingFileDocument = null;
    });

    try {
      final document = parseProfileBackupDocumentText(_controller.text);
      await _restoreDocument(document, '本機紀錄已還原。');
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = '這看起來不是有效的 Drop4Up 備份資料。';
        _isRestoring = false;
      });
    }
  }

  Future<void> _restoreFromFile() async {
    setState(() {
      _error = null;
      _isPickingFile = true;
      _pendingFileDocument = null;
    });

    try {
      final document = await widget.backupFileService.pickRestoreDocument();
      if (!mounted) {
        return;
      }
      if (document == null) {
        setState(() => _isPickingFile = false);
        return;
      }
      setState(() {
        _pendingFileDocument = document;
        _isPickingFile = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = '這看起來不是有效的 Drop4Up 備份檔。';
        _isPickingFile = false;
      });
    }
  }

  Future<void> _confirmFileRestore() async {
    final document = _pendingFileDocument;
    if (document == null) {
      return;
    }
    setState(() {
      _error = null;
      _isRestoring = true;
    });

    try {
      await _restoreDocument(document, '本機紀錄已從備份檔還原。');
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = '目前無法還原這份備份檔，請稍後再試。';
        _isRestoring = false;
      });
    }
  }

  Future<void> _restoreDocument(
    ReflectionEntryDocument document,
    String successMessage,
  ) async {
    await ReflectionEntriesScope.read(context).restoreDocument(document);
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(successMessage)));
  }
}

class _RestorePreviewCard extends StatelessWidget {
  const _RestorePreviewCard({required this.document});

  final ReflectionEntryDocument document;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final firstEntry = document.entries.isEmpty ? null : document.entries.first;

    return Drop4UpTactileSurface(
      variant: Drop4UpTactileSurfaceVariant.inset,
      radius: 22,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      color: Drop4UpTokens.cardSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '還原前預覽',
            style: textTheme.labelLarge?.copyWith(
              color: Drop4UpTokens.primaryBlue,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            '將還原 ${document.entries.length} 筆紀錄。請先確認下面文字不是亂碼。',
            key: const Key('profile_restore_preview_count'),
            style: textTheme.bodyMedium?.copyWith(
              fontSize: 13.5,
              color: Drop4UpTokens.textSecondary,
              height: 1.34,
            ),
          ),
          if (firstEntry != null) ...[
            const SizedBox(height: 8),
            Text(
              firstEntry.text,
              key: const Key('profile_restore_preview_text'),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(
                color: Drop4UpTokens.textPrimary,
                height: 1.36,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SimpleSheetBody extends StatelessWidget {
  const _SimpleSheetBody({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: textTheme.bodyMedium?.copyWith(
            color: Drop4UpTokens.textSecondary,
            height: 1.42,
          ),
        ),
        const SizedBox(height: 18),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 128,
            child: PrimaryDropButton(
              label: '完成',
              icon: Icons.check_rounded,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuietSheetButton extends StatelessWidget {
  const _QuietSheetButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Drop4UpTactileSurface(
          radius: Drop4UpTokens.pillRadius,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          color: Drop4UpTokens.cardSurface,
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.labelLarge?.copyWith(
                color: onTap == null
                    ? Drop4UpTokens.textSecondary.withValues(alpha: 0.6)
                    : Drop4UpTokens.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}.$month.$day';
}

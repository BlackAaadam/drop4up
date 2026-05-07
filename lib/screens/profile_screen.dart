import 'package:flutter/material.dart';

import '../ui/drop4up_tactile_surface.dart';
import '../ui/drop4up_tokens.dart';
import '../ui/soft_icon_button.dart';
import '../ui/soft_surface.dart';

const _profileActions = [
  _ProfileAction(
    title: 'Backup JSON',
    subtitle: '匯出目前 prototype 資料',
    icon: Icons.file_download_outlined,
  ),
  _ProfileAction(
    title: 'Restore JSON',
    subtitle: '從本機備份還原',
    icon: Icons.file_upload_outlined,
  ),
  _ProfileAction(
    title: 'Preferences',
    subtitle: '調整提醒、文字與顯示偏好',
    icon: Icons.tune_rounded,
  ),
  _ProfileAction(
    title: 'About Drop4Up',
    subtitle: '版本、理念與資料說明',
    icon: Icons.info_outline_rounded,
  ),
];

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
              label: '設定',
              size: 44,
              iconSize: 20,
              onTap: () {},
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
          '管理資料，保留安靜回看的空間。',
          style: textTheme.bodyLarge?.copyWith(
            fontSize: 15,
            color: Drop4UpTokens.textSecondary,
          ),
        ),
        const SizedBox(height: 14),
        const _ProfileSummaryCard(),
        const SizedBox(height: 12),
        for (final action in _profileActions) ...[
          _ProfileActionRow(action: action),
          if (action != _profileActions.last) const SizedBox(height: 8),
        ],
        const SizedBox(height: 12),
        const _ProfileFooter(),
      ],
    );
  }
}

class _ProfileSummaryCard extends StatelessWidget {
  const _ProfileSummaryCard();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SoftSurface(
      variant: SoftSurfaceVariant.prominent,
      radius: 30,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
      child: Row(
        children: [
          Drop4UpTactileSurface(
            radius: 24,
            width: 48,
            height: 48,
            color: Drop4UpTokens.lightBlue.withValues(alpha: 0.28),
            child: const Icon(
              Icons.person_outline_rounded,
              size: 24,
              color: Drop4UpTokens.primaryBlue,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('安靜保存每一刻', style: textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(
                  '目前是本機 UI prototype；未連接登入、同步或雲端備份。',
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
    );
  }
}

class _ProfileActionRow extends StatelessWidget {
  const _ProfileActionRow({required this.action});

  final _ProfileAction action;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Drop4UpTactileSurface(
      radius: 24,
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Drop4UpTactileSurface(
            variant: Drop4UpTactileSurfaceVariant.inset,
            radius: 18,
            width: 36,
            height: 36,
            color: Drop4UpTokens.lightBlue.withValues(alpha: 0.22),
            child: Icon(
              action.icon,
              size: 19,
              color: Drop4UpTokens.primaryBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelLarge?.copyWith(
                    color: Drop4UpTokens.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  action.subtitle,
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
              '只保留能幫助安靜回看的設定。',
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
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}

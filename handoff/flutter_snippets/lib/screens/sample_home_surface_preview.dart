import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

import '../ui/drop4up_bottom_nav.dart';
import '../ui/drop4up_tag_chip.dart';
import '../ui/drop4up_tokens.dart';
import '../ui/soft_icon_button.dart';
import '../ui/soft_surface.dart';

class SampleHomeSurfacePreview extends StatefulWidget {
  const SampleHomeSurfacePreview({super.key});

  @override
  State<SampleHomeSurfacePreview> createState() => _SampleHomeSurfacePreviewState();
}

class _SampleHomeSurfacePreviewState extends State<SampleHomeSurfacePreview> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Drop4UpTokens.textTheme();

    return Scaffold(
      backgroundColor: Drop4UpTokens.background,
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(
                Drop4UpTokens.screenPadding,
                28,
                Drop4UpTokens.screenPadding,
                120,
              ),
              children: [
                Row(
                  children: [
                    Text(
                      'Drop4Up',
                      style: textTheme.titleLarge!.copyWith(
                        color: Drop4UpTokens.primaryBlue,
                      ),
                    ),
                    const Spacer(),
                    const SoftIconButton(icon: Icons.tune_rounded),
                  ],
                ),
                const SizedBox(height: 34),
                Text(
                  'Every drop nourishes your spirit.',
                  style: textTheme.headlineLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  'Take a quiet moment to remember what God has placed on your heart.',
                  style: textTheme.bodyLarge!.copyWith(
                    color: Drop4UpTokens.textPrimary.withOpacity(0.72),
                  ),
                ),
                const SizedBox(height: 32),
                SoftSurface(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 156,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Drop4UpTokens.lightBlue.withOpacity(0.34),
                              Drop4UpTokens.cardSurface,
                              Drop4UpTokens.accentBlue.withOpacity(0.20),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.water_drop_outlined,
                            size: 58,
                            color: Drop4UpTokens.primaryBlue.withOpacity(0.65),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('Today’s Inspiration', style: textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(
                        'Be still and know He is God.',
                        style: textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text('Explore Tags', style: textTheme.titleMedium),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: const [
                    Drop4UpTagChip(label: 'Grace', count: 12, selected: true),
                    Drop4UpTagChip(label: 'Prayer', count: 8),
                    Drop4UpTagChip(label: 'Faith', count: 6),
                    Drop4UpTagChip(label: 'Peace', count: 5),
                  ],
                ),
                const SizedBox(height: 30),
                SoftSurface(
                  variant: SoftSurfaceVariant.inset,
                  color: Drop4UpTokens.lightBlue.withOpacity(0.20),
                  padding: const EdgeInsets.all(18),
                  child: Text(
                    'Take a slow breath. You are not behind. You are becoming.',
                    style: textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Drop4UpBottomNav(
                currentIndex: _tab,
                onChanged: (index) => setState(() => _tab = index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'drop4up_tokens.dart';
import 'soft_surface.dart';

class Drop4UpBottomNav extends StatelessWidget {
  const Drop4UpBottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  final int currentIndex;
  final ValueChanged<int> onChanged;

  static const List<_Drop4UpNavItem> _items = [
    _Drop4UpNavItem('Home', Icons.home_outlined),
    _Drop4UpNavItem('Drop', Icons.water_drop_outlined),
    _Drop4UpNavItem('Journal', Icons.menu_book_outlined),
    _Drop4UpNavItem('Profile', Icons.person_outline),
  ];

  @override
  Widget build(BuildContext context) {
    return SoftSurface(
      radius: Drop4UpTokens.navRadius,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: Drop4UpTokens.navHeight,
      child: Row(
        children: [
          for (var index = 0; index < _items.length; index++)
            Expanded(
              child: _Drop4UpNavButton(
                item: _items[index],
                selected: index == currentIndex,
                onTap: () => onChanged(index),
              ),
            ),
        ],
      ),
    );
  }
}

class _Drop4UpNavButton extends StatelessWidget {
  const _Drop4UpNavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _Drop4UpNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color =
        selected ? Drop4UpTokens.primaryBlue : Drop4UpTokens.textSecondary;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              duration: Drop4UpTokens.calmDuration,
              curve: Drop4UpTokens.calmCurve,
              scale: selected ? 1.04 : 1,
              child: Icon(item.icon, size: 21, color: color),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: Drop4UpTokens.calmDuration,
              curve: Drop4UpTokens.calmCurve,
              style: textTheme.labelMedium!.copyWith(
                color: color,
                fontSize: 11,
              ),
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 5),
            AnimatedContainer(
              duration: Drop4UpTokens.calmDuration,
              curve: Drop4UpTokens.calmCurve,
              width: selected ? 18 : 0,
              height: 3,
              decoration: BoxDecoration(
                color: Drop4UpTokens.primaryBlue.withValues(
                  alpha: selected ? 0.72 : 0,
                ),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Drop4UpNavItem {
  const _Drop4UpNavItem(this.label, this.icon);

  final String label;
  final IconData icon;
}

import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

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

  static const _items = [
    _NavItem(Icons.home_outlined, 'Home'),
    _NavItem(Icons.water_drop_outlined, 'Drop'),
    _NavItem(Icons.menu_book_outlined, 'Journal'),
    _NavItem(Icons.person_outline_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(22, 0, 22, 14),
      child: SoftSurface(
        height: Drop4UpTokens.navHeight,
        radius: Drop4UpTokens.navRadius,
        color: Drop4UpTokens.cardSurface,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: List.generate(_items.length, (index) {
            final item = _items[index];
            final selected = index == currentIndex;
            return Expanded(
              child: _BottomNavItem(
                item: item,
                selected: selected,
                onTap: () => onChanged(index),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? Drop4UpTokens.lightBlue.withOpacity(0.36)
        : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SoftSurface(
        variant: selected ? SoftSurfaceVariant.inset : SoftSurfaceVariant.flat,
        radius: 28,
        color: color,
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.icon,
                size: 22,
                color: selected
                    ? Drop4UpTokens.primaryBlue
                    : Drop4UpTokens.textSecondary,
              ),
              const SizedBox(height: 4),
              Text(
                item.label,
                style: Drop4UpTokens.textTheme().labelSmall!.copyWith(
                      color: selected
                          ? Drop4UpTokens.primaryBlue
                          : Drop4UpTokens.textSecondary,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.icon, this.label);
  final IconData icon;
  final String label;
}

import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

const _navPressDuration = Duration(milliseconds: 100);
const _navTextDuration = Duration(milliseconds: 150);

class Drop4UpBottomNav extends StatelessWidget {
  const Drop4UpBottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  final int currentIndex;
  final ValueChanged<int> onChanged;

  static const double _height = 66;
  static const double _radius = 26;

  static const Color _navBase = Color(0xFFFBFBFA);
  static const Color _activeColor = Color(0xFF628FBE);
  static const Color _inactiveColor = Color(0xFF9AA3AD);

  static const Color _navWarmContact = Color(0xFF2F3438);
  static const Color _navCoolContact = Color(0xFF628FBE);
  static const Color _navInnerCompression = Color(0xFF9AA3AD);

  static const List<_Drop4UpNavItem> _items = [
    _Drop4UpNavItem('Home', Icons.home_rounded, Icons.home_outlined),
    _Drop4UpNavItem(
      'Drop',
      Icons.water_drop_rounded,
      Icons.water_drop_outlined,
    ),
    _Drop4UpNavItem(
      'Journal',
      Icons.menu_book_rounded,
      Icons.menu_book_outlined,
    ),
    _Drop4UpNavItem('Profile', Icons.person_rounded, Icons.person_outline),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_radius),
        color: _navBase,
        boxShadow: [
          // 1) Ultra-thin top/left contact definition.
          // This should be barely visible, not a halo.
          BoxShadow(
            color: _navWarmContact.withValues(alpha: 0.020),
            offset: const Offset(-0.35, -0.35),
            blurRadius: 1.4,
            spreadRadius: -5.8,
          ),
          // 2) Main bottom-right contact shadow.
          // Slightly stronger than the previous pass to recover the reference depth.
          BoxShadow(
            color: _navWarmContact.withValues(alpha: 0.150),
            offset: const Offset(4.2, 6.8),
            blurRadius: 12.5,
            spreadRadius: -5.8,
          ),
          // 3) Broad bottom ambient shadow.
          // This gives the soft grounded underside seen in the reference.
          BoxShadow(
            color: _navWarmContact.withValues(alpha: 0.045),
            offset: const Offset(0.0, 11.5),
            blurRadius: 20.0,
            spreadRadius: -18.5,
          ),
          // 4) Cool lower-right thickness.
          // Keep subtle; this should not make the right edge dirty.
          BoxShadow(
            color: _navCoolContact.withValues(alpha: 0.070),
            offset: const Offset(5.2, 6.8),
            blurRadius: 13.0,
            spreadRadius: -11.5,
          ),
          // 5) Inner top rim highlight.
          // Stronger than the previous no-gradient version so the top edge is defined.
          // It must remain soft, not a sharp white line.
          BoxShadow(
            color: const Color(0xFFFFFFFF).withValues(alpha: 0.82),
            offset: const Offset(1.2, 3.4),
            blurRadius: 3.2,
            spreadRadius: -2.8,
            inset: true,
          ),
          // 6) Very fine inner top polish.
          // A tiny highlight only; should not look like a border.
          BoxShadow(
            color: const Color(0xFFFFFFFF).withValues(alpha: 0.6),
            offset: const Offset(0.25, 0.75),
            blurRadius: 1.0,
            spreadRadius: -1.05,
            inset: true,
          ),
          // 7) Inner lower/right compression.
          // This restores rim thickness without using gradient.
          BoxShadow(
            color: _navInnerCompression.withValues(alpha: 0.48),
            offset: const Offset(-1.8, -3.8),
            blurRadius: 2.8,
            spreadRadius: -2.7,
            inset: true,
          ),
        ],
      ),
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

class _Drop4UpNavButton extends StatefulWidget {
  const _Drop4UpNavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _Drop4UpNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_Drop4UpNavButton> createState() => _Drop4UpNavButtonState();
}

class _Drop4UpNavButtonState extends State<_Drop4UpNavButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = widget.selected
        ? Drop4UpBottomNav._activeColor
        : Drop4UpBottomNav._inactiveColor;

    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.item.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          duration: _navPressDuration,
          curve: Curves.easeOut,
          scale: _pressed ? 0.975 : 1.0,
          child: Transform.translate(
            offset: const Offset(0, -1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.selected ? widget.item.activeIcon : widget.item.icon,
                  size: widget.selected ? 20.5 : 20,
                  color: color,
                ),
                const SizedBox(height: 2),
                AnimatedDefaultTextStyle(
                  duration: _navTextDuration,
                  curve: Curves.easeOutCubic,
                  style: textTheme.labelMedium!.copyWith(
                    color: color,
                    fontSize: 10.5,
                    fontWeight: widget.selected
                        ? FontWeight.w600
                        : FontWeight.w500,
                    letterSpacing: 0,
                  ),
                  child: Text(
                    widget.item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Drop4UpNavItem {
  const _Drop4UpNavItem(this.label, this.activeIcon, this.icon);

  final String label;
  final IconData activeIcon;
  final IconData icon;
}

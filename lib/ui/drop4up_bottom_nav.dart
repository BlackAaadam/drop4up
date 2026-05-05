import 'package:flutter/material.dart' as m;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as ib;

import 'drop4up_tokens.dart';

const _navBase = m.Color(0xFFFBFBFA);
const _navTopEdge = m.Color(0xFFFCFCFB);
const _navLowerEdge = m.Color(0xFFF3F4F2);
const _navWarmContact = m.Color(0xFFD2CEC6);
const _navCoolContact = m.Color(0xFFC0C8D0);
const _navInnerCompression = m.Color(0xFFB7BEC7);

const _navPressDuration = Duration(milliseconds: 100);
const _navTextDuration = Duration(milliseconds: 150);

class Drop4UpBottomNav extends m.StatelessWidget {
  const Drop4UpBottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  final int currentIndex;
  final m.ValueChanged<int> onChanged;

  static const double _height = 58;

  static const List<_Drop4UpNavItem> _items = [
    _Drop4UpNavItem(
      'Home',
      m.Icons.home_rounded,
      m.Icons.home_outlined,
    ),
    _Drop4UpNavItem(
      'Drop',
      m.Icons.water_drop_rounded,
      m.Icons.water_drop_outlined,
    ),
    _Drop4UpNavItem(
      'Journal',
      m.Icons.menu_book_rounded,
      m.Icons.menu_book_outlined,
    ),
    _Drop4UpNavItem(
      'Profile',
      m.Icons.person_rounded,
      m.Icons.person_outline,
    ),
  ];

  @override
  m.Widget build(m.BuildContext context) {
    return m.Container(
      height: _height,
      margin: const m.EdgeInsets.symmetric(horizontal: 10),
      padding: const m.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: ib.BoxDecoration(
        borderRadius: m.BorderRadius.circular(999),
        gradient: const m.LinearGradient(
          begin: m.Alignment.topCenter,
          end: m.Alignment.bottomCenter,
          stops: [0.0, 0.12, 0.44, 0.58, 0.90, 1.0],
          colors: [
            _navTopEdge,
            _navBase,
            _navBase,
            _navBase,
            m.Color(0xFFF6F6F4),
            _navLowerEdge,
          ],
        ),
        boxShadow: [
          ib.BoxShadow(
            color: const m.Color(0xFFFFFFFF).withValues(alpha: 0.14),
            offset: const m.Offset(-1, -1),
            blurRadius: 2.5,
            spreadRadius: -3,
          ),
          ib.BoxShadow(
            color: _navWarmContact.withValues(alpha: 0.38),
            offset: const m.Offset(0, 8),
            blurRadius: 14,
            spreadRadius: -7,
          ),
          ib.BoxShadow(
            color: _navCoolContact.withValues(alpha: 0.12),
            offset: const m.Offset(2, 7),
            blurRadius: 14,
            spreadRadius: -9,
          ),
          ib.BoxShadow(
            color: const m.Color(0xFFFFFFFF).withValues(alpha: 0.48),
            offset: const m.Offset(0, 1.6),
            blurRadius: 3.2,
            spreadRadius: -2.8,
            inset: true,
          ),
          ib.BoxShadow(
            color: const m.Color(0xFFFFFFFF).withValues(alpha: 0.24),
            offset: const m.Offset(0, 0.8),
            blurRadius: 1.0,
            spreadRadius: -1.0,
            inset: true,
          ),
          ib.BoxShadow(
            color: _navInnerCompression.withValues(alpha: 0.13),
            offset: const m.Offset(0, -1.8),
            blurRadius: 3.6,
            spreadRadius: -2.6,
            inset: true,
          ),
        ],
      ),
      child: m.Row(
        children: [
          for (var index = 0; index < _items.length; index++)
            m.Expanded(
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

class _Drop4UpNavButton extends m.StatefulWidget {
  const _Drop4UpNavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _Drop4UpNavItem item;
  final bool selected;
  final m.VoidCallback onTap;

  @override
  m.State<_Drop4UpNavButton> createState() => _Drop4UpNavButtonState();
}

class _Drop4UpNavButtonState extends m.State<_Drop4UpNavButton> {
  bool _pressed = false;

  @override
  m.Widget build(m.BuildContext context) {
    final textTheme = m.Theme.of(context).textTheme;
    final color = widget.selected
        ? Drop4UpTokens.primaryBlue
        : Drop4UpTokens.textSecondary;

    return m.Semantics(
      button: true,
      selected: widget.selected,
      label: widget.item.label,
      child: m.GestureDetector(
        behavior: m.HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: m.AnimatedScale(
          duration: _navPressDuration,
          curve: m.Curves.easeOut,
          scale: _pressed ? 0.975 : 1.0,
          child: m.Transform.translate(
            offset: const m.Offset(0, -1),
            child: m.Column(
              mainAxisAlignment: m.MainAxisAlignment.center,
              mainAxisSize: m.MainAxisSize.min,
              children: [
                m.Icon(
                  widget.selected ? widget.item.activeIcon : widget.item.icon,
                  size: widget.selected ? 20.5 : 20,
                  color: color,
                ),
                const m.SizedBox(height: 2),
                m.AnimatedDefaultTextStyle(
                  duration: _navTextDuration,
                  curve: m.Curves.easeOutCubic,
                  style: textTheme.labelMedium!.copyWith(
                    color: color,
                    fontSize: 10.5,
                    fontWeight: widget.selected
                        ? m.FontWeight.w600
                        : m.FontWeight.w500,
                    letterSpacing: 0,
                  ),
                  child: m.Text(
                    widget.item.label,
                    maxLines: 1,
                    overflow: m.TextOverflow.ellipsis,
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
  final m.IconData activeIcon;
  final m.IconData icon;
}

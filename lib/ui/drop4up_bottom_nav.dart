import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

import 'drop4up_tokens.dart';

// Nav 本體顏色：中央必須維持 Card Surface，靠上下緣用很淡的色差做厚度。
const _navBase = Color(0xFFFBFBFA);
const _navTopEdge = Color(0xFFFFFFFF);
const _navSoftCrown = Color(0xFFFCFCFB);
const _navLowerEdge = Color(0xFFEDEDEA);
const _navWarmContact = Color(0xFFD2CEC6);
const _navCoolContact = Color(0xFFC0C8D0);
const _navInnerCompression = Color(0xFFAEB7C0);

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

  static const double _height = 58;
  static const double _radius = 22;

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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_radius),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          // 上緣提亮、中段保持乾淨、下緣稍微壓暗，讓 nav 像有厚度的白色材質。
          stops: [0.0, 0.04, 0.06, 0.94, 0.96, 1.0],
          colors: [
            _navTopEdge,
            _navSoftCrown,
            _navBase,
            _navBase,
            Color(0xFFF5F5F3),
            _navLowerEdge,
          ],
        ),
        boxShadow: [
          // 左上外側保留很淡的接觸陰影，讓邊緣從背景中分離。
          BoxShadow(
            color: _navWarmContact.withValues(alpha: 0.24),
            offset: const Offset(-1.5, -1.5),
            blurRadius: 4,
            spreadRadius: -4,
          ),
          // 主要接觸陰影往右下收，對應左上光源。
          BoxShadow(
            color: _navWarmContact.withValues(alpha: 0.66),
            offset: const Offset(3, 8),
            blurRadius: 10,
            spreadRadius: -5,
          ),
          // 第二層只保留很淡的底部重量，避免下方陰影過度擴散。
          BoxShadow(
            color: _navWarmContact.withValues(alpha: 0.16),
            offset: const Offset(1, 15),
            blurRadius: 20,
            spreadRadius: -18,
          ),
          // 右下冷色陰影短而集中，補出右邊厚度但不拉髒背景。
          BoxShadow(
            color: _navCoolContact.withValues(alpha: 0.20),
            offset: const Offset(5, 8),
            blurRadius: 12,
            spreadRadius: -10,
          ),
          // 內側上緣高光：這是 nav 看起來俐落、不是灰白塊的關鍵。
          BoxShadow(
            color: const Color(0xFFFFFFFF).withValues(alpha: 0.68),
            offset: const Offset(0, 1.6),
            blurRadius: 3.8,
            spreadRadius: -3,
            inset: true,
          ),
          // 內側細高光，保留白色材質的薄亮邊。
          BoxShadow(
            color: const Color(0xFFFFFFFF).withValues(alpha: 0.34),
            offset: const Offset(0, 0.8),
            blurRadius: 1.0,
            spreadRadius: -1.0,
            inset: true,
          ),
          // 內側右下壓縮暗邊，讓厚度集中在光源反方向。
          BoxShadow(
            color: _navInnerCompression.withValues(alpha: 0.38),
            offset: const Offset(-1.8, -3.4),
            blurRadius: 3.8,
            spreadRadius: -3.4,
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
        ? Drop4UpTokens.primaryBlue
        : Drop4UpTokens.textSecondary;

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

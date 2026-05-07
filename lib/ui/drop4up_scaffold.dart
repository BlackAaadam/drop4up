import 'package:flutter/material.dart';

import 'drop4up_bottom_nav.dart';
import 'drop4up_tokens.dart';

const _bottomNavHorizontalInset = 18.0;

class Drop4UpScaffold extends StatelessWidget {
  const Drop4UpScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onTabChanged,
  });

  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Drop4UpTokens.background,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  Drop4UpTokens.screenPadding,
                  28,
                  Drop4UpTokens.screenPadding,
                  Drop4UpTokens.navHeight + 40,
                ),
                child: body,
              ),
            ),
            Positioned(
              left: _bottomNavHorizontalInset,
              right: _bottomNavHorizontalInset,
              bottom: 22,
              child: Drop4UpBottomNav(
                currentIndex: currentIndex,
                onChanged: onTabChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

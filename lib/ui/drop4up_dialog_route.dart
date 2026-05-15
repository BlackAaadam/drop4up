import 'package:flutter/material.dart';

import 'drop4up_tokens.dart';

Future<T?> showDrop4UpDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Drop4UpTokens.textPrimary.withValues(alpha: 0.32),
    transitionDuration: Duration.zero,
    pageBuilder: (dialogContext, _, _) {
      return Builder(builder: builder);
    },
  );
}

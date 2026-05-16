import 'package:flutter/widgets.dart';

import 'drop4up_preferences_controller.dart';

class Drop4UpPreferencesScope
    extends InheritedNotifier<Drop4UpPreferencesController> {
  const Drop4UpPreferencesScope({
    super.key,
    required Drop4UpPreferencesController controller,
    required super.child,
  }) : super(notifier: controller);

  static Drop4UpPreferencesController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<Drop4UpPreferencesScope>();
    assert(scope != null, 'Drop4UpPreferencesScope not found in context.');
    return scope!.notifier!;
  }

  static Drop4UpPreferencesController read(BuildContext context) {
    final element = context
        .getElementForInheritedWidgetOfExactType<Drop4UpPreferencesScope>();
    final scope = element?.widget as Drop4UpPreferencesScope?;
    assert(scope != null, 'Drop4UpPreferencesScope not found in context.');
    return scope!.notifier!;
  }
}

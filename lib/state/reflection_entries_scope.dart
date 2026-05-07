import 'package:flutter/widgets.dart';

import 'reflection_entries_controller.dart';

class ReflectionEntriesScope
    extends InheritedNotifier<ReflectionEntriesController> {
  const ReflectionEntriesScope({
    super.key,
    required ReflectionEntriesController controller,
    required super.child,
  }) : super(notifier: controller);

  static ReflectionEntriesController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<ReflectionEntriesScope>();
    assert(scope != null, 'ReflectionEntriesScope was not found.');
    return scope!.notifier!;
  }

  static ReflectionEntriesController read(BuildContext context) {
    final element = context
        .getElementForInheritedWidgetOfExactType<ReflectionEntriesScope>();
    final scope = element?.widget as ReflectionEntriesScope?;
    assert(scope != null, 'ReflectionEntriesScope was not found.');
    return scope!.notifier!;
  }
}

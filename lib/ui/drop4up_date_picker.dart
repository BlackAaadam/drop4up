import 'package:flutter/material.dart';

import 'drop4up_dialog_route.dart';
import 'drop4up_tactile_surface.dart';
import 'drop4up_tokens.dart';
import 'soft_icon_button.dart';
import 'soft_surface.dart';

final DateTime drop4UpFirstEntryDate = DateTime(2000);

String formatDrop4UpEntryDate(DateTime date) {
  final local = date.toLocal();
  return '${local.year}.${_twoDigits(local.month)}.${_twoDigits(local.day)}';
}

DateTime drop4UpDateOnlyUtc(DateTime date) {
  return DateTime.utc(date.year, date.month, date.day);
}

class Drop4UpDateField extends StatelessWidget {
  const Drop4UpDateField({
    super.key,
    required this.selectedDate,
    required this.onChanged,
    this.label = '日期',
    this.showLabel = true,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onChanged;
  final String label;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final picked = await showDrop4UpDatePicker(
          context,
          initialDate: selectedDate,
        );
        if (!context.mounted || picked == null) {
          return;
        }
        onChanged(picked);
      },
      child: Drop4UpTactileSurface(
        variant: Drop4UpTactileSurfaceVariant.inset,
        radius: 21,
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        color: Drop4UpTokens.cardSurface,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.calendar_today_rounded,
              size: 17,
              color: Drop4UpTokens.primaryBlue,
            ),
            const SizedBox(width: 8),
            Text(
              showLabel
                  ? '$label ${formatDrop4UpEntryDate(selectedDate)}'
                  : formatDrop4UpEntryDate(selectedDate),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.labelLarge?.copyWith(
                color: Drop4UpTokens.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<DateTime?> showDrop4UpDatePicker(
  BuildContext context, {
  required DateTime initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) {
  final first = _dateOnly(firstDate ?? drop4UpFirstEntryDate);
  final last = _dateOnly(lastDate ?? DateTime.now());
  final initial = _clampDate(_dateOnly(initialDate), first, last);

  return showDrop4UpDialog<DateTime>(
    context: context,
    builder: (_) => _Drop4UpDatePickerDialog(
      initialDate: initial,
      firstDate: first,
      lastDate: last,
    ),
  );
}

class _Drop4UpDatePickerDialog extends StatefulWidget {
  const _Drop4UpDatePickerDialog({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  State<_Drop4UpDatePickerDialog> createState() =>
      _Drop4UpDatePickerDialogState();
}

class _Drop4UpDatePickerDialogState extends State<_Drop4UpDatePickerDialog> {
  late DateTime _selectedDate;
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _displayedMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final canGoPrevious = !_isSameMonth(_displayedMonth, widget.firstDate);
    final canGoNext = !_isSameMonth(_displayedMonth, widget.lastDate);

    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: RepaintBoundary(
        child: SoftSurface(
          variant: SoftSurfaceVariant.prominent,
          radius: 30,
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(child: Text('選擇日期', style: textTheme.titleMedium)),
                  SoftIconButton(
                    icon: Icons.close_rounded,
                    label: '關閉',
                    size: 40,
                    iconSize: 20,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Drop4UpTactileSurface(
                variant: Drop4UpTactileSurfaceVariant.inset,
                radius: 24,
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                color: Drop4UpTokens.cardSurface,
                child: Row(
                  children: [
                    _DatePickerIconButton(
                      key: const Key('date_picker_previous_month'),
                      icon: Icons.chevron_left_rounded,
                      label: '上一個月',
                      enabled: canGoPrevious,
                      onTap: () {
                        setState(() {
                          _displayedMonth = DateTime(
                            _displayedMonth.year,
                            _displayedMonth.month - 1,
                          );
                        });
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          '${_displayedMonth.year}.${_twoDigits(_displayedMonth.month)}',
                          style: textTheme.titleMedium?.copyWith(
                            color: Drop4UpTokens.primaryBlue,
                          ),
                        ),
                      ),
                    ),
                    _DatePickerIconButton(
                      key: const Key('date_picker_next_month'),
                      icon: Icons.chevron_right_rounded,
                      label: '下一個月',
                      enabled: canGoNext,
                      onTap: () {
                        setState(() {
                          _displayedMonth = DateTime(
                            _displayedMonth.year,
                            _displayedMonth.month + 1,
                          );
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _WeekdayHeader(textTheme: textTheme),
              const SizedBox(height: 7),
              _MonthGrid(
                displayedMonth: _displayedMonth,
                selectedDate: _selectedDate,
                firstDate: widget.firstDate,
                lastDate: widget.lastDate,
                onSelected: (date) => setState(() => _selectedDate = date),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _DatePickerAction(
                      label: '取消',
                      icon: Icons.close_rounded,
                      muted: true,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _DatePickerAction(
                      key: const Key('date_picker_confirm_button'),
                      label: '確認',
                      icon: Icons.check_rounded,
                      onTap: () => Navigator.of(context).pop(_selectedDate),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DatePickerIconButton extends StatelessWidget {
  const _DatePickerIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final color = enabled
        ? Drop4UpTokens.textSecondary
        : Drop4UpTokens.textSecondary.withValues(alpha: 0.34);

    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? onTap : null,
        child: SizedBox(
          width: 38,
          height: 38,
          child: Center(child: Icon(icon, size: 24, color: color)),
        ),
      ),
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader({required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    const labels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Row(
      children: [
        for (final label in labels)
          Expanded(
            child: Center(
              child: Text(
                label,
                style: textTheme.labelMedium?.copyWith(
                  color: Drop4UpTokens.textSecondary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.displayedMonth,
    required this.selectedDate,
    required this.firstDate,
    required this.lastDate,
    required this.onSelected,
  });

  final DateTime displayedMonth;
  final DateTime selectedDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onSelected;

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(displayedMonth.year, displayedMonth.month);
    final leadingEmptyCells = firstOfMonth.weekday % DateTime.daysPerWeek;
    final dayCount = DateTime(
      displayedMonth.year,
      displayedMonth.month + 1,
      0,
    ).day;

    return Column(
      children: [
        for (var row = 0; row < 6; row++) ...[
          Row(
            children: [
              for (var column = 0; column < DateTime.daysPerWeek; column++)
                Expanded(
                  child: _DayCell(
                    date: _dateForCell(
                      displayedMonth,
                      row * DateTime.daysPerWeek + column,
                      leadingEmptyCells,
                      dayCount,
                    ),
                    selectedDate: selectedDate,
                    firstDate: firstDate,
                    lastDate: lastDate,
                    onSelected: onSelected,
                  ),
                ),
            ],
          ),
          if (row < 5) const SizedBox(height: 5),
        ],
      ],
    );
  }

  DateTime? _dateForCell(
    DateTime month,
    int cellIndex,
    int leadingEmptyCells,
    int dayCount,
  ) {
    final day = cellIndex - leadingEmptyCells + 1;
    if (day < 1 || day > dayCount) {
      return null;
    }
    return DateTime(month.year, month.month, day);
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.selectedDate,
    required this.firstDate,
    required this.lastDate,
    required this.onSelected,
  });

  final DateTime? date;
  final DateTime selectedDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onSelected;

  @override
  Widget build(BuildContext context) {
    if (date == null) {
      return const SizedBox(height: 34);
    }

    final textTheme = Theme.of(context).textTheme;
    final enabled =
        !_isBeforeDate(date!, firstDate) && !_isAfterDate(date!, lastDate);
    final selected = _isSameDate(date!, selectedDate);
    final textColor = enabled
        ? selected
              ? Drop4UpTokens.primaryBlue
              : Drop4UpTokens.textPrimary.withValues(alpha: 0.84)
        : Drop4UpTokens.textSecondary.withValues(alpha: 0.42);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: GestureDetector(
        key: ValueKey('date_picker_day_${_dateKey(date!)}'),
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? () => onSelected(date!) : null,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            color: selected
                ? Drop4UpTokens.lightBlue.withValues(alpha: 0.30)
                : Colors.transparent,
            gradient: selected
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Drop4UpTokens.softWhite.withValues(alpha: 0.50),
                      Drop4UpTokens.lightBlue.withValues(alpha: 0.34),
                    ],
                  )
                : null,
            border: selected
                ? Border.all(
                    color: Drop4UpTokens.accentBlue.withValues(alpha: 0.26),
                  )
                : null,
          ),
          child: SizedBox(
            height: 34,
            child: Center(
              child: Text(
                '${date!.day}',
                style: textTheme.labelLarge?.copyWith(color: textColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DatePickerAction extends StatelessWidget {
  const _DatePickerAction({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.muted = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = muted
        ? Drop4UpTokens.textSecondary
        : Drop4UpTokens.primaryBlue;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Drop4UpTactileSurface(
        variant: muted
            ? Drop4UpTactileSurfaceVariant.raised
            : Drop4UpTactileSurfaceVariant.inset,
        radius: 20,
        height: 44,
        color: muted
            ? Drop4UpTokens.cardSurface
            : Drop4UpTokens.lightBlue.withValues(alpha: 0.34),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 7),
            Text(label, style: textTheme.labelLarge?.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

DateTime _clampDate(DateTime date, DateTime firstDate, DateTime lastDate) {
  if (_isBeforeDate(date, firstDate)) {
    return firstDate;
  }
  if (_isAfterDate(date, lastDate)) {
    return lastDate;
  }
  return date;
}

bool _isSameMonth(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month;
}

bool _isSameDate(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

bool _isBeforeDate(DateTime a, DateTime b) {
  return DateTime(
    a.year,
    a.month,
    a.day,
  ).isBefore(DateTime(b.year, b.month, b.day));
}

bool _isAfterDate(DateTime a, DateTime b) {
  return DateTime(
    a.year,
    a.month,
    a.day,
  ).isAfter(DateTime(b.year, b.month, b.day));
}

String _dateKey(DateTime date) {
  return '${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}';
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');

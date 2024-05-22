import 'package:app_grafico_compartilhado/src/widgets/input.dart';
import 'package:app_grafico_compartilhado/utils/string_utils.dart';
import 'package:flutter/material.dart';

class DatePickerWidget extends StatelessWidget {
  final String label;
  final DateTime? data;
  final bool pickTime;
  final bool enabled;
  final Future<void> Function(DateTime) onChange;

  const DatePickerWidget({
    super.key,
    required this.label,
    this.data,
    this.pickTime = false,
    this.enabled = true,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled
          ? () async {
              await _showPicker(context);
            }
          : null,
      child: Input(
        label: label,
        readonly: true,
        hint: StringUtils.formatDateSimple(DateTime.now()),
        preffixIcon: InkWell(
          mouseCursor: SystemMouseCursors.click,
          onTap: enabled
              ? () async {
                  await _showPicker(context);
                }
              : null,
          child: const Icon(Icons.calendar_month),
        ),
        value: StringUtils.formatDateSimple(data),
      ),
    );
  }

  Future<void> _showPicker(BuildContext context) async {
    DateTime? dateValue = await showDatePicker(
      context: context,
      initialDate: data ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365 * 100)),
      initialEntryMode: DatePickerEntryMode.input,
    );
    await changeDate(dateValue);
  }

  Future<void> changeDate(DateTime? dateValue) async {
    if (dateValue != null) {
      await onChange(DateTime(
        dateValue.year,
        dateValue.month,
        dateValue.day,
      ));
    }
  }
}

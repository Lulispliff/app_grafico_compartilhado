import 'package:app_grafico_compartilhado/src/widgets/input.dart';
import 'package:app_grafico_compartilhado/utils/string_utils.dart';
import 'package:flutter/material.dart';

class TimePickerWidget extends StatelessWidget {
  final String label;
  final DateTime? hora;
  final bool pickTime;
  final bool enabled;
  final Future<void> Function(DateTime) onChange;

  const TimePickerWidget({
    super.key,
    required this.label,
    this.hora,
    this.pickTime = false,
    this.enabled = true,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled
          ? () async {
              await _showTimePicker(context);
            }
          : null,
      child: Input(
        label: label,
        readonly: true,
        hint: StringUtils.formatDateHoraeMinuto(DateTime.now()),
        preffixIcon: InkWell(
          mouseCursor: SystemMouseCursors.click,
          onTap: enabled
              ? () async {
                  await _showTimePicker(context);
                }
              : null,
          child: const Icon(Icons.alarm_outlined),
        ),
        value: StringUtils.formatHoraeMinuto(hora),
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    TimeOfDay? horarioValue = await showTimePicker(
      context: context,
      initialTime: hora != null
          ? TimeOfDay(hour: hora!.hour, minute: hora!.minute)
          : TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
    );
    await changeHorario(horarioValue);
  }

  Future<void> changeHorario(TimeOfDay? horarioValue) async {
    if (horarioValue != null) {
      await onChange(
        DateTime(
          horarioValue.hour,
          horarioValue.minute,
        ),
      );
    }
  }
}

import 'package:app_grafico_compartilhado/src/widgets/input.dart';
import 'package:app_grafico_compartilhado/utils/string_utils.dart';
import 'package:flutter/material.dart';

class HourPickerWidget extends StatelessWidget {
  final String label;
  final DateTime? hora;
  final bool pickTime;
  final bool enabled;
  final Future<void> Function(DateTime) onChange;

  const HourPickerWidget({
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
              await _showTimePikcer(context);
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
                  await _showTimePikcer(context);
                }
              : null,
          child: const Icon(Icons.alarm_outlined),
        ),
        value: StringUtils.formatHoraeMinuto(hora),
      ),
    );
  }

  Future<void> _showTimePikcer(BuildContext context) async {
    DateTime? horarioValue = null;
  }

  Future<void> changeHorario(DateTime? horarioValue) async {
    if (horarioValue != null) {
      await onChange(DateTime(horarioValue.hour, horarioValue.minute));
    }
  }
}

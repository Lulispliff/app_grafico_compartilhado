import 'package:app_grafico_compartilhado/src/widgets/input.dart';
import 'package:app_grafico_compartilhado/utils/colors_app.dart';
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
        hint: StringUtils.formatHoraeMinuto(DateTime.now()),
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
    TimeOfDay initialTime = TimeOfDay.fromDateTime(hora ?? DateTime.now());

    TimeOfDay? horarioValue = await showTimePicker(
        context: context,
        initialTime: initialTime,
        initialEntryMode: TimePickerEntryMode.input,
        builder: (context, child) {
          return Theme(
            data: ThemeData().copyWith(
                colorScheme: const ColorScheme.light(primary: AppColors.color3),
                textSelectionTheme: const TextSelectionThemeData(
                  cursorColor: Colors.grey,
                  selectionColor: AppColors.color5,
                ),
                timePickerTheme: const TimePickerThemeData(
                  dialHandColor: AppColors.color2,
                  cancelButtonStyle: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColors.color2),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                  confirmButtonStyle: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColors.color2),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                )),
            child: child!,
          );
        });
    await changeHorario(horarioValue);
  }

  Future<void> changeHorario(TimeOfDay? horarioValue) async {
    if (horarioValue != null) {
      DateTime updatedDateTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        horarioValue.hour,
        horarioValue.minute,
      );
      await onChange(updatedDateTime);
    }
  }
}

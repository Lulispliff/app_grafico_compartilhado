import 'package:app_grafico_compartilhado/utils/string_utils.dart';
import 'package:app_grafico_compartilhado/src/widgets/input.dart';
import 'package:app_grafico_compartilhado/utils/colors_app.dart';
import 'package:flutter/material.dart';

class DatePickerWidget extends StatelessWidget {
  final Future<void> Function(DateTime) onChange;
  final DateTime? data;
  final bool pickTime;
  final String label;
  final bool enabled;

  const DatePickerWidget({
    required this.onChange,
    this.pickTime = false,
    required this.label,
    this.enabled = true,
    super.key,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled
          ? () async {
              await _showDatePicker(context);
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
                  await _showDatePicker(context);
                }
              : null,
          child: const Icon(Icons.calendar_month),
        ),
        value: StringUtils.formatDateSimple(data),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    DateTime? dateValue = await showDatePicker(
        context: context,
        initialDate: data ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now().add(const Duration(days: 365 * 100)),
        locale: const Locale('pt', 'BR'),
        initialEntryMode: DatePickerEntryMode.input,
        builder: (context, child) {
          return Theme(
            data: ThemeData().copyWith(
                colorScheme: const ColorScheme.light(primary: AppColors.color2),
                textSelectionTheme: const TextSelectionThemeData(
                  selectionColor: AppColors.color6,
                  cursorColor: Colors.grey,
                ),
                datePickerTheme: const DatePickerThemeData(
                  backgroundColor: AppColors.color4,
                  cancelButtonStyle: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(AppColors.color2),
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                  ),
                  confirmButtonStyle: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(AppColors.color2),
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                )),
            child: child!,
          );
        });
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

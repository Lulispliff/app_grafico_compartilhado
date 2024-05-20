import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Input extends StatefulWidget {
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final void Function(String?)? onFieldSubmitted;
  final void Function()? onEditingComplete;
  final void Function(PointerDownEvent)? onTapOutside;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final String? value;
  final bool obscureText;
  final Widget? suffixIcon;
  final bool readonly;
  final int? maxLines;
  final int? minLines;
  final InputBorder? border;
  final InputBorder? enableBorder;
  final TextInputAction? action;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? formatters;
  final String? tooltip;
  final String? suffixText;
  final TextAlign? textAlign;
  final Widget? preffixIcon;
  final String? preffixText;
  final bool? autoFocus;
  final bool selectOnFocus;
  final bool? visibility;
  final TextSelection Function()? onTap;
  final bool haveBorder;
  final Color? labelTextColor;
  final Color? cursorColor;
  final Color borderColor; // Nova propriedade
  final Color focusedBorderColor; // Nova propriedade

  const Input({
    super.key,
    this.onChanged,
    this.onEditingComplete,
    this.onTapOutside,
    this.onSaved,
    this.value,
    this.label,
    this.hint,
    this.obscureText = false,
    this.controller,
    this.focusNode,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.readonly = false,
    this.maxLines,
    this.minLines,
    this.border,
    this.action,
    this.contentPadding,
    this.enableBorder,
    this.tooltip,
    this.keyboardType,
    this.suffixText,
    this.textAlign,
    this.preffixIcon,
    this.preffixText,
    this.formatters,
    this.autoFocus,
    this.selectOnFocus = false,
    this.visibility = true,
    this.onTap,
    this.haveBorder = true,
    this.labelTextColor = Colors.grey, // Cor padrão
    this.cursorColor,
    this.borderColor = Colors.grey, // Valor padrão
    this.focusedBorderColor = Colors.grey, // Valor padrão
  });

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  TextEditingController controller = TextEditingController();
  FocusNode? focusNode;
  ThemeData? tema;

  @override
  void initState() {
    super.initState();
    focusNode = widget.focusNode;
    if (widget.controller != null) {
      controller = widget.controller!;
    }
    if (widget.value != null) {
      controller = TextEditingController(text: widget.value);
    }
    if (widget.selectOnFocus) {
      focusNode = focusNode ?? FocusNode();
      focusNode!.addListener(onFocus);
    }
  }

  @override
  void didChangeDependencies() {
    tema = Theme.of(context);

    super.didChangeDependencies();
  }

  void onFocus() {
    if (focusNode != null && focusNode!.hasFocus) {
      controller.selection =
          TextSelection(baseOffset: 0, extentOffset: controller.text.length);
    }
  }

  void verifyValueChanges() {
    String? txt = widget.value ?? controller.text;
    if (controller.text == txt) {
      return;
    }
    controller.text = txt;
    controller.selection = TextSelection(
        baseOffset: controller.text.length,
        extentOffset: controller.text.length);
  }

  @override
  Widget build(BuildContext context) {
    verifyValueChanges();
    return Visibility(
      visible: widget.visibility ?? false,
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Tooltip(
          message: widget.tooltip ?? '',
          child: TextFormField(
            style: TextStyle(
                color: widget.readonly
                    ? tema!.brightness == Brightness.dark
                        ? Colors.grey[700]
                        : Colors.grey[800]
                    : tema!.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black),
            textDirection: TextDirection.ltr,
            autofocus: widget.autoFocus ?? false,
            onChanged: (value) {
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
            onEditingComplete: widget.onEditingComplete,
            onSaved: widget.onSaved,
            onFieldSubmitted: widget.onFieldSubmitted,
            controller: controller,
            focusNode: focusNode,
            readOnly: widget.readonly,
            maxLines: widget.maxLines ?? 1,
            inputFormatters: widget.formatters,
            minLines: widget.minLines ?? 1,
            keyboardType: widget.keyboardType,
            textInputAction: widget.action,
            decoration: InputDecoration(
              contentPadding: widget.contentPadding,
              suffixIcon: widget.suffixIcon,
              suffixText: widget.suffixText,
              prefixIcon: widget.preffixIcon,
              prefixText: widget.preffixText,
              fillColor: tema?.brightness == Brightness.dark
                  ? Colors.black12
                  : Colors.grey[100],
              filled: widget.readonly,
              hintMaxLines: 1,
              label: widget.label == null
                  ? null
                  : Text(
                      widget.label!,
                      style: TextStyle(color: widget.labelTextColor),
                    ),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
              hintText: widget.hint,
              border: widget.haveBorder
                  ? widget.border ??
                      OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                            color: widget.borderColor), // Cor da borda
                      )
                  : null,
              enabledBorder: widget.haveBorder
                  ? widget.border ??
                      OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                            color: widget.borderColor), // Cor da borda
                      )
                  : null,
              focusedBorder: widget.haveBorder
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          color: widget
                              .focusedBorderColor), // Cor da borda quando focado
                    )
                  : null,
            ),
            obscureText: widget.obscureText,
            textAlign: widget.textAlign ?? TextAlign.start,
            onTapOutside: widget.onTapOutside,
            onTap: widget.onTap,
            cursorColor: Colors.grey,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose();
    }
    if (widget.focusNode == null) {
      focusNode?.dispose();
    }
    super.dispose();
  }
}

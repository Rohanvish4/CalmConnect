import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KTextFormField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final bool isPassword;
  final bool obscureText;
  final FocusNode? focusNode;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? filled;
  final bool? isReadOnly;
  final double borderWidth;
  final Color focusBorderColor;
  final Color enabledBorderColor;
  final bool isBorderSide;
  final Color? fillColor;
  final int? maxLines;
  final int? maxLength;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final void Function()? onTap;
  final TextAlign? textAlignment;
  final TextInputType? keyboardType;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? contentPadding;
  final List<TextInputFormatter>? inputFormatters;

  const KTextFormField({
    super.key,
    this.labelText,
    this.isPassword = false,
    this.obscureText = false,
    this.isReadOnly,
    this.prefixIcon,
    this.focusNode,
    this.contentPadding,
    this.focusBorderColor = Colors.black,
    this.enabledBorderColor = Colors.black,
    this.suffixIcon,
    this.borderWidth = 1,
    this.validator,
    this.fillColor,
    this.inputFormatters,
    this.filled,
    this.textStyle,
    this.hintStyle,
    this.constraints,
    this.maxLines,
    this.onTap,
    this.maxLength,
    this.isBorderSide = true,
    this.hintText,
    this.onChanged,
    this.textAlignment,
    this.keyboardType,
    required this.controller,
  });

  @override
  KTextFormFieldState createState() => KTextFormFieldState();
}

class KTextFormFieldState extends State<KTextFormField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final kPrimaryColor = Colors.blue;
    final dimBlackColor = Colors.black45;
    return TextFormField(
      controller: widget.controller,
      onTap: widget.onTap,
      focusNode: widget.focusNode,
      maxLength: widget.maxLength,
      cursorColor: kPrimaryColor,
      cursorErrorColor: kPrimaryColor,
      maxLines: widget.isPassword ? 1 : widget.maxLines ?? 1,
      readOnly: widget.isReadOnly ?? false,
      style: widget.textStyle,
      obscureText: widget.isPassword ? _obscureText : false,
      //   inputFormatters: widget.inputFormatters??inputFormatters,
      decoration: InputDecoration(
        fillColor: widget.fillColor ?? Colors.transparent,
        filled: widget.filled ?? false,
        labelText: widget.labelText,
        constraints: widget.constraints,
        hintText: widget.hintText,
        hintStyle:
            widget.hintStyle ??
            const TextStyle(fontSize: 15, color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: widget.isBorderSide
              ? BorderSide(
                  color: widget.enabledBorderColor,
                  width: widget.borderWidth,
                )
              : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: widget.isBorderSide
              ? BorderSide(
                  color: widget.focusBorderColor,
                  width: widget.borderWidth,
                )
              : BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: widget.isBorderSide
              ? BorderSide(color: dimBlackColor, width: widget.borderWidth)
              : BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: widget.isBorderSide
              ? BorderSide(color: dimBlackColor, width: widget.borderWidth)
              : BorderSide.none,
        ),
        contentPadding:
            widget.contentPadding ??
            EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        errorStyle: const TextStyle(fontSize: 12.0, color: Colors.blue),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: dimBlackColor,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : (widget.suffixIcon),
      ),
      textAlign: widget.textAlignment ?? TextAlign.start,
      validator: widget.validator,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      buildCounter:
          (
            BuildContext context, {
            required int currentLength,
            required int? maxLength,
            required bool isFocused,
          }) {
            return null;
          },
    );
  }
}

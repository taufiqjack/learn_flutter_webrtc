import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learn_flutter_webrtc/core/constants/color_constant.dart';

class CommonTextField extends StatelessWidget {
  final String hintText;
  final Widget? suffix;
  final String? suffixLabel;
  final String? prefixLabel;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? label;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final TextInputType textInputType;
  final bool? readOnly;
  final bool? filled;
  final FocusNode? focusNode;
  final Function()? onTap;
  final Function(String)? onChange;
  final Function()? onComplete;
  final String? Function(String?)? validator;
  final int? maxLine;
  final int? maxLength;
  final Color? labelColor;
  final List<TextInputFormatter>? inputFormatter;

  const CommonTextField({
    super.key,
    required this.hintText,
    this.suffix,
    this.suffixLabel,
    this.controller,
    required this.textInputType,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly,
    this.filled,
    this.focusNode,
    this.onTap,
    this.onChange,
    this.onComplete,
    this.validator,
    this.maxLine,
    this.maxLength,
    this.inputFormatter,
    this.prefixLabel,
    this.labelColor,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      maxLines: maxLine,
      controller: controller,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(color: labelColor ?? black),
      keyboardType: textInputType,
      textInputAction: textInputAction,
      readOnly: readOnly != null ? true : false,
      onTap: onTap,
      focusNode: focusNode,
      onChanged: onChange,
      onEditingComplete: onComplete,
      decoration: InputDecoration(
        label: label,
        hintText: hintText,
        prefixText: prefixLabel,
        hintStyle: const TextStyle(color: greyThree),
        filled: filled != null ? true : false,
        fillColor: whiteTwo,
        counterText: '',
        prefixIcon: prefixIcon,
        suffix: suffixLabel != null
            ? Text(
                '$suffixLabel',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: greyThree),
              )
            : null,
        suffixIcon: suffixIcon,
        labelStyle:
            Theme.of(context).textTheme.titleMedium?.copyWith(color: black),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: greyThree),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: greyThree),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: greyThree),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      inputFormatters: inputFormatter,
      validator: validator,
    );
  }
}

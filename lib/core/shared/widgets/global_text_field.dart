import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/helpers/form_border.dart';
import 'package:evo_project/core/helpers/validators.dart';
import 'package:evo_project/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

enum TextFormFieldType { name, email, password, phoneNumber }

class GlobalTextField extends StatelessWidget {
  final String text;
  final TextFormFieldType fieldType;
  final TextInputType textInputType;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final bool obscureText;
  final void Function(String)? onChanged;

  const GlobalTextField({
    super.key,
    required this.text,
    required this.fieldType,
    required this.textInputType,
    this.validator,
    required this.controller,
    this.suffixIcon,
    this.obscureText = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator:
          validator ??
          ((val) => Validators.validateField(fieldType, controller.text)),
      keyboardType: textInputType,
      style: TextStyle(fontSize: 18, color: Colors.black87),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(color: Colors.white),
          child: Text(
            text,
            style: context.textStyles.bodyMedium!.copyWith(
              fontWeight: AppTypography.medium,
              color: context.colors.primary,
            ),
          ),
        ),

        enabledBorder: TopBottomInputBorder(
          borderSide: BorderSide(color: Color(0xffDBE9F5)),
        ),

        focusedBorder: TopBottomInputBorder(
          borderSide: BorderSide(color: context.colors.primary),
        ),

        errorBorder: TopBottomInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),

        focusedErrorBorder: TopBottomInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),

        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.only(top: -9, bottom: 16),
      ),
      obscureText: obscureText,
      onChanged: onChanged,
    );
  }
}

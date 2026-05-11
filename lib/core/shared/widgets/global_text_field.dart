import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/helpers/form_border.dart';
import 'package:evo_project/core/helpers/validators.dart';
import 'package:evo_project/core/theme/app_colors.dart';
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
  final bool? isRequierdValidator;
  final String? hintText;
  final AutovalidateMode validationMode;
  final int? minLines;
  final int? maxLines;
  final VoidCallback? onTap;
  final bool readOnly;

  const GlobalTextField({
    super.key,
    required this.text,
    required this.fieldType,
    required this.textInputType,
    required this.validationMode,
    this.validator,
    required this.controller,
    this.suffixIcon,
    this.obscureText = false,
    this.onChanged,
    this.isRequierdValidator,
    this.hintText,
    this.minLines,
    this.maxLines,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxLines == null ? 50.h(context) : null,
      child: Center(
        child: TextFormField(
          controller: controller,
          autovalidateMode: validationMode,
          validator: isRequierdValidator == null
              ? validator ??
                    ((val) =>
                        Validators.validateField(fieldType, controller.text))
              : null,
          keyboardType: textInputType,
          style: context.textStyles.bodyLarge!.copyWith(
            color: AppColors.textPrimary,
            fontSize: 18,
          ),
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.only(left: 10),
              decoration: const BoxDecoration(color: AppColors.background),
              child: Text(
                text,
                style: context.textStyles.bodyMedium!.copyWith(
                  fontWeight: AppTypography.medium,
                  color: context.colors.primary,
                ),
              ),
            ),
            hintText: hintText,
            hintStyle: context.textStyles.bodyMedium,
            enabledBorder: const TopBottomInputBorder(
              borderSide: BorderSide(color: AppColors.border),
            ),

            focusedBorder: TopBottomInputBorder(
              borderSide: BorderSide(color: context.colors.primary),
            ),

            errorBorder: const TopBottomInputBorder(
              borderSide: BorderSide(color: AppColors.error),
            ),

            focusedErrorBorder: const TopBottomInputBorder(
              borderSide: BorderSide(color: AppColors.error, width: 1.5),
            ),

            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.only(top: -9, bottom: 16),
          ),
          obscureText: obscureText,
          onChanged: onChanged,
          maxLines: maxLines ?? 1,
          minLines: minLines,
          onTap: onTap,
          readOnly: readOnly,
        ),
      ),
    );
  }
}

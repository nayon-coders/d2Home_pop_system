import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/theme.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final Widget? suffixIcon;
  final bool? obscure;
  final TextEditingController? textController;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final Function(String)? onFieldSubmitted;
  final TextInputType? inputType;
  final String? initialText;
  final String? hintText;
  final String? descriptionText;
  final bool readOnly;
  final bool isError;
  final bool isSuccess;
  final String? Function(String? value)? validator;
  final TextCapitalization? textCapitalization;

  const CustomTextField({
    super.key,
    this.label,
    this.suffixIcon,
    this.obscure,
    this.onChanged,
    this.textController,
    this.inputType,
    this.initialText,
    this.descriptionText,
    this.readOnly = false,
    this.isError = false,
    this.isSuccess = false,
    this.textCapitalization,
    this.onFieldSubmitted,
    this.onTap,
    this.hintText, this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          validator: validator,
          onTap: onTap,
          onFieldSubmitted: onFieldSubmitted,
          onChanged: onChanged,
          obscureText: !(obscure ?? true),
          obscuringCharacter: '*',
          controller: textController,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
            color: AppStyle.black,
            letterSpacing: -14 * 0.01,
          ),
          cursorWidth: 1,
          cursorColor: AppStyle.black,
          keyboardType: inputType,
          initialValue: initialText,
          readOnly: readOnly,
          textCapitalization:
              textCapitalization ?? TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffixIcon,
            labelText: label,
            floatingLabelStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w400,
              fontSize: 15.sp,
              color: AppStyle.black,
              letterSpacing: -14 * 0.01,
            ),
            hoverColor: AppStyle.transparent,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppStyle.differborder),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppStyle.black),
            ),
          ),
        ),
        if (descriptionText != null)
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              4.verticalSpace,
              Text(
                descriptionText!,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.3,
                  fontSize: 12.sp,
                  color: isError
                      ? AppStyle.red
                      : isSuccess
                          ? AppStyle.primary
                          : AppStyle.black,
                ),
              ),
            ],
          )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_desktop/src/core/constants/constants.dart';
import 'package:admin_desktop/src/core/utils/app_helpers.dart';
import 'package:admin_desktop/src/presentation/theme/theme.dart';
import '../login_button.dart';

class SuccessfullDialog extends StatelessWidget {
  final String? title, content;
  final Function()? onPressed;
  const SuccessfullDialog(
      {super.key, this.title, this.content, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 355.w,
      height: 311.h,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          30.verticalSpace,
          Container(
            height: 68.h,
            width: 68.w,
            decoration: const BoxDecoration(
                color: AppStyle.primary, shape: BoxShape.circle),
            child: const Center(
                child: Icon(
              Icons.done,
              color: AppStyle.white,
            )),
          ),
          22.verticalSpace,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              title ?? '',
              style: GoogleFonts.inter(
                  fontSize: 22.sp,
                  color: AppStyle.black,
                  fontWeight: FontWeight.w600),
            ),
          ),
          6.verticalSpace,
          Text(
            content ?? '',
            style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: AppStyle.icon,
                fontWeight: FontWeight.w500),
          ),
          48.verticalSpace,
          Padding(
            padding: const EdgeInsets.only(right: 87, left: 82),
            child: LoginButton(
                title: AppHelpers.getTranslation(TrKeys.homePage),
                onPressed: onPressed),
          )
        ],
      ),
    );
  }
}

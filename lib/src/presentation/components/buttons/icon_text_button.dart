import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class IconTextButton extends StatelessWidget {
  final Color backgroundColor;
  final IconData iconData;
  final Color icon;
  final String title;
  final double height;
  final Color textColor;
  final BorderRadius? radius;
  final Function()? onPressed;

  const IconTextButton({
    super.key,
    required this.backgroundColor,
    required this.iconData,
    required this.icon,
    required this.title,
    required this.textColor,
    required this.onPressed,
    this.height = 40,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: radius ?? BorderRadius.circular(24.r),
      color: backgroundColor,
      child: InkWell(
        borderRadius: radius ?? BorderRadius.circular(24.r),
        onTap: onPressed,
        child: Container(
          height: height.r,
          alignment: Alignment.center,
          padding: REdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(
                iconData,
                size: 24.r,
                color: icon,
              ),
              12.horizontalSpace,
              Text(
                title,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  color: textColor,
                  letterSpacing: -14 * 0.02,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

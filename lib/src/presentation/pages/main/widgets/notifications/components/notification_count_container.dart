import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:admin_desktop/src/presentation/theme/theme.dart';

class NotificationCountsContainer extends StatelessWidget {
  final String? count;
  const NotificationCountsContainer({super.key, this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24.r,
      width: 38.r,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: AppStyle.primary),
      child: Center(
        child: Text(
          count ?? '',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
            color: AppStyle.white,
          ),
        ),
      ),
    );
  }
}

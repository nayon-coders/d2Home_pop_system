import 'package:admin_desktop/src/core/constants/constants.dart';
import 'package:admin_desktop/src/core/utils/utils.dart';
import 'package:admin_desktop/src/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HasMoreButton extends StatelessWidget {
  final bool hasMore;
  final VoidCallback onViewMore;

  const HasMoreButton({
    super.key,
    required this.hasMore,
    required this.onViewMore,
  });

  @override
  Widget build(BuildContext context) {
    return (hasMore
        ? InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onViewMore,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppStyle.black.withOpacity(0.17),
                  width: 1.r,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                AppHelpers.getTranslation(TrKeys.viewMore),
                style: GoogleFonts.inter(
                    fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
            ),
          )
        : const SizedBox());
  }
}

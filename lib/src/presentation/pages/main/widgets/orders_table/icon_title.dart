import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:admin_desktop/src/presentation/theme/theme.dart';

class IconTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;

  const IconTitle(
      {super.key, required this.title, required this.icon, required this.value})
     ;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 21),
          6.horizontalSpace,
          Expanded(
            child: Text(
              "$title: $value",
              style: GoogleFonts.inter(
                fontSize: 15,
                color: AppStyle.black,
              ),
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }
}

import 'package:admin_desktop/src/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleChoosingButton extends StatelessWidget {
  final bool isActive;
  const CircleChoosingButton({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18.h,
      width: 18.w,
      decoration: BoxDecoration(
          color: isActive
              ? AppStyle.primary
              : AppStyle.transparent,
          shape: BoxShape.circle,
          border: Border.all(
              color: !isActive
                  ? AppStyle.icon
                  : AppStyle.transparent,
              width: 2)),
      child: Center(
        child: Container(
          height: 6.h,
          width: 6.w,
          decoration: BoxDecoration(
              color:isActive
                  ? AppStyle.locationAddress
                  : AppStyle.transparent,
              shape: BoxShape.circle),
        ),
      ),
    );
  }
}

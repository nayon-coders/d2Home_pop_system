import 'package:admin_desktop/src/core/utils/app_helpers.dart';
import 'package:admin_desktop/src/models/data/addons_data.dart';
import 'package:admin_desktop/src/presentation/components/custom_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:admin_desktop/src/presentation/theme/theme.dart';
class IngredientItem extends ConsumerWidget {
  final VoidCallback onTap;
  final VoidCallback add;
  final VoidCallback remove;
  final Addons addon;

  const IngredientItem({
    required this.onTap,
    required this.add,
    required this.remove,
    required this.addon,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = addon.active ?? false;
    final quantity = addon.quantity ?? 1;
    final title = addon.product?.translation?.title ?? '';
    final price = addon.product?.stock?.totalPrice ?? 0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppStyle.primary, width: 1),
          borderRadius: BorderRadius.circular(12.r),
          color: isActive ? AppStyle.primary.withOpacity(0.08) : AppStyle.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Quantity Controls (Only visible if active)
            if (isActive) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _CircleIconButton(
                    icon: Icons.remove,
                    onPressed: remove,
                    color: AppStyle.removeButtonColor,
                    iconColor: quantity == 1
                        ? AppStyle.outlineButtonBorder
                        : AppStyle.black,
                  ),
                  10.horizontalSpace,
                  Text(
                    "$quantity",
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  10.horizontalSpace,
                  _CircleIconButton(
                    icon: Icons.add,
                    onPressed: add,
                    color: AppStyle.addButtonColor,
                    iconColor: AppStyle.black,
                  ),
                ],
              ),
              12.verticalSpace,
            ],

            /// Title & Price
            Column(
             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppStyle.black,
                  ),
                ),
                8.horizontalSpace,
                Text(
                  "+${AppHelpers.numberFormat(price)}",
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: AppStyle.hint,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;
  final Color iconColor;

  const _CircleIconButton({
    required this.icon,
    required this.onPressed,
    required this.color,
    required this.iconColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Icon(
          icon,
          size: 16.sp,
          color: iconColor,
        ),
      ),
    );
  }
}

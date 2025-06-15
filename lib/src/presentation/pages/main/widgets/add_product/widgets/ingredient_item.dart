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
    required this.add,
    required this.remove,
    super.key,
    required this.onTap,
    required this.addon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: AppStyle.primary),
          color: addon.active == true ? AppStyle.primary.withOpacity(0.1) : AppStyle.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Quantity Controls (if active)
            if (addon.active ?? false)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: remove,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppStyle.removeButtonColor,
                      ),
                      child: Icon(
                        Icons.remove,
                        size: 16,
                        color: (addon.quantity ?? 1) == 1
                            ? AppStyle.outlineButtonBorder
                            : AppStyle.black,
                      ),
                    ),
                  ),
                  6.horizontalSpace,
                  Text(
                    "${addon.quantity ?? 1}",
                    style: GoogleFonts.inter(fontSize: 14.sp),
                  ),
                  6.horizontalSpace,
                  InkWell(
                    onTap: add,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppStyle.addButtonColor,
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 16,
                        color: AppStyle.black,
                      ),
                    ),
                  ),
                ],
              ),
            if (addon.active ?? false) 8.verticalSpace,

            /// Title + Price
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    addon.product?.translation?.title ?? "",
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: AppStyle.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                4.horizontalSpace,
                Text(
                  "+${AppHelpers.numberFormat(addon.product?.stock?.totalPrice ?? 0)}",
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

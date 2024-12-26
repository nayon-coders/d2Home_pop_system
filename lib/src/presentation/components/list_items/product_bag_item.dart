import 'package:admin_desktop/src/core/constants/constants.dart';
import 'package:admin_desktop/src/models/data/addons_data.dart';
import 'package:admin_desktop/src/models/data/product_data.dart';
import 'package:admin_desktop/src/presentation/components/buttons/animation_button_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;

import 'package:admin_desktop/src/core/utils/utils.dart';
import 'package:admin_desktop/src/presentation/theme/theme.dart';

class CartOrderItem extends StatelessWidget {
  final ProductData? cart;
  final String? symbol;
  final VoidCallback add;
  final VoidCallback remove;
  final VoidCallback delete;
  final bool isActive;
  final bool isOwn;

  const CartOrderItem({
    super.key,
    required this.add,
    required this.remove,
    required this.cart,
    required this.delete,
    this.isActive = true,
    this.isOwn = true,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context) {
    num sumPrice = 0;
    num disSumPrice = 0;
    for (Addons e in (cart?.addons ?? [])) {
      sumPrice += (e.price ?? 0);
    }
    disSumPrice = (cart?.totalPrice ?? 0) + (cart?.discount ?? 0);
    sumPrice += (cart?.totalPrice ?? 0);
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.12,
        motion: const ScrollMotion(),
        children: [
          Expanded(
            child: Builder(
              builder: (context) {
                return GestureDetector(
                  onTap: () {
                    Slidable.of(context)?.close();
                    delete.call();
                  },
                  child: Container(
                    width: 50.r,
                    height: 72.r,
                    decoration: BoxDecoration(
                      color: AppStyle.red,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        bottomLeft: Radius.circular(16.r),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      FlutterRemix.close_fill,
                      color: AppStyle.white,
                      size: 24.r,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      child: Column(
        children: [
          if (isActive && cart?.bonus != true)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppStyle.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.r),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RichText(
                                  text: TextSpan(
                                      text: cart
                                          ?.stock?.product?.translation?.title,
                                      style: GoogleFonts.inter(
                                        fontSize: 14.sp,
                                        color: AppStyle.black,
                                      ),
                                      children: [
                                        if (cart?.stock?.extras?.isNotEmpty ??
                                            false)
                                          TextSpan(
                                            text:
                                            " (${cart?.stock?.extras?.first.value ?? ""})",
                                            style: GoogleFonts.inter(
                                              fontSize: 14.sp,
                                              color: AppStyle.hint,
                                            ),
                                          )
                                      ])),
                              8.verticalSpace,
                              for (Addons e in (cart?.addons ?? []))
                                Text(
                                  "${e.product?.translation?.title ?? ""} ( ${AppHelpers.numberFormat((e.price ?? 0) / (e.quantity ?? 1), symbol: symbol)} x ${(e.quantity ?? 1)} )",
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    color: AppStyle.unselectedTab,
                                  ),
                                ),
                              16.verticalSpace,
                            ],
                          ),
                        ),
                      ),
                      4.horizontalSpace,
                      (cart?.stock?.bonus != null || (cart?.bonus ?? false))
                          ? Positioned(
                        bottom: 4.r,
                        right: 4.r,
                        child: Container(
                          width: 22.w,
                          height: 22.h,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppStyle.blue),
                          child: Icon(
                            FlutterRemix.gift_2_fill,
                            size: 14.r,
                            color: AppStyle.white,
                          ),
                        ),
                      )
                          : const SizedBox.shrink(),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 16.w),
                        decoration: BoxDecoration(
                            color: AppStyle.primary,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.r),
                                bottomRight: Radius.circular(10.r))),
                        child: Text(
                          "${(cart?.quantity ?? 1).toString()}x",
                          style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: AppStyle.black,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      24.horizontalSpace,
                      GestureDetector(
                        onTap: remove,
                        child: AnimationButtonEffect(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppStyle.removeButtonColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.r),
                                bottomLeft: Radius.circular(10.r),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.h, horizontal: 25.w),
                              child: const Icon(
                                Icons.remove,
                                color: AppStyle.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      4.horizontalSpace,
                      GestureDetector(
                        onTap: add,
                        child: AnimationButtonEffect(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppStyle.addButtonColor,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.r),
                                bottomRight: Radius.circular(10.r),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.h, horizontal: 25.w),
                              child: const Icon(
                                Icons.add,
                                color: AppStyle.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      !(cart?.stock?.bonus != null || (cart?.bonus ?? false))
                          ? Column(
                        children: [
                          Text(
                            intl.NumberFormat.currency(
                              symbol: symbol ??
                                  LocalStorage.getSelectedCurrency()
                                      .symbol,
                            ).format((cart?.discount ?? 0) != 0
                                ? disSumPrice
                                : sumPrice),
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: (cart?.discount ?? 0) != 0
                                    ? 12.sp
                                    : 16.sp,
                                color: AppStyle.black,
                                decoration: (cart?.discount ?? 0) != 0
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none),
                          ),
                          (cart?.discount ?? 0) != 0
                              ? Container(
                            margin: EdgeInsets.only(top: 8.r),
                            decoration: BoxDecoration(
                                color: AppStyle.red,
                                borderRadius:
                                BorderRadius.circular(30.r)),
                            padding: EdgeInsets.all(4.r),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                    "assets/svg/discount.svg"),
                                4.horizontalSpace,
                                Text(
                                  AppHelpers.numberFormat(
                                    sumPrice,
                                    symbol: symbol,
                                  ),

                                  /// usage

                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                      color: AppStyle.white),
                                )
                              ],
                            ),
                          )
                              : const SizedBox.shrink()
                        ],
                      )
                          : const SizedBox.shrink(),
                      16.horizontalSpace,
                    ],
                  ),
                ],
              ),
            )
          else
            Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.all(16.r),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppStyle.white,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: AppStyle.border)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(
                          text: cart
                              ?.stock?.product?.translation?.title,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: AppStyle.black,
                          ),
                          children: [
                            if (cart?.stock?.extras?.isNotEmpty ??
                                false)
                              TextSpan(
                                text:
                                " (${cart?.stock?.extras?.first.value ?? ""})",
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  color: AppStyle.hint,
                                ),
                              )
                          ])),
                  8.verticalSpace,
                  for (Addons e in (cart?.addons ?? []))
                    Text(
                      "${e.product?.translation?.title ?? ""} ( ${AppHelpers.numberFormat((e.price ?? 0) / (e.quantity ?? 1), symbol: symbol)} x ${(e.quantity ?? 1)} )",
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        color: AppStyle.black,
                      ),
                    ),
                  8.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${AppHelpers.numberFormat(
                            (cart?.stock?.price ?? 0) /
                                (cart?.quantity ?? 1),
                            symbol: symbol,
                          )} X ${cart?.quantity ?? 1}",
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: AppStyle.black,
                          ),
                        ),
                      ),
                      Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: AppStyle.blue),
                        child: Icon(
                          FlutterRemix.gift_2_fill,
                          size: 20.r,
                          color: AppStyle.white,
                        ),
                      ),
                      4.horizontalSpace,
                      Text(AppHelpers.getTranslation(TrKeys.bonus)),
                      4.horizontalSpace,
                    ],
                  ),
                ],
              ),
            ),
          isActive ? const Divider() : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

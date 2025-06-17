import 'package:admin_desktop/src/core/constants/constants.dart';
import 'package:admin_desktop/src/core/utils/app_helpers.dart';
import 'package:admin_desktop/src/core/utils/utils.dart';
import 'package:admin_desktop/src/models/data/bag_data.dart';
import 'package:admin_desktop/src/models/data/order_body_data.dart';
import 'package:admin_desktop/src/presentation/pages/main/riverpod/notifier/main_notifier.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/order_calculate/calculator_controller.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/orders_table/orders/new/new_orders_provider.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/right_side/riverpod/right_side_notifier.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/right_side/riverpod/right_side_state.dart';
import 'package:admin_desktop/src/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../components/components.dart';
import '../orders_table/orders/accepted/accepted_orders_provider.dart';

///todo: nayon coders price info
class PriceInfo extends StatelessWidget {
  final BagData bag;
  final RightSideState state;
  final RightSideNotifier notifier;
  final MainNotifier mainNotifier;
  final String selectedPayment;

  const PriceInfo(
      {super.key,
      required this.state,
      required this.notifier,
      required this.bag,
      required this.selectedPayment,
      required this.mainNotifier});

  @override
  Widget build(BuildContext context) {

    var totalPrice = state.paginateResponse!.totalPrice! - state.paginateResponse!.serviceFee!;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppHelpers.getTranslation(TrKeys.subtotal),
              style: GoogleFonts.inter(
                color: AppStyle.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.4,
              ),
            ),
            Text(
              AppHelpers.numberFormat(
                state.paginateResponse?.price ?? 0,
              ),
              style: GoogleFonts.inter(
                color: AppStyle.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
        12.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppHelpers.getTranslation(TrKeys.tax),
              style: GoogleFonts.inter(
                color: AppStyle.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.4,
              ),
            ),
            Text(
              AppHelpers.numberFormat(state.paginateResponse?.totalTax ?? 0,
                  symbol: bag.selectedCurrency?.symbol),
              style: GoogleFonts.inter(
                color: AppStyle.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
        12.verticalSpace,
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(
        //       AppHelpers.getTranslation(TrKeys.serviceFee),
        //       style: GoogleFonts.inter(
        //         color: AppStyle.black,
        //         fontSize: 16.sp,
        //         fontWeight: FontWeight.w500,
        //         letterSpacing: -0.4,
        //       ),
        //     ),
        //     Text(
        //       AppHelpers.numberFormat(state.paginateResponse?.serviceFee ?? 0,
        //           symbol: bag.selectedCurrency?.symbol),
        //       style: GoogleFonts.inter(
        //         color: AppStyle.black,
        //         fontSize: 16.sp,
        //         fontWeight: FontWeight.w400,
        //         letterSpacing: -0.4,
        //       ),
        //     ),
        //   ],
        // ),
        // 12.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppHelpers.getTranslation(TrKeys.deliveryFee),
              style: GoogleFonts.inter(
                color: AppStyle.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.4,
              ),
            ),
            Text(
              AppHelpers.numberFormat(state.paginateResponse?.deliveryFee ?? 0,
                  symbol: bag.selectedCurrency?.symbol),
              style: GoogleFonts.inter(
                color: AppStyle.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
        12.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppHelpers.getTranslation(TrKeys.discount),
              style: GoogleFonts.inter(
                color: AppStyle.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.4,
              ),
            ),
            Text(
              "-${AppHelpers.numberFormat(state.paginateResponse?.totalDiscount ?? 0, symbol: bag.selectedCurrency?.symbol)}",
              style: GoogleFonts.inter(
                color: AppStyle.red,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
        12.verticalSpace,
        state.paginateResponse?.couponPrice != 0
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppHelpers.getTranslation(TrKeys.promoCode),
                    style: GoogleFonts.inter(
                      color: AppStyle.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.4,
                    ),
                  ),
                  Text(
                    "-${AppHelpers.numberFormat(state.paginateResponse?.couponPrice ?? 0, symbol: bag.selectedCurrency?.symbol)}",
                    style: GoogleFonts.inter(
                      color: AppStyle.red,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink(),
        const Divider(),


      ],
    );
  }
}

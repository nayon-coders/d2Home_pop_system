import 'package:admin_desktop/generated/assets.dart';
import 'package:admin_desktop/main.dart';
import 'package:admin_desktop/src/core/constants/constants.dart';
import 'package:admin_desktop/src/core/utils/app_helpers.dart';
import 'package:admin_desktop/src/presentation/components/custom_scaffold.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/sale_history/riverpod/sale_history_notifier.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/sale_history/riverpod/sale_history_state.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/sale_history/sale_tab.dart';
import 'package:admin_desktop/src/presentation/pages/printer_manage/controller/printer_controller.dart';
import 'package:admin_desktop/src/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../components/components.dart';
import 'riverpod/sale_history_provider.dart';

class SaleHistory extends ConsumerStatefulWidget {
  const SaleHistory({super.key});

  @override
  ConsumerState<SaleHistory> createState() => _SaleHistoryState();
}

class _SaleHistoryState extends ConsumerState<SaleHistory> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(saleHistoryProvider.notifier)
        ..fetchSale()
        ..fetchSaleCarts();
    });
  }




  @override
  Widget build(BuildContext context) {
    final state = ref.watch(saleHistoryProvider);
    final event = ref.read(saleHistoryProvider.notifier);
    return CustomScaffold(
      body: (c) => ListView(
        padding: EdgeInsets.symmetric(vertical: 20.r, horizontal: 16.r),
        shrinkWrap: true,
        children: [
          Text(
            AppHelpers.getTranslation(TrKeys.saleHistory),
            style:
                GoogleFonts.inter(fontSize: 22.r, fontWeight: FontWeight.w600),
          ),
          16.verticalSpace,
          _topWidgets(state, event),
          16.verticalSpace,
          if (state.selectIndex == 2) _saleCarts(state),
          16.verticalSpace,
          SaleTab(
            isMoreLoading: state.isMoreLoading,
            isLoading: state.isLoading,
            list: state.selectIndex == 0
                ? state.listDriver
                : state.selectIndex == 1
                    ? state.listToday
                    : state.listHistory,
            hasMore: state.hasMore,
            viewMore: () {
              event.fetchSalePage();
            },
          )
        ],
      ),
    );
  }

  Widget _saleCarts(SaleHistoryState state) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 30.r),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: AppStyle.white),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppHelpers.getTranslation(TrKeys.openingDrawerAmount),
                      style: GoogleFonts.inter(fontSize: 16.sp),
                    ),
                    20.verticalSpace,
                    Text(
                      AppHelpers.numberFormat(
                        state.saleCart?.deliveryFee ?? 0,
                      ),
                      style: GoogleFonts.inter(
                          fontSize: 24.sp, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppStyle.primary.withOpacity(0.01),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 32.r,
                              spreadRadius: 12.r,
                              color: AppStyle.primary.withOpacity(0.5))
                        ]),
                    child: SvgPicture.asset(Assets.svgCart))
              ],
            ),
          ),
        ),
        12.horizontalSpace,
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 30.r),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: AppStyle.white),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppHelpers.getTranslation(TrKeys.cashPaymentSale),
                      style: GoogleFonts.inter(fontSize: 16.sp),
                    ),
                    20.verticalSpace,
                    Text(
                      AppHelpers.numberFormat(
                        state.saleCart?.cash ?? 0,
                      ),
                      style: GoogleFonts.inter(
                          fontSize: 24.sp, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppStyle.starColor.withOpacity(0.01),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 32.r,
                              spreadRadius: 12.r,
                              color: AppStyle.starColor.withOpacity(0.5))
                        ]),
                    child: SvgPicture.asset(Assets.svgDollar))
              ],
            ),
          ),
        ),
        12.horizontalSpace,
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 30.r),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: AppStyle.white),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppHelpers.getTranslation(TrKeys.otherPaymentSale),
                      style: GoogleFonts.inter(fontSize: 16.sp),
                    ),
                    20.verticalSpace,
                    Text(
                      AppHelpers.numberFormat(
                        state.saleCart?.other ?? 0,
                      ),
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600, fontSize: 24.sp),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppStyle.blue.withOpacity(0.01),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 32.r,
                              spreadRadius: 12.r,
                              color: AppStyle.blue.withOpacity(0.5))
                        ]),
                    child: SvgPicture.asset(Assets.svgCart2))
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _topWidgets(SaleHistoryState state, SaleHistoryNotifier notifier) {
    List statusList = [TrKeys.cashDrawer, TrKeys.todaySale, TrKeys.saleHistory];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SvgPicture.asset(Assets.svgMenu),
            for (int i = 0; i < statusList.length; i++)
              Padding(
                padding: REdgeInsets.only(left: 8),
                child: ConfirmButton(
                  paddingSize: 18,
                  textSize: 14,
                  isActive: state.selectIndex == i,
                  title: AppHelpers.getTranslation(statusList[i]),
                  isTab: true,
                  isShadow: true,
                  onTap: () => notifier.changeIndex(i),
                ),
              )

          ],
        ),

        Padding(
          padding: REdgeInsets.only(left: 8),
          child: Obx(() {
              return ConfirmButton(
                paddingSize: 18,
                textSize: 14,
                isActive: Get.find<PrinterController>().selectedDevice.value != null,
                title: "🖨️ ${ Get.find<PrinterController>().selectedDevice.value!.name ?? "Connect Printer"}",
                isTab: true,
                isShadow: true,
                onTap: () {
                 // Get.find<PrinterController>().checkSavedPrinter();
                },
              );
            }
          ),
        )


      ],
    );
  }
}

import 'package:admin_desktop/src/core/constants/constants.dart';
import 'package:admin_desktop/src/core/utils/app_helpers.dart';
import 'package:admin_desktop/src/core/utils/utils.dart';
import 'package:admin_desktop/src/models/data/addons_data.dart';
import 'package:admin_desktop/src/presentation/components/components.dart';
import 'package:admin_desktop/src/presentation/pages/main/riverpod/notifier/main_notifier.dart';
import 'package:admin_desktop/src/presentation/pages/main/riverpod/provider/main_provider.dart';
import 'package:admin_desktop/src/presentation/pages/main/riverpod/state/main_state.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/order_calculate/calculator_controller.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/order_calculate/payment_provider.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/order_calculate/price_info.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/right_side/riverpod/right_side_notifier.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/right_side/riverpod/right_side_state.dart';
import 'package:admin_desktop/src/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../models/data/order_body_data.dart';
import '../orders_table/orders/accepted/accepted_orders_provider.dart';
import '../orders_table/orders/new/new_orders_provider.dart';
import '../right_side/riverpod/right_side_provider.dart';
import 'package:flutter/material.dart';

///TODO: Order checkout pages (NayonCoders)
class OrderCalculate extends ConsumerWidget {
   OrderCalculate({super.key});

  @override
  Widget build(BuildContext context, ref) {
    Get.put(PaymentCalculatorController());
    final notifier = ref.read(mainProvider.notifier);
    final rightNotifier = ref.read(rightSideProvider.notifier);
    final state = ref.read(mainProvider);
    final stateRight = ref.watch(rightSideProvider);
    final selectedPayment = ref.watch(selectedPaymentProvider);
    return Scaffold(
      backgroundColor: AppStyle.mainBack,
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _informationWidget(notifier, rightNotifier, state, stateRight),
            16.horizontalSpace,
           calculator(stateRight, rightNotifier)
          ],
        ),
      ),
    );
  }

  Widget calculator(
      RightSideState stateRight, RightSideNotifier rightSideNotifier) {
    var totalPrice = stateRight.paginateResponse!.totalPrice! - stateRight.paginateResponse!.serviceFee!;
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(color: AppStyle.white),
        padding: EdgeInsets.symmetric(vertical: 23.r, horizontal: 14.r),
        child: Column(
          children: [
            SizedBox(
              child: Row(
                children: [
                  Obx(() {
                      return Visibility(
                        visible: Get.find<PaymentCalculatorController>().selectedPaymentOption.value == "Cash" || Get.find<PaymentCalculatorController>().selectedPaymentOption.value == "Split",
                        child: Container(
                          margin: EdgeInsets.only(right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("💵 Cash pay"),
                              SizedBox(height: 10,),
                              InkWell(
                                onTap: (){
                                  Get.find<PaymentCalculatorController>().changeSelectionBox(true);
                                },
                                child: Container(
                                  height: 50,
                                  width: 170,
                                  padding: EdgeInsets.only(left: 20.r, right: 20.r),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Get.find<PaymentCalculatorController>().isSelectCashBox.value ? Colors.red : AppStyle.differborder),
                                      borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Obx((){
                                        return Text(
                                          "${Get.find<PaymentCalculatorController>().cashAmountStr.value.toString().isEmpty ? "0.00" : double.parse("${Get.find<PaymentCalculatorController>().cashAmountStr.value.toString()}").toStringAsFixed(2)}",
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600, fontSize: 24.sp),
                                          maxLines: 1,
                                        );
                                      }
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  ),

                  Obx((){
                      return Visibility(
                        visible: Get.find<PaymentCalculatorController>().selectedPaymentOption.value == "Card" || Get.find<PaymentCalculatorController>().selectedPaymentOption.value == "Split",
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("💳 Card pay"),
                            SizedBox(height: 10,),
                            InkWell(
                              onTap: (){
                                Get.find<PaymentCalculatorController>().changeSelectionBox(false);
                              },
                              child: Container(
                                height: 50,
                                width: 170,
                                padding: EdgeInsets.only(left: 20.r, right: 20.r),
                                decoration: BoxDecoration(
                                    border: Border.all(color:  Get.find<PaymentCalculatorController>().isSelectCashBox.value ? AppStyle.differborder : Colors.red),
                                    borderRadius: BorderRadius.circular(8.r)),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Obx((){
                                      return Text(
                                        "${Get.find<PaymentCalculatorController>().cardAmountStr.value.toString().isEmpty? "0.00" : double.parse("${Get.find<PaymentCalculatorController>().cardAmountStr.value.toString()}").toStringAsFixed(2)}",
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600, fontSize: 24.sp),
                                        maxLines: 1,
                                      );
                                    }
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  )
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [


                const Spacer(),
                if (stateRight.selectedUser != null)
                  Row(
                    children: [
                      CommonImage(
                        imageUrl: stateRight.selectedUser?.img ?? "",
                        width: 50,
                        height: 50,
                        radius: 25,
                      ),
                      16.horizontalSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${stateRight.selectedUser?.firstname ?? ""} ${stateRight.selectedUser?.lastname ?? ""}",
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600, fontSize: 18.sp),
                          ),
                          Text(
                            "#${AppHelpers.getTranslation(TrKeys.id)}${stateRight.selectedUser?.id ?? ""}",
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                color: AppStyle.icon),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
            14.verticalSpace,
            const Divider(),
            const Spacer(),
            // Container(
            //   width: double.infinity,
            //   padding: EdgeInsets.all(20.r),
            //   decoration: BoxDecoration(
            //       border: Border.all(color: AppStyle.differborder),
            //       borderRadius: BorderRadius.circular(8.r)),
            //   child: Align(
            //     alignment: Alignment.centerRight,
            //     child: Text(
            //       stateRight.calculate,
            //       style: GoogleFonts.inter(
            //           fontWeight: FontWeight.w600, fontSize: 24.sp),
            //       maxLines: 1,
            //     ),
            //   ),
            // ),
            const Spacer(),
            GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 12, //aaa
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 28.w,
                  mainAxisSpacing: 24.h,
                  mainAxisExtent: 78.r,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Get.find<PaymentCalculatorController>().setCalculate(index == 9
                          ? "00"
                          : index == 10
                          ? "0"
                          : index == 11
                          ? "-1"
                          : (index + 1).toString(), double.tryParse("${totalPrice}")!);

                      Get.find<PaymentCalculatorController>().calculateBalance(double.tryParse("${totalPrice}")!); // Call after setting cash/card amount

                    },
                    child: AnimationButtonEffect(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppStyle.addButtonColor,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Center(
                          child: index == 11
                              ? const Icon(FlutterRemix.delete_back_2_line)
                              : Text(
                                  index == 9
                                      ? "00"
                                      : index == 10
                                          ? "0"
                                          : (index + 1).toString(),
                                  style: GoogleFonts.inter(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                        ),
                      ),
                    ),
                  );
                }),
            16.verticalSpace,
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      rightSideNotifier.setCalculate(".");
                      Get.find<PaymentCalculatorController>().setCalculate(".", totalPrice);
                    },
                    child: AnimationButtonEffect(
                      child: Container(
                        height: 78.r,
                        decoration: BoxDecoration(
                          color: AppStyle.addButtonColor,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Center(
                          child: Text(
                            ".",
                            style: GoogleFonts.inter(
                                fontSize: 24.sp, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                28.horizontalSpace,
                Expanded(
                  flex: 2,
                  child: AnimationButtonEffect(
                    child: Container(
                      height: 78.r,
                      decoration: BoxDecoration(
                        color: AppStyle.addButtonColor,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Center(
                        child: Text(
                          AppHelpers.getTranslation(TrKeys.ok),
                          style: GoogleFonts.inter(
                              fontSize: 24.sp, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _informationWidget(
      MainNotifier notifier,
      RightSideNotifier rightSideNotifier,
      MainState state,
      RightSideState stateRight) {

    return Expanded(
      child: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 16.r,
                right: 16.r,
                bottom: 80.r,  // Enough padding to avoid content under button
                top: 0,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.find<PaymentCalculatorController>().clearAll();
                          notifier.setPriceDate(null);
                        },
                        child: Row(
                          children: [
                            Icon(
                              FlutterRemix.arrow_left_s_line,
                              size: 32.r,
                            ),
                            SizedBox(width: 8.r),
                            Text(
                              AppHelpers.getTranslation(TrKeys.back),
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          rightSideNotifier.fetchCarts();
                        },
                        child: AnimationButtonEffect(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppStyle.white,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            padding: EdgeInsets.all(8.r),
                            child: const Icon(FlutterRemix.restart_line),
                          ),
                        ),
                      )
                    ],
                  ),
                  16.verticalSpace,

                  SizedBox(
                    height: 40,
                    child: PaymentSelector(),
                  ),
                  16.verticalSpace,

                  // Wrap the white background container here
                  Container(
                    width: double.infinity,
                    height:  Get.width - 200,
                    padding: EdgeInsets.symmetric(vertical: 20.r, horizontal: 16.r),
                    decoration: BoxDecoration(
                      color: AppStyle.white,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppHelpers.getTranslation(TrKeys.order),
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 22.sp,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${stateRight.bags[stateRight.selectedBagIndex].selectedUser?.firstname ?? ""} ${stateRight.bags[stateRight.selectedBagIndex].selectedUser?.lastname ?? ""}",
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                color: AppStyle.icon,
                              ),
                            ),
                            Text(
                              stateRight.orderType,
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                color: AppStyle.icon,
                              ),
                            ),
                          ],
                        ),
                        8.verticalSpace,
                        Divider(),
                        8.verticalSpace,
                        Text(
                          AppHelpers.getTranslation(TrKeys.totalItem),
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                          ),
                        ),
                        ListView.builder(
                          padding: EdgeInsets.only(top: 16.r),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                          stateRight.paginateResponse?.stocks?.length ?? 0,
                          itemBuilder: (context, index) {
                            final stock =
                            stateRight.paginateResponse?.stocks?[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 16.r),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        stock?.stock?.product?.translation?.title ?? "",
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.sp,
                                          color: AppStyle.black,
                                        ),
                                      ),
                                      for (Addons e in (stock?.addons ?? []))
                                        Text(
                                          "${e.product?.translation?.title ?? ""} ( ${AppHelpers.numberFormat((e.price ?? 0) / (e.quantity ?? 1))} x ${(e.quantity ?? 1)} )",
                                          style: GoogleFonts.inter(
                                            fontSize: 15.sp,
                                            color: AppStyle.unselectedTab,
                                          ),
                                        ),
                                    ],
                                  ),
                                  Text(
                                    AppHelpers.numberFormat(stock?.totalPrice ?? 0),
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                      color: AppStyle.black,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Divider(),
                        PriceInfo(
                          bag: stateRight.bags[stateRight.selectedBagIndex],
                          state: stateRight,
                          notifier: rightSideNotifier,
                          mainNotifier: notifier,
                          selectedPayment: Get.find<PaymentCalculatorController>()
                              .selectedPaymentOption
                              .value,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Fixed bottom button with full width and horizontal padding
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.white
              ),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppHelpers.getTranslation(TrKeys.totalPrice),
                        style: GoogleFonts.inter(
                          color: AppStyle.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.4,
                        ),
                      ),
                      Text(
                        AppHelpers.numberFormat(stateRight.paginateResponse!.totalPrice! - stateRight.paginateResponse!.serviceFee! ?? 0,
                            symbol: stateRight.bags[stateRight.selectedBagIndex].selectedCurrency?.symbol),
                        style: GoogleFonts.inter(
                          color: AppStyle.black,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ],
                  ),
                  20.verticalSpace,
                  Obx(() {
                    return Get.find<PaymentCalculatorController>().balanceAmount.isEmpty
                        ? const SizedBox.shrink()
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() => Text(
                          "${Get.find<PaymentCalculatorController>().balanceType.value}: ",
                          style: GoogleFonts.inter(
                            color: AppStyle.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.4,
                          ),
                        )),
                        Obx((){
                          return Text(
                            "\$ ${Get.find<PaymentCalculatorController>().balanceAmount.value}",
                            style: GoogleFonts.inter(
                              color: AppStyle.black,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.4,
                            ),
                          );
                        }
                        ),
                      ],
                    );
                  }
                  ),
                  SizedBox(height: 20),
                  Consumer(
                    builder: (BuildContext context, WidgetRef ref, Widget? child) {
                      return LoginButton(
                        isLoading: stateRight.isOrderLoading,
                        title: AppHelpers.getTranslation(TrKeys.confirmOrder),
                        onPressed: () {
                          rightSideNotifier.createOrder(
                            context,
                            OrderBodyData(
                              bagData: stateRight.bags[stateRight.selectedBagIndex],
                              coupon: stateRight.coupon,
                              phone: stateRight.selectedUser?.phone,
                              note: stateRight.comment,
                              userId: stateRight.selectedUser?.id,
                              deliveryFee: (stateRight.paginateResponse?.deliveryFee),
                              deliveryType: stateRight.orderType,
                              location: stateRight.selectedAddress?.location,
                              address: AddressModel(
                                address: stateRight.selectedAddress?.address,
                              ),
                              deliveryDate:
                              intl.DateFormat("yyyy-MM-dd").format(stateRight.orderDate ?? DateTime.now()),
                              deliveryTime: stateRight.orderTime != null
                                  ? (stateRight.orderTime!.hour.toString().length == 2
                                  ? "${stateRight.orderTime!.hour}:${stateRight.orderTime!.minute.toString().padLeft(2, '0')}"
                                  : "0${stateRight.orderTime!.hour}:${stateRight.orderTime!.minute.toString().padLeft(2, '0')}")
                                  : (TimeOfDay.now().hour.toString().length == 2
                                  ? "${TimeOfDay.now().hour}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}"
                                  : "0${TimeOfDay.now().hour}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}"),
                              currencyId: 2,
                              rate: stateRight.selectedCurrency?.rate ?? 0,
                              tableId: stateRight.selectedTable?.id,
                            ),
                            onSuccess: () {
                              ref.read(newOrdersProvider.notifier).fetchNewOrders(isRefresh: true);
                              ref.read(acceptedOrdersProvider.notifier).fetchAcceptedOrders(isRefresh: true);
                              AppHelpers.showAlertDialog(
                                context: context,
                                child: Container(
                                  width: 200.w,
                                  height: 200.w,
                                  padding: EdgeInsets.all(30.r),
                                  decoration: BoxDecoration(
                                    color: AppStyle.white,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: AppStyle.primary,
                                          shape: BoxShape.circle,
                                        ),
                                        padding: EdgeInsets.all(12.r),
                                        child: Icon(
                                          Icons.check,
                                          size: 56.r,
                                          color: AppStyle.white,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        AppHelpers.getTranslation(TrKeys.thankYouForOrder),
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22.r,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                              notifier.setPriceDate(null);
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

  }
}


class PaymentSelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List paymentOption = ["Cash", "Card", "Split"];

    final selectedOption = ref.watch(selectedPaymentProvider);

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: paymentOption.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Get.find<PaymentCalculatorController>().selectedPaymentMethod(paymentOption[index]);
          },
          child: Obx(() {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color:   Get.find<PaymentCalculatorController>().selectedPaymentOption.value == paymentOption[index] ? Colors.red : Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    paymentOption[index],
                    style: TextStyle(
                      fontSize: 16,
                      color:  Get.find<PaymentCalculatorController>().selectedPaymentOption.value == paymentOption[index] ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }
          ),
        );
      },
    );
  }
}

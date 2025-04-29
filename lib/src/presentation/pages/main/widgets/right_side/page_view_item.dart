import 'package:admin_desktop/src/core/utils/app_helpers.dart';
import 'package:admin_desktop/src/presentation/components/list_items/product_bag_item.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/right_side/note_dialog.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/right_side/order_information.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/right_side/riverpod/right_side_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:admin_desktop/generated/assets.dart';
import 'package:admin_desktop/src/core/constants/constants.dart';
import 'package:admin_desktop/src/core/utils/utils.dart';
import 'package:admin_desktop/src/models/models.dart';
import '../../../../components/components.dart';
import '../../../../theme/theme.dart';
import 'riverpod/right_side_provider.dart';

class PageViewItem extends ConsumerStatefulWidget {
  final BagData bag;

  const PageViewItem({super.key, required this.bag});

  @override
  ConsumerState<PageViewItem> createState() => _PageViewItemState();
}

class _PageViewItemState extends ConsumerState<PageViewItem> {
  late TextEditingController coupon;

  @override
  void initState() {
    super.initState();
    coupon = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref
          .read(rightSideProvider.notifier)
          .setInitialBagData(context, widget.bag);
    });
  }

  @override
  void dispose() {
    coupon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(rightSideProvider.notifier);
    final state = ref.watch(rightSideProvider);
    return AbsorbPointer(
      absorbing: state.isUserDetailsLoading ||
          state.isPaymentsLoading ||
          state.isBagsLoading ||
          state.isUsersLoading ||
          state.isCurrenciesLoading ||
          state.isProductCalculateLoading,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: AppStyle.white,
                  ),
                  child: (state.paginateResponse?.stocks?.isNotEmpty ?? false)
                      ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 8.r,
                          right: 24.r,
                          left: 24.r,
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppHelpers.getTranslation(TrKeys.products),
                              style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                            InkWell(
                              onTap: () {
                                notifier.clearBag();
                              },
                              child: Padding(
                                padding: EdgeInsets.all(8.r),
                                child: const Icon(
                                  FlutterRemix.delete_bin_line,
                                  color: AppStyle.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                        state.paginateResponse?.stocks?.length ?? 0,
                        itemBuilder: (context, index) {
                          return CartOrderItem(
                            symbol: widget.bag.selectedCurrency?.symbol,
                            add: () {
                              notifier.increaseProductCount(
                                  productIndex: index);
                            },
                            remove: () {
                              notifier.decreaseProductCount(
                                  productIndex: index);
                            },
                            cart:
                            state.paginateResponse?.stocks?[index] ??
                                ProductData(),
                            delete: () {
                              notifier.deleteProductCount(
                                  bagProductData: state
                                      .bags[state.selectedBagIndex]
                                      .bagProducts?[index],
                                  productIndex: index);
                            },
                          );
                        },
                      ),
                      8.verticalSpace,
                      Column(
                        children: [
                          Padding(
                            padding:
                            REdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Text(
                                  AppHelpers.getTranslation(TrKeys.add),
                                  style: GoogleFonts.inter(
                                      color: AppStyle.black,
                                      fontSize: 14.sp),
                                ),
                                const Spacer(),
                                // InkWell(
                                //   onTap: () {
                                //     AppHelpers.showAlertDialog(
                                //         context: context,
                                //         child: const PromoCodeDialog());
                                //   },
                                //   child: AnimationButtonEffect(
                                //     child: Container(
                                //       padding: EdgeInsets.symmetric(
                                //           vertical: 10.r,
                                //           horizontal: 18.r),
                                //       decoration: BoxDecoration(
                                //           color: AppStyle.addButtonColor,
                                //           borderRadius:
                                //               BorderRadius.circular(
                                //                   10.r)),
                                //       child: Text(
                                //         AppHelpers.getTranslation(
                                //             TrKeys.promoCode),
                                //         style: GoogleFonts.inter(
                                //             fontSize: 14.sp),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                26.horizontalSpace,
                                InkWell(
                                  onTap: () {
                                    AppHelpers.showAlertDialog(
                                        context: context,
                                        child: const NoteDialog());
                                  },
                                  child: AnimationButtonEffect(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.r,
                                          horizontal: 18.r),
                                      decoration: BoxDecoration(
                                          color: AppStyle.addButtonColor,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10.r)),
                                      child: Text(
                                        AppHelpers.getTranslation(
                                            TrKeys.note),
                                        style: GoogleFonts.inter(
                                            fontSize: 14.sp),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _price(state),
                        ],
                      ),
                      28.verticalSpace,
                    ],
                  )
                      : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      170.verticalSpace,
                      Container(
                        width: 142.r,
                        height: 142.r,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: AppStyle.dontHaveAccBtnBack,
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(
                          Assets.pngNoProducts,
                          width: 87.r,
                          height: 60.r,
                          fit: BoxFit.cover,
                        ),
                      ),
                      14.verticalSpace,
                      Text(
                        '${AppHelpers.getTranslation(TrKeys.thereAreNoItemsInThe)} ${AppHelpers.getTranslation(TrKeys.bag).toLowerCase()}',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -14 * 0.02,
                          color: AppStyle.black,
                        ),
                      ),
                      SizedBox(height: 170.r, width: double.infinity),
                    ],
                  ),
                ),
                15.verticalSpace,
              ],
            ),
          ),
          BlurLoadingWidget(
            isLoading: state.isUserDetailsLoading ||
                state.isPaymentsLoading ||
                state.isBagsLoading ||
                state.isUsersLoading ||
                state.isCurrenciesLoading ||
                state.isProductCalculateLoading,
          ),
        ],
      ),
    );
  }

  Column _price(RightSideState state) {
    return Column(
      children: [
        8.verticalSpace,
        const Divider(),
        8.verticalSpace,
        Padding(
          padding: REdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _priceItem(
                title: TrKeys.subtotal,
                price: state.paginateResponse?.price,
                symbol: widget.bag.selectedCurrency?.symbol,
              ),
              _priceItem(
                title: TrKeys.tax,
                price: state.paginateResponse?.totalTax,
                symbol: widget.bag.selectedCurrency?.symbol,
              ),
              _priceItem(
                title: TrKeys.serviceFee,
                price: state.paginateResponse?.serviceFee,
                symbol: widget.bag.selectedCurrency?.symbol,
              ),
              _priceItem(
                title: TrKeys.deliveryFee,
                price: state.paginateResponse?.deliveryFee,
                symbol: widget.bag.selectedCurrency?.symbol,
              ),
              _priceItem(
                title: TrKeys.discount,
                price: state.paginateResponse?.totalDiscount,
                symbol: widget.bag.selectedCurrency?.symbol,
                isDiscount: true,
              ),
              _priceItem(
                title: TrKeys.promoCode,
                price: state.paginateResponse?.couponPrice,
                symbol: widget.bag.selectedCurrency?.symbol,
                isDiscount: true,
              ),
            ],
          ),
        ),
        8.verticalSpace,
        const Divider(),
        8.verticalSpace,
        Padding(
          padding: REdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppHelpers.getTranslation(TrKeys.totalPrice),
                    style: GoogleFonts.inter(
                      color: AppStyle.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.4,
                    ),
                  ),
                  Text(
                    AppHelpers.numberFormat(state.paginateResponse?.totalPrice,
                      symbol: widget.bag.selectedCurrency?.symbol ,
                    ),
                    style: GoogleFonts.inter(
                      color: AppStyle.black,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
              24.verticalSpace,
              LoginButton(
                isLoading: state.isButtonLoading,
                title: AppHelpers.getTranslation(TrKeys.order),
                titleColor: AppStyle.black,
                onPressed: () {
                  AppHelpers.showAlertDialog(
                    context: context,
                    child: OrderInformation(),
                  );
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  _priceItem({
    required String title,
    required num? price,
    required String? symbol,
    bool isDiscount = false,
  }) {
    return (price ?? 0) != 0
        ? Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppHelpers.getTranslation(title),
              style: GoogleFonts.inter(
                color: isDiscount ? AppStyle.red : AppStyle.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.4,
              ),
            ),
            Text(
              (isDiscount ? "-" : '') +
                  AppHelpers.numberFormat(price, symbol: symbol),
              style: GoogleFonts.inter(
                color: isDiscount ? AppStyle.red : AppStyle.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
        12.verticalSpace,
      ],
    )
        : const SizedBox.shrink();
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:admin_desktop/src/core/constants/constants.dart';
import 'package:admin_desktop/src/core/utils/utils.dart';
import 'package:admin_desktop/src/models/models.dart';
import '../../../../components/components.dart';
import '../../../../theme/theme.dart';
import '../right_side/riverpod/right_side_provider.dart';
import 'provider/add_product_provider.dart';
import 'widgets/extras/color_extras.dart';
import 'widgets/extras/image_extras.dart';
import 'widgets/extras/text_extras.dart';
import 'widgets/w_ingredient.dart';

class AddProductDialog extends ConsumerStatefulWidget {
  final ProductData? product;

  const AddProductDialog({super.key, required this.product});

  @override
  ConsumerState<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends ConsumerState<AddProductDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(addProductProvider.notifier).setProduct(
        widget.product,
        ref.watch(rightSideProvider).selectedBagIndex,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addProductProvider);
    final rightSideState = ref.watch(rightSideProvider);
    final notifier = ref.read(addProductProvider.notifier);
    final rightSideNotifier = ref.read(rightSideProvider.notifier);
    final List<Stocks> stocks = state.product?.stocks ?? <Stocks>[];
    if (stocks.isEmpty) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: AppStyle.white,
          ),
          constraints: BoxConstraints(
            maxHeight: 700.r,
            maxWidth: 600.r,
          ),
          padding: REdgeInsets.symmetric(horizontal: 40, vertical: 50),
          child: Text(
            '${state.product?.translation?.title} ${AppHelpers.getTranslation(TrKeys.outOfStock).toLowerCase()}',
          ),
        ),
      );
    }
    final bool hasDiscount = (state.selectedStock?.discount != null &&
        (state.selectedStock?.discount ?? 0) > 0);
    final String price = AppHelpers.numberFormat(hasDiscount
        ? (state.selectedStock?.totalPrice ?? 0)
        : state.selectedStock?.price,
    );
    final lineThroughPrice = AppHelpers.numberFormat(
        state.selectedStock?.price,
    );
    print(" MediaQuery.of(context).size.height / 1.6 -- ${ MediaQuery.of(context).size.height / 1.6}");
    print(" MediaQuery.of(context).size.height / 1.6 -- ${ MediaQuery.of(context).size.width / 1.6}");
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: AppStyle.white,
        ),
        constraints: BoxConstraints(
          maxHeight:  550.0,
          maxWidth: 800.0,
        ),
        padding: REdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            20.verticalSpace,
            Expanded(child: ListView(
              children: [
                Row(
                  children: [
                    const SizedBox.shrink(),
                    const Spacer(),
                    CircleIconButton(
                      size: 90,
                      backgroundColor: AppStyle.transparent,
                      iconData: FlutterRemix.close_circle_line,
                      icon: AppStyle.black,
                      onTap: ()=> Navigator.pop(context),
                    ),
                  ],
                ),
                6.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.product?.addons != null ?  CommonImage(
                          isRedious: false,
                          imageUrl: widget.product?.img,
                          width: 250,
                          height: 250,
                        ) :  CommonImage(
                          isRedious: true,
                          imageUrl: widget.product?.img,
                          width: 150,
                          height: 100,
                        ),

                      ],
                    ),
                    32.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.product?.translation?.title}',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 22.sp,
                              color: AppStyle.black,
                              letterSpacing: -0.4,
                            ),
                          ),
                          8.verticalSpace,
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.6 - 370.w,
                            child: Text(
                              '${widget.product?.translation?.description}',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.sp,
                                color: AppStyle.icon,
                                letterSpacing: -0.4,
                              ),
                            ),
                          ),
                          8.verticalSpace,
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.6 - 370.w,
                            child: Divider(
                              color: AppStyle.black.withOpacity(0.2),
                            ),
                          ),
                          ListView.builder(
                            physics: const CustomBouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.typedExtras.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final TypedExtra typedExtra =
                              state.typedExtras[index];
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: AppStyle.white,
                                ),
                                padding: REdgeInsets.symmetric(vertical: 6),
                                margin: REdgeInsets.only(bottom: 6),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      typedExtra.title,
                                      style: GoogleFonts.inter(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppStyle.black,
                                        letterSpacing: -0.4,
                                      ),
                                    ),
                                    8.verticalSpace,
                                    typedExtra.type == ExtrasType.text
                                        ? SizedBox(
                                      width: MediaQuery.of(context).size.width / 1.6 - 370.w,
                                      child: TextExtras(
                                        uiExtras: typedExtra.uiExtras,
                                        groupIndex: typedExtra.groupIndex,
                                        onUpdate: (s) {
                                          notifier.updateSelectedIndexes(
                                            index: typedExtra.groupIndex,
                                            value: s.index,
                                            bagIndex: rightSideState
                                                .selectedBagIndex,
                                          );
                                        },
                                      ),
                                    )
                                        : typedExtra.type == ExtrasType.color
                                        ? ColorExtras(
                                      uiExtras: typedExtra.uiExtras,
                                      groupIndex: typedExtra.groupIndex,
                                    )
                                        : typedExtra.type == ExtrasType.image
                                        ? ImageExtras(
                                      uiExtras: typedExtra.uiExtras,
                                      groupIndex:
                                      typedExtra.groupIndex,
                                    )
                                        : const SizedBox(),
                                    8.verticalSpace,
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.6 -
                                          370.w,
                                      child: Divider(
                                        color: AppStyle.black.withOpacity(0.2),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          8.verticalSpace,
                          SizedBox(
                            //width: 200,
                            width: MediaQuery.of(context).size.width / 2 - 370.w,
                            child: WIngredientScreen(
                              list: state.selectedStock?.addons ?? [],
                              onChange: (int value) {
                                notifier.updateIngredient(context, value);
                              },
                              add: (int value) {
                                notifier.addIngredient(context, value);
                              },
                              remove: (int value) {
                                notifier.removeIngredient(context, value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                24.verticalSpace,
                // Align(
                //   alignment: Alignment.topLeft,
                //   child: Container(
                //     width:200.r,
                //     height: 80.r,
                //     padding: EdgeInsets.symmetric(horizontal: 2),
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(6.r),
                //         border: Border.all(color: AppStyle.icon)),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         InkWell(
                //           onTap: () => notifier.decreaseStockCount(
                //               rightSideState.selectedBagIndex),
                //           child: Container(
                //               padding: EdgeInsets.all(15),
                //               child: Icon(FlutterRemix.subtract_line, size: 40,)),
                //         ),
                //         2.horizontalSpace,
                //         Text(
                //           '${state.stockCount}',
                //           style: GoogleFonts.inter(
                //             fontWeight: FontWeight.w700,
                //             fontSize: 18.sp,
                //             color: AppStyle.black,
                //             letterSpacing: -0.4,
                //           ),
                //         ),
                //         2.horizontalSpace,
                //         InkWell(
                //           onTap: () => notifier.increaseStockCount(
                //               rightSideState.selectedBagIndex),
                //           child: Container(
                //             padding: EdgeInsets.all(15),
                //               child: Icon(FlutterRemix.add_line,  size: 40)),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // 10.verticalSpace,
                const Divider(),
                10.verticalSpace,
              ],
            )),
            20.verticalSpace,
            Row(
              children: [
                Container(
                  width: 180,
                  height: 80,
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(color: AppStyle.icon)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => notifier.decreaseStockCount(
                            rightSideState.selectedBagIndex),
                        child: Container(
                            padding: EdgeInsets.all(15),
                            child: Icon(FlutterRemix.subtract_line, size: 40,)),
                      ),
                      2.horizontalSpace,
                      Text(
                        '${state.stockCount}',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 18.sp,
                          color: AppStyle.black,
                          letterSpacing: -0.4,
                        ),
                      ),
                      2.horizontalSpace,
                      InkWell(
                        onTap: () => notifier.increaseStockCount(
                            rightSideState.selectedBagIndex),
                        child: Container(
                            padding: EdgeInsets.all(15),
                            child: Icon(FlutterRemix.add_line,  size: 40)),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 30,),
                SizedBox(
                  width: 200.w,
                  height: 100.h,
                  child: LoginButton(
                    isLoading: state.isLoading,
                    title: AppHelpers.getTranslation(TrKeys.add),
                    onPressed: () {

                      notifier.addProductToBag(
                        context,
                        rightSideState.selectedBagIndex,
                        rightSideNotifier,
                      );

                      Navigator.pop(context);
                    },
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${AppHelpers.getTranslation(TrKeys.price)}:',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppStyle.black,
                        letterSpacing: -14 * 0.02,
                      ),
                    ),
                    4.verticalSpace,
                    Row(
                      children: [
                        if (hasDiscount)
                          Row(
                            children: [
                              Text(
                                lineThroughPrice,
                                style: GoogleFonts.inter(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 38.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppStyle.discountText,
                                  letterSpacing: -14 * 0.02,
                                ),
                              ),
                              10.horizontalSpace,
                            ],
                          ),
                        Text(
                          price,
                          style: GoogleFonts.inter(
                            fontSize: 38.sp,
                            fontWeight: FontWeight.w600,
                            color: AppStyle.black,
                            letterSpacing: -14 * 0.02,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            20.verticalSpace,

          ],
        ),
      ),
    );
  }
}

import 'package:admin_desktop/src/presentation/pages/main/getx_controller/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_desktop/src/core/constants/constants.dart';
import 'package:admin_desktop/src/core/utils/utils.dart';
import 'package:admin_desktop/src/models/models.dart';
import '../../pages/main/getx_controller/bag_controller.dart';
import '../components.dart';
import '../../theme/theme.dart';

class ProductGridItem extends StatelessWidget {
  final ProductData product;
  final Function() onTap;

  const ProductGridItem({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final bool isOutOfStock = product.stocks == null || product.stocks!.isEmpty;
    final bool hasDiscount = isOutOfStock
        ? false
        : (product.stocks?[0].discount != null &&
            (product.stocks?[0].discount ?? 0) > 0);
    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      onTap: onTap,
      child: Obx(() {
        return  Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: AppStyle.white,
          ),
          constraints: BoxConstraints(
            maxWidth: 227.r,
            maxHeight: Get.find<MainController>().isShowImage.value ? 246.r : 150.r,
          ),

          child: Stack(
            children: [
              Padding(
                padding: REdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      return Get.find<MainController>().isShowImage.value ?  Expanded(
                        child: CommonImage(
                          imageUrl: product.img,
                        ),
                      )  : Center();
                    }
                    ),
                    16.verticalSpace,
                    Text(
                      '${product.translation?.title}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -14 * 0.02,
                        color: AppStyle.black,
                      ),
                    ),
                    6.verticalSpace,
                    Text(
                      isOutOfStock
                          ? AppHelpers.getTranslation(TrKeys.outOfStock)
                          : '${AppHelpers.getTranslation(TrKeys.inStock)} - ${product.stocks?[0].quantity}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -14 * 0.02,
                        color: isOutOfStock ? AppStyle.red : AppStyle.inStockText,
                      ),
                    ),
                    8.verticalSpace,
                    Row(
                      children: [
                        if (hasDiscount)
                          Row(
                            children: [
                              Text(
                                AppHelpers.numberFormat(
                                    (product.stocks?.first.discount ?? 0) +
                                        (product.stocks?.first.totalPrice ?? 0)),
                                style: GoogleFonts.inter(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppStyle.discountText,
                                  letterSpacing: -14 * 0.02,
                                ),
                              ),
                              10.horizontalSpace,
                            ],
                          ),
                        Text(
                          AppHelpers.numberFormat(isOutOfStock
                              ? 0
                              : (product.stocks?.first.totalPrice ?? 0)),
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppStyle.black,
                            letterSpacing: -14 * 0.02,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Visibility(
                visible:  Get.find<MainController>().isShowImage.value &&  Get.find<BagController>().products.value.any((value) => value["id"] == product.stocks?.first.id.toString()),
                child: Positioned(
                  bottom: 0, right: 0,
                  child:Stack(
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: 227.r,
                          maxHeight: Get.find<MainController>().isShowImage.value ? 246.r : 150.r,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                            colors: [
                              AppStyle.green,
                              Colors.transparent,
                            ],
                            stops: [0.0, 0.4],
                          ),
                        ),
                        // your other container content here...
                      ),

                      // Positioned badge for quantity
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 4.r),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),

                          ),
                          child: Obx(() {
                              return Text(
                                '${Get.find<BagController>().getQtyById(product.stocks!.first.id!.toString())}', // Replace with your quantity value dynamically
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.r,
                                ),
                              );
                            }
                          ),
                        ),
                      ),
                    ],
                  )
                ),
              )
            ],
          ),
        );
          // return Stack(
          //   children: [
          //     Container(
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10.r),
          //         color: AppStyle.white,
          //       ),
          //       constraints: BoxConstraints(
          //         maxWidth: 227.r,
          //         maxHeight: Get.find<MainController>().isShowImage.value ? 246.r : 150.r,
          //       ),
          //       padding: REdgeInsets.all(10),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Obx(() {
          //               return Get.find<MainController>().isShowImage.value ?  Expanded(
          //                 child: CommonImage(
          //                   imageUrl: product.img,
          //                 ),
          //               )  : Center();
          //             }
          //           ),
          //           16.verticalSpace,
          //           Text(
          //             '${product.translation?.title}',
          //             maxLines: 1,
          //             overflow: TextOverflow.ellipsis,
          //             style: GoogleFonts.inter(
          //               fontSize: 14.sp,
          //               fontWeight: FontWeight.w400,
          //               letterSpacing: -14 * 0.02,
          //               color: AppStyle.black,
          //             ),
          //           ),
          //           6.verticalSpace,
          //           Text(
          //             isOutOfStock
          //                 ? AppHelpers.getTranslation(TrKeys.outOfStock)
          //                 : '${AppHelpers.getTranslation(TrKeys.inStock)} - ${product.stocks?[0].quantity}',
          //             maxLines: 2,
          //             overflow: TextOverflow.ellipsis,
          //             style: GoogleFonts.inter(
          //               fontSize: 12.sp,
          //               fontWeight: FontWeight.w500,
          //               letterSpacing: -14 * 0.02,
          //               color: isOutOfStock ? AppStyle.red : AppStyle.inStockText,
          //             ),
          //           ),
          //           8.verticalSpace,
          //           Row(
          //             children: [
          //               if (hasDiscount)
          //                 Row(
          //                   children: [
          //                     Text(
          //                       AppHelpers.numberFormat(
          //                           (product.stocks?.first.discount ?? 0) +
          //                               (product.stocks?.first.totalPrice ?? 0)),
          //                       style: GoogleFonts.inter(
          //                         decoration: TextDecoration.lineThrough,
          //                         fontSize: 16.sp,
          //                         fontWeight: FontWeight.w600,
          //                         color: AppStyle.discountText,
          //                         letterSpacing: -14 * 0.02,
          //                       ),
          //                     ),
          //                     10.horizontalSpace,
          //                   ],
          //                 ),
          //               Text(
          //                 AppHelpers.numberFormat(isOutOfStock
          //                     ? 0
          //                     : (product.stocks?.first.totalPrice ?? 0)),
          //                 style: GoogleFonts.inter(
          //                   fontSize: 16.sp,
          //                   fontWeight: FontWeight.w600,
          //                   color: AppStyle.black,
          //                   letterSpacing: -14 * 0.02,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),
          //     ),
          //     Visibility(
          //       visible:  Get.find<MainController>().isShowImage.value,
          //       child: Positioned(
          //         bottom: 0, right: 0,
          //         child: Container(
          //           //width: 227.r,
          //           constraints: BoxConstraints(
          //             maxWidth: 227.r,
          //             maxHeight: Get.find<MainController>().isShowImage.value ? 246.r : 150.r,
          //           ),
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(10.r),
          //             gradient: LinearGradient(
          //               begin: Alignment.bottomRight,
          //               end: Alignment.topLeft,
          //               colors: [
          //                 Colors.green.withOpacity(0.4),
          //                 Colors.transparent,
          //               ],
          //               stops: [0.0, 0.7],
          //             ),
          //           ),
          //         ),
          //       ),
          //     )
          //   ],
          // );
        }
      ),
    );
  }
}

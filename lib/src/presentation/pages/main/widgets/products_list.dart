import 'package:admin_desktop/generated/assets.dart';
import 'package:admin_desktop/src/presentation/pages/main/getx_controller/bag_controller.dart';
import 'package:admin_desktop/src/presentation/pages/main/getx_controller/main_controller.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/add_product/add_product_dialog.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/right_side/riverpod/right_side_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:admin_desktop/src/core/constants/constants.dart';
import 'package:admin_desktop/src/core/utils/utils.dart';
import '../../../../models/data/product_data.dart';
import '../../../components/components.dart';
import '../../../components/list_items/product_list_item.dart';
import '../../../theme/theme.dart';
import '../riverpod/provider/main_provider.dart';
import 'add_product/provider/add_product_provider.dart';

///TODO: NayonCoders (Changes: product list time 32 items show)
class ProductsList extends ConsumerWidget {
   ProductsList({super.key});

  MainController mainController = Get.find<MainController>();
  BagController bagController = Get.find<BagController>();



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bagController.updateProductsFromBags();
    final state = ref.watch(mainProvider);
    final notifier = ref.read(mainProvider.notifier);

    final addProductState = ref.watch(addProductProvider);
    final rightSideState = ref.watch(rightSideProvider);
    final addProductNotifier = ref.read(addProductProvider.notifier);
    final rightSideNotifier = ref.read(rightSideProvider.notifier);




    return state.isProductsLoading
        ? const ProductGridListShimmer()
        : state.products.isNotEmpty
            ? ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                }),
                child: ListView(
                  shrinkWrap: false,
                  cacheExtent: (state.products.length / 4) * 250,
                  children: [

                    ///TODO:: need to change the product show as grid or list
                    AnimationLimiter(
                      child: Obx(() => mainController.isGridView.value ?  gridView(state, addProductNotifier) : listView(state, addProductNotifier)),
                    ),


                    10.verticalSpace,
                    state.isMoreProductsLoading
                        ? const ProductGridListShimmer(verticalPadding: 0)
                        : (state.hasMore
                            ? Material(
                                borderRadius: BorderRadius.circular(10.r),
                                color: AppStyle.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10.r),
                                  onTap: () {
                                    notifier.fetchProducts(
                                      checkYourNetwork: () {
                                        AppHelpers.showSnackBar(
                                          context,
                                          AppHelpers.getTranslation(TrKeys
                                              .checkYourNetworkConnection),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: 50.r,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(
                                        color:
                                            AppStyle.black.withOpacity(0.17),
                                        width: 1.r,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      AppHelpers.getTranslation(
                                          TrKeys.viewMore),
                                      style: GoogleFonts.inter(
                                        fontSize: 16.sp,
                                        color: AppStyle.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox()),
                    15.verticalSpace,
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.only(left: 64.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    170.verticalSpace,
                    Container(
                      width: 142.r,
                      height: 142.r,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: AppStyle.white,
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
                      '${AppHelpers.getTranslation(TrKeys.thereAreNoItemsInThe)} ${AppHelpers.getTranslation(TrKeys.products).toLowerCase()}',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -14 * 0.02,
                        color: AppStyle.black,
                      ),
                    ),
                  ],
                ),
              );
  }


  Widget gridView(state, addProductNotifier){
    return  GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      primary: false,
      itemCount: state.products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: Get.find<MainController>().isShowImage.value ? (200 / 300) : (200 / 150),
        mainAxisSpacing: 10.r,
        crossAxisSpacing: 10.r,
        crossAxisCount: 4,
      ),
      padding: REdgeInsets.only(top: 8, bottom: 10),
      itemBuilder: (context, index) {
        ProductData singleProduct = state.products[index];
        return AnimationConfiguration.staggeredGrid(
          columnCount: state.products.length,
          position: index,
          duration: const Duration(milliseconds: 375),
          child: ScaleAnimation(
            scale: 0.5,
            child: FadeInAnimation(
              child: ProductGridItem(
                product: singleProduct,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) { ///TODO:: Add Product Nayon coder
                      return AddProductDialog(
                        // product: product
                          product: singleProduct
                      );
                    },
                  );

                },
              ),
            ),
          ),
        );
      },
    );
  }


   Widget listView(state, addProductNotifier){
     return  ListView.builder(
       physics: const NeverScrollableScrollPhysics(),
       shrinkWrap: true,
       primary: false,
       padding: REdgeInsets.only(top: 8, bottom: 10),
       itemCount: (state.products.length / 2).ceil(),
       itemBuilder: (context, index) {
         final firstProduct = state.products[index * 2];
         final secondIndex = index * 2 + 1;
         final secondProduct = secondIndex < state.products.length ? state.products[secondIndex] : null;

         return AnimationConfiguration.staggeredList(
           position: index,
           duration: const Duration(milliseconds: 375),
           child: ScaleAnimation(
             scale: 0.5,
             child: FadeInAnimation(
               child: Row(
                 children: [
                   Expanded(
                     child: ProductListItemView(
                       product: firstProduct,
                       onTap: () {
                         showDialog(
                           context: context,
                           builder: (context) {
                             return AddProductDialog(product: firstProduct);
                           },
                         );
                       },
                     ),
                   ),
                   SizedBox(width: 10.w), // spacing between two products
                   if (secondProduct != null)
                     Expanded(
                       child: ProductListItemView(
                         product: secondProduct,
                         onTap: () {
                           showDialog(
                             context: context,
                             builder: (context) {
                               return AddProductDialog(product: secondProduct);
                             },
                           );
                         },
                       ),
                     )
                   else
                     const Expanded(child: SizedBox()), // empty space if odd number
                 ],
               ),
             ),
           ),
         );
       },
     );
   }
}

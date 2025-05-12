import 'package:admin_desktop/generated/assets.dart';
import 'package:admin_desktop/src/presentation/components/category_tab_bar_item.dart';
import 'package:admin_desktop/src/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:admin_desktop/src/core/constants/constants.dart';
import 'package:admin_desktop/src/core/utils/utils.dart';
import '../riverpod/provider/main_provider.dart';

class MainAppbar extends ConsumerWidget {
  const MainAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(mainProvider.notifier);
    final state = ref.watch(mainProvider);
    print("state.categories --- ${state.categories.length}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        state.categories.isEmpty
            ? const SizedBox.shrink()
           // ? Text("this is empty")
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: AppStyle.white,
                      borderRadius: BorderRadius.circular(10.r)
                    ),
                    height: 56.h,
                    child: ListView.builder( ///TODO: category view
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: state.categories.length + 2,
                        itemBuilder: (context, index) {
                          return index == 0
                              ? Padding(
                                  padding: EdgeInsets.only(right: 6.r),
                                  child:
                                      SvgPicture.asset(Assets.svgMenu),
                                )
                              : index == 1
                                  ? CategoryTabBarItem(
                                      isActive:
                                          state.selectedCategory?.id == null,
                                      onTap: () {
                                        notifier.setSelectedCategory(
                                            context, -1);
                                      },
                                      title:
                                          AppHelpers.getTranslation(TrKeys.all),
                                    )
                                  : CategoryTabBarItem(
                                      isActive:
                                          state.categories[index - 2].id ==
                                              state.selectedCategory?.id,
                                      onTap: () {
                                        notifier.setSelectedCategory(
                                            context, index - 2);
                                      },
                                      title: state.categories[index - 2]
                                          .translation?.title,
                                    );
                        }),
                  )
                ],
              )
      ],
    );
  }
}

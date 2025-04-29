import 'package:admin_desktop/src/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';


class LineShimmer extends StatelessWidget {
  final bool? isActiveLine;
  const LineShimmer({super.key, this.isActiveLine});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        enabled: false,
        baseColor: AppStyle.arrowRight,
        highlightColor: AppStyle.icon,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  8.verticalSpace,
                  Container(
                    height: 56.r,
                    width: 56.r,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: AppStyle.icon),
                  ),
                  6.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 6.h,
                            width: 100.w,
                            color: AppStyle.icon,
                          ),
                          15.horizontalSpace,
                        ],
                      ),
                      6.verticalSpace,
                      Container(
                        height: 6.h,
                        width: 300.w,
                        color: AppStyle.icon,
                      ),
                      8.verticalSpace,
                      isActiveLine ?? false
                          ? Container(
                              height: 6.h,
                              width: 50.w,
                              color: AppStyle.icon,
                            )
                          : const SizedBox.shrink()
                    ],
                  ),
                ],
              ),
            );
          },
        ));
  }
}

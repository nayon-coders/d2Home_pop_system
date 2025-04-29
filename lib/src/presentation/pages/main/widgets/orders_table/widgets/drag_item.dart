import 'package:admin_desktop/generated/assets.dart';
import 'package:admin_desktop/src/models/data/order_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:admin_desktop/src/core/constants/constants.dart';
import 'package:admin_desktop/src/core/utils/app_helpers.dart';
import '../../../../../components/components.dart';
import '../../../../../theme/theme.dart';
import '../../../riverpod/provider/main_provider.dart';
import '../icon_title.dart';
import 'custom_popup_item.dart';

class DragItem extends ConsumerWidget {
  final OrderData orderData;
  final bool isDrag;

  const DragItem({super.key, required this.orderData, this.isDrag = false});

  @override
  Widget build(BuildContext context, ref) {
    return InkWell(
      child: Transform.rotate(
        angle: isDrag ? (3.14 * (0.03)) : 0,
        child: Container(
          foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isDrag ? AppStyle.icon.withOpacity(0.3) : null),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16), color: AppStyle.white),
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonImage(
                    imageUrl: orderData.user?.img,
                    height: 42,
                    width: 42,
                    radius: 32,
                    isResponsive: false,
                  ),
                  6.horizontalSpace,
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            orderData.user?.firstname ?? "",
                            maxLines: 1,
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppStyle.black,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "#${orderData.id}",
                            style: GoogleFonts.inter(
                                fontSize: 14, color: AppStyle.hint),
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomPopup(
                    orderData: orderData,
                    isLocation: orderData.deliveryType == TrKeys.delivery,
                  ),
                ],
              ),
              6.verticalSpace,
              const Divider(height: 2),
              12.verticalSpace,
              IconTitle(
                title: AppHelpers.getTranslation(TrKeys.date),
                icon: FlutterRemix.calendar_2_line,
                value: DateFormat("MMMM dd HH:mm")
                    .format(orderData.createdAt?.toLocal() ?? DateTime.now()),
              ),
              IconTitle(
                title: AppHelpers.getTranslation(TrKeys.amount),
                icon: FlutterRemix.money_dollar_circle_line,
                value: AppHelpers.numberFormat(
                  orderData.totalPrice ?? 0,
                  symbol: orderData.currency?.symbol,
                ),
              ),
              IconTitle(
                title: AppHelpers.getTranslation(TrKeys.paymentType),
                icon: FlutterRemix.money_euro_circle_line,
                value: orderData.transaction?.paymentSystem?.tag ?? "- -",
              ),
              if (orderData.deliveryman?.firstname?.isNotEmpty ?? false)
                IconTitle(
                  title: AppHelpers.getTranslation(TrKeys.deliveryman),
                  icon: FlutterRemix.car_line,
                  value: orderData.deliveryman?.firstname ?? "- -",
                ),
              if (orderData.table?.name?.isNotEmpty ?? false)
                IconTitle(
                  title: AppHelpers.getTranslation(TrKeys.table),
                  icon: Icons.table_restaurant_outlined,
                  value: orderData.table?.name ?? "- -",
                ),
              (orderData.orderAddress?.address?.isNotEmpty ?? false)
                  ? IconTitle(
                      title: AppHelpers.getTranslation(TrKeys.address),
                      icon: FlutterRemix.map_pin_2_line,
                      value: orderData.orderAddress?.address ?? "- -",
                    )
                  : const SizedBox.shrink(),
              (orderData.transaction?.status?.isNotEmpty ?? false)
                  ? IconTitle(
                      title: AppHelpers.getTranslation(TrKeys.paymentStatus),
                      icon: FlutterRemix.money_dollar_circle_line,
                      value: orderData.transaction?.status ?? "- -",
                    )
                  : const SizedBox.shrink(),
              12.verticalSpace,
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppStyle.border),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Text(
                            AppHelpers.getTranslation(
                                orderData.deliveryType ?? ""),
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppStyle.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(4),
                        height: 28,
                        width: 28,
                        decoration: BoxDecoration(
                            border: Border.all(color: AppStyle.black),
                            shape: BoxShape.circle),
                        child: (orderData.deliveryType ?? "") == TrKeys.dine
                            ? Padding(
                                padding: const EdgeInsets.all(4),
                                child: SvgPicture.asset(Assets.svgDine))
                            : Icon(
                                (orderData.deliveryType ?? "") ==
                                        TrKeys.delivery
                                    ? FlutterRemix.e_bike_2_fill
                                    : FlutterRemix.walk_line,
                                size: 16,
                              ),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
      onTap: () {
        ref.read(mainProvider.notifier).setOrder(orderData);
      },
    );
  }
}

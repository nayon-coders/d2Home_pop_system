part of 'list_view.dart';

class ListItem extends ConsumerWidget {
  final OrderData orderData;
  final Color color;
  final VoidCallback onSelect;
  final bool isSelect;

  const ListItem({
    super.key,
    required this.orderData,
    required this.color,
    required this.onSelect,
    required this.isSelect,
  });

  @override
  Widget build(BuildContext context, ref) {
    return Column(
      children: [
        InkWell(
          onTap: () => ref.read(mainProvider.notifier).setOrder(orderData),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            color: isSelect ? AppStyle.mainBack : AppStyle.white,
            padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 18.r),
            child: Row(
              children: [
                CustomCheckbox(isActive: isSelect, onTap: onSelect),
                8.horizontalSpace,
                SizedBox(
                  width: 56.w,
                  child: Text(
                    orderData.id.toString(),
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      color: AppStyle.brandTitleDivider,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                8.horizontalSpace,
                SizedBox(
                  width: 120.w,
                  child: Text(
                    orderData.user?.firstname ?? "--",
                    maxLines: 1,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      color: AppStyle.brandTitleDivider,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                8.horizontalSpace,
                SizedBox(
                  width: 120.w,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.r, vertical: 4.r),
                        decoration: BoxDecoration(
                            color: color.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(100.r)),
                        child: Text(
                          AppHelpers.getTranslation(orderData.status ?? "--"),
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            color: color,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                8.horizontalSpace,
                SizedBox(
                  width: 120.w,
                  child: Text(
                    orderData.deliveryman?.firstname ?? "--",
                    maxLines: 1,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      color: AppStyle.brandTitleDivider,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                8.horizontalSpace,
                SizedBox(
                  width: 96.w,
                  child: Text(
                    AppHelpers.numberFormat(
                      orderData.totalPrice ?? 0,
                      symbol: orderData.currency?.symbol,
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      color: AppStyle.brandTitleDivider,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                8.horizontalSpace,
                SizedBox(
                  width: 180.w,
                  child: Text(
                    DateFormat("MMMM dd, HH:mm").format(
                        orderData.createdAt?.toLocal() ?? DateTime.now()),
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      color: AppStyle.brandTitleDivider,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                8.horizontalSpace,
                SizedBox(
                  width: 180.w,
                  child: Text(
                    "${DateFormat("MMMM dd").format(orderData.deliveryDate ?? DateTime.now())} - ${orderData.deliveryTime ?? ""}",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      color: AppStyle.brandTitleDivider,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Spacer(),
                CustomPopup(
                  isLocation: orderData.deliveryType == TrKeys.delivery,
                  orderData: orderData,
                ),
              ],
            ),
          ),
        ),
        Divider(height: 2.r),
      ],
    );
  }
}

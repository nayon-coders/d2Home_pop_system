import 'package:admin_desktop/src/core/utils/utils.dart';
import 'package:admin_desktop/src/models/response/sale_history_response.dart';
import 'package:admin_desktop/src/presentation/components/buttons/animation_button_effect.dart';
import 'package:admin_desktop/src/presentation/pages/printer_manage/controller/printer_controller.dart';
import 'package:admin_desktop/src/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:admin_desktop/src/core/constants/constants.dart';

import '../../../printer_manage/view/show_options.dart';
///TODO: sales
class SaleTab extends StatelessWidget {
  final List<SaleHistoryModel> list;
  final bool isLoading;
  final bool isMoreLoading;
  final bool hasMore;
  final VoidCallback viewMore;

  const SaleTab(
      {super.key,
      required this.list,
      required this.isLoading,
      required this.hasMore,
      required this.viewMore,
      required this.isMoreLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 22.r),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r), color: AppStyle.white),
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: AppStyle.black,
            ))
          : SingleChildScrollView(
              child: Column(
                children: [
                  Table(
                    columnWidths: {
                      0:FixedColumnWidth(112.w),
                      1:FixedColumnWidth(260.w),
                      2:FixedColumnWidth(120.w),
                      3:FixedColumnWidth(132.w),
                      4:FixedColumnWidth(200.w),
                      5:FixedColumnWidth(200.w),
                      //6:FixedColumnWidth(100.w),
                    },
                    // defaultColumnWidth: FixedColumnWidth(
                    //     (MediaQuery.of(context).size.height) / 4.6.r),
                    border: TableBorder.all(color: AppStyle.transparent),
                    children: [
                      TableRow(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 16.r),
                                child: Text(
                                  AppHelpers.getTranslation(TrKeys.id),
                                  style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    color: AppStyle.black,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppHelpers.getTranslation(TrKeys.client),
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  color: AppStyle.black,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.3,
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppHelpers.getTranslation(TrKeys.amount),
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  color: AppStyle.black,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.3,
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppHelpers.getTranslation(TrKeys.paymentType),
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  color: AppStyle.black,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.3,
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppHelpers.getTranslation(TrKeys.note),
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  color: AppStyle.black,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.3,
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppHelpers.getTranslation(TrKeys.date),
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  color: AppStyle.black,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.3,
                                ),
                              )
                            ],
                          ),

                          //print invoice
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                               "Print Invoice",
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  color: AppStyle.black,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.3,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      for (int i = 0; i < list.length; i++)
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(),
                                  Padding(
                                    padding: EdgeInsets.only(left: 16.r),
                                    child: Text(
                                      "#${AppHelpers.getTranslation(TrKeys.id)}${list[i].id}",
                                      style: GoogleFonts.inter(
                                        fontSize: 14.sp,
                                        color: AppStyle.icon,
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(),
                                  Text(
                                    "${list[i].user?.firstname ?? ""} ${list[i].user?.lastname ?? ""}",
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      color: AppStyle.icon,
                                      letterSpacing: -0.3,
                                    ),
                                    maxLines: 2
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(),
                                  Text(
                                    AppHelpers.numberFormat(list[i].totalPrice),
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      color: AppStyle.icon,
                                      letterSpacing: -0.3,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: REdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(),
                                  Text(
                                    (list[i].transactions?.isNotEmpty ?? false)
                                        ? AppHelpers.getTranslation(list[i]
                                                .transactions
                                                ?.first
                                                .paymentSystem
                                                ?.tag ??
                                            "")
                                        : AppHelpers.getTranslation(TrKeys.na),
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      color: AppStyle.icon,
                                      letterSpacing: -0.3,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: REdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(),
                                  Text(
                                    list[i].note ??
                                        AppHelpers.getTranslation(TrKeys.na),
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      color: AppStyle.icon,
                                      letterSpacing: -0.3,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(),
                                  Text(
                                    DateFormat('d MMM yyyy HH:mm').format(
                                        list[i].createdAt ?? DateTime.now()),
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      color: AppStyle.icon,
                                      letterSpacing: -0.3,
                                    ),
                                  )
                                ],
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(),
                                  InkWell(
                                    onTap: (){
                                      // Inside any button or action:
                                      showPrinterPopup(context,  list[i]);

                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Center(
                                        child: Icon(Icons.print, color: Colors.black, size: 25,),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  isMoreLoading
                      ? const Padding(
                          padding: EdgeInsets.only(top: 18),
                          child: Center(
                              child: CircularProgressIndicator(
                            color: AppStyle.black,
                          )),
                        )
                      : hasMore
                          ? InkWell(
                              borderRadius: BorderRadius.circular(10.r),
                              onTap: () {
                                viewMore.call();
                              },
                              child: AnimationButtonEffect(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 64.r, vertical: 16.r),
                                  height: 50.r,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                      color: AppStyle.black.withOpacity(0.17),
                                      width: 1.r,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    AppHelpers.getTranslation(TrKeys.viewMore),
                                    style: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      color: AppStyle.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink()
                ],
              ),
            ),
    );
  }



}

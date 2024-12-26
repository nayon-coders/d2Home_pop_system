// ignore_for_file: must_be_immutable

import 'package:admin_desktop/src/core/constants/constants.dart';
import 'package:admin_desktop/src/core/utils/app_helpers.dart';
import 'package:admin_desktop/src/core/utils/app_validators.dart';
import 'package:admin_desktop/src/core/utils/local_storage.dart';
import 'package:admin_desktop/src/models/data/bag_data.dart';
import 'package:admin_desktop/src/presentation/components/components.dart';

import 'package:admin_desktop/src/presentation/pages/main/riverpod/provider/main_provider.dart';
import 'package:admin_desktop/src/presentation/theme/theme.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'address/select_address_page.dart';
import 'riverpod/right_side_provider.dart';
import 'riverpod/right_side_state.dart';

class OrderInformation extends ConsumerWidget {
  OrderInformation({super.key});

  List listOfType = [
    TrKeys.delivery,
    TrKeys.pickup,
    TrKeys.dine,
  ];

  List listDine = [TrKeys.dine];

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, ref) {
    final notifier = ref.read(rightSideProvider.notifier);
    final state = ref.watch(rightSideProvider);
    final BagData bag = state.bags[state.selectedBagIndex];
    return KeyboardDismisser(
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        padding: REdgeInsets.symmetric(horizontal: 24.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: AppStyle.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    AppHelpers.getTranslation(TrKeys.order),
                    style: GoogleFonts.inter(
                        fontSize: 22.r, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: context.maybePop,
                      icon: const Icon(FlutterRemix.close_line))
                ],
              ),
              16.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state.orderType == TrKeys.delivery)
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: AppStyle.unselectedBottomBarBack,
                                    width: 1.r,
                                  ),
                                ),
                                alignment: Alignment.center,
                                height: 56.r,
                                padding: EdgeInsets.only(left: 16.r),
                                child: CustomDropdown(
                                  hintText: AppHelpers.getTranslation(
                                      TrKeys.selectUser),
                                  searchHintText: AppHelpers.getTranslation(
                                      TrKeys.searchUser),
                                  dropDownType: DropDownType.users,
                                  onChanged: (value) =>
                                      notifier.setUsersQuery(context, value),
                                  initialValue:
                                      bag.selectedUser?.firstname ?? '',
                                ),
                              ),
                              Visibility(
                                visible: state.selectUserError != null,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 6.r, left: 4.r),
                                  child: Text(
                                    AppHelpers.getTranslation(
                                        state.selectUserError ?? ""),
                                    style: GoogleFonts.inter(
                                        color: AppStyle.red, fontSize: 14.sp),
                                  ),
                                ),
                              ),
                              24.verticalSpace,
                            ],
                          ),
                        if (state.orderType == TrKeys.dine)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: AppStyle.unselectedBottomBarBack,
                                    width: 1.r,
                                  ),
                                ),
                                alignment: Alignment.center,
                                height: 56.r,
                                padding: EdgeInsets.only(left: 16.r),
                                child: CustomDropdown(
                                  hintText: AppHelpers.getTranslation(
                                      TrKeys.selectSection),
                                  searchHintText:
                                      AppHelpers.getTranslation(TrKeys.search),
                                  dropDownType: DropDownType.section,
                                  onChanged: (value) =>
                                      notifier.setSectionQuery(context, value),
                                  initialValue:
                                      bag.selectedSection?.translation?.title ??
                                          '',
                                ),
                              ),
                              Visibility(
                                visible: state.selectSectionError != null,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 6.r, left: 4.r),
                                  child: Text(
                                    AppHelpers.getTranslation(
                                        state.selectSectionError ?? ""),
                                    style: GoogleFonts.inter(
                                        color: AppStyle.red, fontSize: 14.sp),
                                  ),
                                ),
                              ),
                              24.verticalSpace,
                            ],
                          ),
                        PopupMenuButton<int>(
                          itemBuilder: (context) {
                            return state.currencies
                                .map(
                                  (currency) => PopupMenuItem<int>(
                                    value: currency.id,
                                    child: Text(
                                      '${currency.title}(${currency.symbol})',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp,
                                        color: AppStyle.black,
                                        letterSpacing: -14 * 0.02,
                                      ),
                                    ),
                                  ),
                                )
                                .toList();
                          },
                          onSelected: notifier.setSelectedCurrency,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          color: AppStyle.white,
                          elevation: 10,
                          child: SelectFromButton(
                            title: state.selectedCurrency?.title ??
                                AppHelpers.getTranslation(
                                    TrKeys.selectCurrency),
                          ),
                        ),
                        Visibility(
                          visible: state.selectCurrencyError != null,
                          child: Padding(
                            padding: EdgeInsets.only(top: 6.r, left: 4.r),
                            child: Text(
                              AppHelpers.getTranslation(
                                  state.selectCurrencyError ?? ""),
                              style: GoogleFonts.inter(
                                  color: AppStyle.red, fontSize: 14.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  16.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state.orderType == TrKeys.delivery)
                          Column(
                            children: [
                              PopupMenuButton(
                                initialValue:
                                    state.selectedAddress?.address ?? "",
                                itemBuilder: (context) {
                                  AppHelpers.showAlertDialog(
                                      context: context,
                                      child: SizedBox(
                                        child: SelectAddressPage(
                                          location:
                                              state.selectedAddress?.location,
                                          onSelect: (address) {
                                            notifier.setSelectedAddress(
                                                address: address);
                                            ref
                                                .read(
                                                    rightSideProvider.notifier)
                                                .fetchCarts(
                                                    checkYourNetwork: () {
                                                      AppHelpers.showSnackBar(
                                                        context,
                                                        AppHelpers.getTranslation(
                                                            TrKeys
                                                                .checkYourNetworkConnection),
                                                      );
                                                    },
                                                    isNotLoading: true);
                                          },
                                        ),
                                      ));

                                  return [];
                                },
                                onSelected: (s) =>
                                    notifier.setSelectedAddress(),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                color: AppStyle.white,
                                elevation: 10,
                                child: SelectFromButton(
                                  title: state.selectedAddress?.address ??
                                      AppHelpers.getTranslation(
                                          TrKeys.selectAddress),
                                ),
                              ),
                              Visibility(
                                visible: state.selectAddressError != null,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 6.r, left: 4.r),
                                  child: Text(
                                    AppHelpers.getTranslation(
                                        state.selectAddressError ?? ""),
                                    style: GoogleFonts.inter(
                                        color: AppStyle.red, fontSize: 14.sp),
                                  ),
                                ),
                              ),
                              24.verticalSpace,
                            ],
                          ),
                        if (state.orderType == TrKeys.dine)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: AppStyle.unselectedBottomBarBack,
                                    width: 1.r,
                                  ),
                                ),
                                alignment: Alignment.center,
                                height: 56.r,
                                padding: EdgeInsets.only(left: 16.r),
                                child: CustomDropdown(
                                  hintText: AppHelpers.getTranslation(
                                      TrKeys.selectTable),
                                  searchHintText:
                                      AppHelpers.getTranslation(TrKeys.search),
                                  dropDownType: DropDownType.table,
                                  onChanged: (value) =>
                                      notifier.setTableQuery(context, value),
                                  initialValue: bag.selectedTable?.name ?? '',
                                ),
                              ),
                              Visibility(
                                visible: state.selectTableError != null,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 6.r, left: 4.r),
                                  child: Text(
                                    AppHelpers.getTranslation(
                                        state.selectTableError ?? ""),
                                    style: GoogleFonts.inter(
                                        color: AppStyle.red, fontSize: 14.sp),
                                  ),
                                ),
                              ),
                              24.verticalSpace,
                            ],
                          ),
                        PopupMenuButton<int>(
                          enabled: state.orderType == TrKeys.delivery,
                          itemBuilder: (context) {
                            return state.payments
                                .map(
                                  (payment) => PopupMenuItem<int>(
                                    value: payment.id,
                                    child: Text(
                                      AppHelpers.getTranslation(
                                          payment.tag ?? ""),
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp,
                                        color: AppStyle.black,
                                        letterSpacing: -14 * 0.02,
                                      ),
                                    ),
                                  ),
                                )
                                .toList();
                          },
                          onSelected: notifier.setSelectedPayment,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          color: AppStyle.white,
                          elevation: 10,
                          child: SelectFromButton(
                            title: AppHelpers.getTranslation(
                                state.selectedPayment?.tag ??
                                    TrKeys.selectPayment),
                          ),
                        ),
                        Visibility(
                          visible: state.selectPaymentError != null,
                          child: Padding(
                            padding: EdgeInsets.only(top: 6.r, left: 4.r),
                            child: Text(
                              AppHelpers.getTranslation(
                                  state.selectPaymentError ?? ""),
                              style: GoogleFonts.inter(
                                  color: AppStyle.red, fontSize: 14.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              16.verticalSpace,
              if (AppHelpers.isNumberRequiredToOrder() &&
                  state.selectedUser != null &&
                  (state.selectedUser?.phone?.isEmpty ?? true))
                Form(
                  key: formKey,
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          inputType: TextInputType.phone,
                          validator: (value) {
                            return AppValidators.emptyCheck(value);
                          },
                          onChanged: (p0) {
                            notifier.setPhone(p0);
                          },
                          label: AppHelpers.getTranslation(TrKeys.phoneNumber),
                        ),
                      ),
                    ],
                  ),
                ),
              12.verticalSpace,
              const Divider(),
              12.verticalSpace,
              Text(
                AppHelpers.getTranslation(TrKeys.shippingInformation),
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600, fontSize: 22.r),
              ),
              16.verticalSpace,
              Row(
                children: [
                  ...(LocalStorage.getUser()?.role == TrKeys.waiter
                          ? listDine
                          : listOfType)
                      .map((e) => Expanded(
                            child: InkWell(
                              onTap: () {
                                notifier.setSelectedOrderType(e);
                                if (state.orderType.toLowerCase() !=
                                    e.toString().toLowerCase()) {
                                  ref
                                      .read(rightSideProvider.notifier)
                                      .fetchCarts(
                                          checkYourNetwork: () {
                                            AppHelpers.showSnackBar(
                                              context,
                                              AppHelpers.getTranslation(TrKeys
                                                  .checkYourNetworkConnection),
                                            );
                                          },
                                          isNotLoading: true);
                                }
                              },
                              child: AnimationButtonEffect(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4.r),
                                  decoration: BoxDecoration(
                                    color: state.orderType.toLowerCase() ==
                                            e.toString().toLowerCase()
                                        ? AppStyle.primary
                                        : AppStyle.editProfileCircle,
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 10.r),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppStyle.transparent,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: AppStyle.black),
                                          ),
                                          padding: EdgeInsets.all(6.r),
                                          child: e == TrKeys.delivery
                                              ? Icon(
                                                  FlutterRemix.takeaway_fill,
                                                  size: 18.sp,
                                                )
                                              : e == TrKeys.pickup
                                                  ? SvgPicture.asset(
                                                      "assets/svg/pickup.svg")
                                                  : SvgPicture.asset(
                                                      "assets/svg/dine.svg"),
                                        ),
                                        8.horizontalSpace,
                                        Text(
                                          AppHelpers.getTranslation(e),
                                          style: GoogleFonts.inter(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
                ],
              ),
              12.verticalSpace,
              if (state.orderType == TrKeys.delivery)
                Row(
                  children: [
                    Expanded(
                      child: PopupMenuButton<int>(
                        itemBuilder: (context) {
                          showDatePicker(
                            context: context,
                            initialDate: state.orderDate ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 1000),
                            ),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: AppStyle.primary,
                                    onPrimary: AppStyle.black,
                                    onSurface: AppStyle.black,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppStyle.black,
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          ).then((date) {
                            if (date != null) {
                              notifier.setDate(date);
                            }
                          });
                          return [];
                        },
                        onSelected: (s) {},
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        color: AppStyle.white,
                        elevation: 10,
                        child: SelectFromButton(
                          title: state.orderDate == null
                              ? AppHelpers.getTranslation(
                                  TrKeys.selectDeliveryDate)
                              : DateFormat("MMM dd")
                                  .format(state.orderDate ?? DateTime.now()),
                        ),
                      ),
                    ),
                    16.horizontalSpace,
                    Expanded(
                      child: PopupMenuButton<int>(
                        itemBuilder: (context) {
                          showTimePicker(
                            context: context,
                            initialTime: state.orderTime ?? TimeOfDay.now(),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: AppStyle.primary,
                                    onPrimary: AppStyle.black,
                                    onSurface: AppStyle.black,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppStyle.black,
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          ).then((time) {
                            if (time != null) {
                              notifier.setTime(time);
                            }
                          });
                          return [];
                        },
                        onSelected: (s) {},
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        color: AppStyle.white,
                        elevation: 10,
                        child: SelectFromButton(
                          title: state.orderTime == null
                              ? AppHelpers.getTranslation(
                                  TrKeys.selectDeliveryTime)
                              : "${state.orderTime?.format(context)}",
                        ),
                      ),
                    ),
                  ],
                ),
              if (state.orderType == TrKeys.delivery) 24.verticalSpace,
              const Divider(),
              24.verticalSpace,
              _priceInformation(state: state, bag: bag, context: context),
              20.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 186.w,
                    child: LoginButton(
                        title: AppHelpers.getTranslation(TrKeys.placeOrder),
                        onPressed: () {
                          if (AppHelpers.isNumberRequiredToOrder() &&
                              state.selectedUser?.phone == null &&
                              state.selectedUser != null) {
                            if (!(formKey.currentState?.validate() ?? false)) {
                              return;
                            }
                          }
                          notifier.placeOrder(
                            checkYourNetwork: () {
                              AppHelpers.showSnackBar(
                                context,
                                AppHelpers.getTranslation(
                                    TrKeys.checkYourNetworkConnection),
                              );
                            },
                            openSelectDeliveriesDrawer: () {
                              ref
                                  .read(mainProvider.notifier)
                                  .setPriceDate(state.paginateResponse);
                              context.maybePop();
                            },
                          );
                        }),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppHelpers.getTranslation(TrKeys.totalPrice),
                        style: GoogleFonts.inter(
                          color: AppStyle.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.4,
                        ),
                      ),
                      Text(
                        AppHelpers.numberFormat(
                          state.paginateResponse?.totalPrice,
                          symbol: bag.selectedCurrency?.symbol,
                        ),
                        style: GoogleFonts.inter(
                          color: AppStyle.black,
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priceInformation(
      {required RightSideState state,
      required BagData bag,
      required BuildContext context}) {
    return Column(
      children: [
        _priceItem(
          title: TrKeys.subtotal,
          price: state.paginateResponse?.price,
          symbol: bag.selectedCurrency?.symbol,
        ),
        _priceItem(
          title: TrKeys.tax,
          price: state.paginateResponse?.totalTax,
          symbol: bag.selectedCurrency?.symbol,
        ),
        _priceItem(
          title: TrKeys.serviceFee,
          price: state.paginateResponse?.serviceFee,
          symbol: bag.selectedCurrency?.symbol,
        ),
        _priceItem(
          title: TrKeys.deliveryFee,
          price: state.paginateResponse?.deliveryFee,
          symbol: bag.selectedCurrency?.symbol,
        ),
        _priceItem(
          title: TrKeys.discount,
          price: state.paginateResponse?.totalDiscount,
          symbol: bag.selectedCurrency?.symbol,
          isDiscount: true,
        ),
        _priceItem(
          title: TrKeys.promoCode,
          price: state.paginateResponse?.couponPrice,
          symbol: bag.selectedCurrency?.symbol,
          isDiscount: true,
        ),
        const Divider(),
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

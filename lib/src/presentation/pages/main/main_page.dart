// ignore_for_file: deprecated_member_use
import 'dart:async';

import 'package:admin_desktop/src/core/routes/app_router.dart';
import 'package:admin_desktop/src/presentation/components/custom_clock/custom_clock.dart';
import 'package:admin_desktop/src/presentation/components/custom_scaffold.dart';
import 'package:admin_desktop/src/presentation/pages/main/riverpod/notifier/main_notifier.dart';
import 'package:admin_desktop/src/presentation/pages/main/riverpod/state/main_state.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/customers/customers_page.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/customers/riverpod/notifier/customer_notifier.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/customers/riverpod/provider/customer_provider.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/kitchen/kitchen_page.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/kitchen/riverpod/kitchen_provider.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/language/languages_modal.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/language/riverpod/provider/languages_provider.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/notifications/components/notification_count_container.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/notifications/notification_dialog.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/orders_table/orders/canceled/canceled_orders_provider.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/orders_table/orders/cooking/cooking_orders_provider.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/orders_table/orders/delivered/delivered_orders_provider.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/notifications/riverpod/notification_provider.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/post_page.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/tables/tables_page.dart';
import 'package:admin_desktop/src/presentation/theme/theme/theme_warpper.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proste_indexed_stack/proste_indexed_stack.dart';
import '../../../../generated/assets.dart';
import 'package:admin_desktop/src/core/constants/constants.dart';
import 'package:admin_desktop/src/core/utils/utils.dart';
import '../../components/components.dart';
import '../../theme/theme.dart';
import 'riverpod/provider/main_provider.dart';
import 'widgets/income/income_page.dart';
import 'widgets/orders_table/orders/accepted/accepted_orders_provider.dart';
import 'widgets/orders_table/orders/new/new_orders_provider.dart';
import 'widgets/orders_table/orders/on_a_way/on_a_way_orders_provider.dart';
import 'widgets/orders_table/orders/ready/ready_orders_provider.dart';
import 'widgets/orders_table/orders_table.dart';
import 'widgets/profile/edit_profile/edit_profile_page.dart';
import 'widgets/right_side/riverpod/right_side_provider.dart';
import 'widgets/sale_history/sale_history.dart';

@RoutePage()
class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage>
    with SingleTickerProviderStateMixin {
  final user = LocalStorage.getUser();

  late List<IndexedStackChild> list = [
    IndexedStackChild(child: const PostPage(), preload: true),
    IndexedStackChild(child: const OrdersTablesPage()),
    IndexedStackChild(child: const CustomersPage()),
    IndexedStackChild(child: const TablesPage()),
    IndexedStackChild(child: const SaleHistory()),
    IndexedStackChild(child: const InComePage()),
    IndexedStackChild(child: const ProfilePage()),
  ];

  late List<IndexedStackChild> listKitchen = [
    IndexedStackChild(child: const KitchenPage(), preload: true),
    IndexedStackChild(child: const ProfilePage()),
  ];

  late List<IndexedStackChild> listWaiter = [
    IndexedStackChild(child: const PostPage(), preload: true),
    IndexedStackChild(child: const OrdersTablesPage()),
    IndexedStackChild(child: const TablesPage()),
    IndexedStackChild(child: const ProfilePage()),
  ];
  Timer? timer;
  int time = 0;
  final player = AudioPlayer();

  Future playMusic() async {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      await player.play(AssetSource("audio/notification.wav"));
    });
  }

  notif() async {
    await FirebaseMessaging.instance.requestPermission(
      sound: true,
      alert: true,
      badge: false,
    );

    // FirebaseMessaging.onBackgroundMessage(
    //   (message) async {
    //     print('3new notif ${message.data}');
    //   },
    // );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (AppConstants.playMusicOnOrderStatusChange) {
        player.play(AssetSource("audio/notification.wav"));
      }
      if(mounted) {
        AppHelpers.showSnackBar(
        context,
        "${AppHelpers.getTranslation(TrKeys.id)} #${message.notification?.title} ${message.notification?.body}",
      );
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    notif();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (user?.role == TrKeys.seller) {
        ref.read(mainProvider.notifier)
          ..fetchProducts(
            checkYourNetwork: () {
              AppHelpers.showSnackBar(
                context,
                AppHelpers.getTranslation(TrKeys.checkYourNetworkConnection),
              );
            },
          )
          ..fetchCategories(
            context: context,
            checkYourNetwork: () {
              AppHelpers.showSnackBar(
                context,
                AppHelpers.getTranslation(TrKeys.checkYourNetworkConnection),
              );
            },
          )
          ..fetchUserDetail(context)
          ..changeIndex(0);
        ref.read(rightSideProvider.notifier)
          ..fetchUsers(
            checkYourNetwork: () {
              AppHelpers.showSnackBar(
                context,
                AppHelpers.getTranslation(TrKeys.checkYourNetworkConnection),
              );
            },
          )
          ..fetchSections();
      } else if (user?.role == TrKeys.cooker) {
        ref.read(mainProvider.notifier)
          ..fetchUserDetail(context)
          ..changeIndex(0);
      } else {
        ref.read(mainProvider.notifier)
          ..fetchProducts(
            checkYourNetwork: () {
              AppHelpers.showSnackBar(
                context,
                AppHelpers.getTranslation(TrKeys.checkYourNetworkConnection),
              );
            },
          )
          ..fetchCategories(
            context: context,
            checkYourNetwork: () {
              AppHelpers.showSnackBar(
                context,
                AppHelpers.getTranslation(TrKeys.checkYourNetworkConnection),
              );
            },
          )
          ..fetchUserDetail(context)
          ..changeIndex(0);
      }

      if (mounted) {
        Timer.periodic(
          AppConstants.refreshTime,
          (s) {
            ref.read(notificationProvider.notifier).fetchCount(context);
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mainProvider);
    final customerNotifier = ref.read(customerProvider.notifier);
    final notifier = ref.read(mainProvider.notifier);
    if (AppConstants.keepPlayingOnNewOrder) {
      ref.listen(newOrdersProvider, (previous, next) async {
        if (next.orders.isEmpty) {
          await player.stop();
          timer?.cancel();
        }

        if (time != 0 && next.orders.isNotEmpty) {
          await playMusic();
        }
        time++;
      });
    }
    return SafeArea(
      child: CustomScaffold(
        extendBody: true,
        appBar: (colors) => customAppBar(notifier, customerNotifier),
        backgroundColor: AppStyle.mainBack,
        body: (c) => Directionality(
          textDirection:
              LocalStorage.getLangLtr() ? TextDirection.ltr : TextDirection.rtl,
          child: KeyboardDismisser(
              child: Row(
            children: [
              user?.role == TrKeys.seller
                  ? bottomLeftNavigationBar(state)
                  : user?.role == TrKeys.cooker
                      ? bottomLeftNavigationBarKitchen(state)
                      : bottomLeftNavigationBarWaiter(state),
              Expanded(
                child: ProsteIndexedStack(
                  index: state.selectIndex,
                  children: user?.role == TrKeys.seller
                      ? list
                      : user?.role == TrKeys.cooker
                          ? listKitchen
                          : listWaiter,
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }

  AppBar customAppBar(
      MainNotifier notifier, CustomerNotifier customerNotifier) {
    return AppBar(
      backgroundColor: AppStyle.white,
      automaticallyImplyLeading: false,
      elevation: 0.5,
      title: IntrinsicHeight(
        child: ThemeWrapper(builder: (colors, controller) {
          return Row(
            children: [
              // 16.horizontalSpace,
              // SvgPicture.asset(Assets.svgLogo,height: 40,
              //   width: 40,),
              12.horizontalSpace,
              Text(
                "D2home POS",
                // AppHelpers.getAppName() ?? "",
                style: GoogleFonts.inter(
                    color: AppStyle.black, fontWeight: FontWeight.bold),
              ),
              const VerticalDivider(),
              30.horizontalSpace,
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      FlutterRemix.search_2_line,
                      size: 20.r,
                      color: AppStyle.black,
                    ),
                    17.horizontalSpace,
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        onChanged: (value) {
                          if (user?.role == TrKeys.seller) {
                            ref.watch(mainProvider).selectIndex == 2
                                ? customerNotifier.searchUsers(
                                    context, value.trim())
                                : notifier.setProductsQuery(
                                    context, value.trim());
                            if (ref.watch(mainProvider).selectIndex == 1) {
                              ref
                                  .read(newOrdersProvider.notifier)
                                  .setOrdersQuery(context, value.trim());
                              ref
                                  .read(acceptedOrdersProvider.notifier)
                                  .setOrdersQuery(context, value.trim());
                              ref
                                  .read(readyOrdersProvider.notifier)
                                  .setOrdersQuery(context, value.trim());
                              ref
                                  .read(onAWayOrdersProvider.notifier)
                                  .setOrdersQuery(context, value.trim());
                              ref
                                  .read(deliveredOrdersProvider.notifier)
                                  .setOrdersQuery(context, value.trim());
                              ref
                                  .read(canceledOrdersProvider.notifier)
                                  .setOrdersQuery(context, value.trim());
                            }
                          } else if (user?.role == TrKeys.cooker) {
                            ref
                                .read(kitchenProvider.notifier)
                                .setOrdersQuery(context, value.trim());
                          } else {
                            if (ref.watch(mainProvider).selectIndex == 1) {
                              ref
                                  .read(newOrdersProvider.notifier)
                                  .setOrdersQuery(context, value.trim());
                              ref
                                  .read(acceptedOrdersProvider.notifier)
                                  .setOrdersQuery(context, value.trim());
                              ref
                                  .read(readyOrdersProvider.notifier)
                                  .setOrdersQuery(context, value.trim());
                              ref
                                  .read(onAWayOrdersProvider.notifier)
                                  .setOrdersQuery(context, value.trim());
                              ref
                                  .read(deliveredOrdersProvider.notifier)
                                  .setOrdersQuery(context, value.trim());
                              ref
                                  .read(canceledOrdersProvider.notifier)
                                  .setOrdersQuery(context, value.trim());
                            }
                            notifier.setProductsQuery(context, value.trim());
                          }
                        },
                        cursorColor: AppStyle.black,
                        cursorWidth: 1.r,
                        decoration: InputDecoration.collapsed(
                          hintText: ref.watch(mainProvider).selectIndex == 1
                              ? AppHelpers.getTranslation(TrKeys.searchOrders)
                              : ref.watch(mainProvider).selectIndex == 2 &&
                                      user?.role != TrKeys.waiter
                                  ? AppHelpers.getTranslation(
                                      TrKeys.searchCustomers)
                                  : AppHelpers.getTranslation(
                                      TrKeys.searchProducts),
                          hintStyle: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 18.sp,
                            color: AppStyle.searchHint.withOpacity(0.3),
                            letterSpacing: -14 * 0.02,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(),
              SizedBox(width: 120.w, child: const CustomClock()),
              const VerticalDivider(),
              IconButton(
                  onPressed: () async {
                    context.pushRoute(const HelpRoute());
                    // await launch(
                    //   "${SecretVars.webUrl}/help",
                    //   forceSafariVC: true,
                    //   forceWebView: true,
                    //   enableJavaScript: true,
                    // );
                  },
                  icon: const Icon(
                    FlutterRemix.question_line,
                    color: AppStyle.black,
                  )),
              // IconButton(
              //     onPressed: () {},
              //     icon: const Icon(
              //       FlutterRemix.settings_5_line,
              //       color: AppStyle.black,
              //     )),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) => const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Dialog(child: NotificationDialog()),
                              ],
                            ));
                  },
                  icon: const Icon(
                    FlutterRemix.notification_2_line,
                    color: AppStyle.black,
                  )),
              NotificationCountsContainer(
                  count:
                      '${ref.watch(notificationProvider).countOfNotifications?.notification ?? 0}'),
              IconButton(
                onPressed: () {
                  ref.read(languagesProvider.notifier).getLanguages(context);
                  showDialog(
                      context: context,
                      builder: (_) => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Consumer(
                                builder: (context, ref, child) => Dialog(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    width: MediaQuery.sizeOf(context).width / 4,
                                    constraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.sizeOf(context).height *
                                                0.9),
                                    child: Expanded(
                                      child: LanguagesModal(
                                        afterUpdate: () {
                                          controller.toggle();
                                          controller.toggle();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ));
                },
                icon: const Icon(
                  FlutterRemix.global_line,
                  color: AppStyle.black,
                ),
              ),
              // IconButton(
              //   onPressed: () {
              //     showDialog(
              //         context: context,
              //         builder: (_) =>
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.end,
              //               children: [
              //                 Dialog(
              //                   child: SizedBox(
              //                     height:
              //                     MediaQuery
              //                         .sizeOf(context)
              //                         .height / 1.2,
              //                     width: MediaQuery
              //                         .sizeOf(context)
              //                         .width / 4,
              //                     child: Column(
              //                       children: [
              //                         Padding(
              //                           padding: REdgeInsets.only(
              //                               left: 15, right: 15, top: 15),
              //                           child: Row(
              //                             children: [
              //                               Text(
              //                                 AppHelpers.getTranslation(
              //                                     TrKeys.menu),
              //                                 style: GoogleFonts.inter(
              //                                     fontWeight: FontWeight
              //                                         .w600,
              //                                     fontSize: 22,
              //                                     color: AppStyle.black),
              //                               ),
              //                               const Spacer(),
              //                               IconButton(
              //                                   onPressed: () {
              //                                     Navigator.pop(context);
              //                                   },
              //                                   icon: const Icon(
              //                                       FlutterRemix
              //                                           .close_fill))
              //                             ],
              //                           ),
              //                         ),
              //                         const Expanded(child: MenuModal()),
              //                       ],
              //                     ),
              //                   ),
              //                 ),
              //               ],
              //             ));
              //   },
              //   icon: const Icon(
              //     FlutterRemix.menu_2_line,
              //     color: AppStyle.black,
              //   ),
              // ),
            ],
          );
        }),
      ),
    );
  }

  Container bottomLeftNavigationBar(MainState state) {
    return Container(
      height: double.infinity,
      width: 90.w,
      color: AppStyle.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          24.verticalSpace,
          Container(
            decoration: BoxDecoration(
                color: state.selectIndex == 0
                    ? AppStyle.primary
                    : AppStyle.transparent,
                borderRadius: BorderRadius.circular(10.r)),
            child: IconButton(
                onPressed: () {
                  ref.read(mainProvider.notifier).changeIndex(0);
                },
                icon:SvgPicture.asset(
                  state.selectIndex == 3
                      ? Assets.svgposmachine
                      : Assets.svgposmachine,
                ),
            ),
          ),
          28.verticalSpace,
          Container(
            decoration: BoxDecoration(
                color: state.selectIndex == 1
                    ? AppStyle.primary
                    : AppStyle.transparent,
                borderRadius: BorderRadius.circular(10.r)),
            child: IconButton(
                onPressed: () {
                  ref.read(mainProvider.notifier).changeIndex(1);
                },
                icon: Icon(
                  state.selectIndex == 1
                      ? FlutterRemix.shopping_bag_fill
                      : FlutterRemix.shopping_bag_line,
                  color:
                      state.selectIndex == 1 ? AppStyle.white : AppStyle.icon,
                )),
          ),
          28.verticalSpace,
          Container(
            decoration: BoxDecoration(
                color: state.selectIndex == 2
                    ? AppStyle.primary
                    : AppStyle.transparent,
                borderRadius: BorderRadius.circular(10.r)),
            child: IconButton(
                onPressed: () {
                  ref.read(mainProvider.notifier).changeIndex(2);
                },
                icon: Icon(
                  state.selectIndex == 2
                      ? FlutterRemix.user_3_fill
                      : FlutterRemix.user_3_line,
                  color:
                      state.selectIndex == 2 ? AppStyle.white : AppStyle.icon,
                )),
          ),
          28.verticalSpace,
          Container(
            decoration: BoxDecoration(
                color: state.selectIndex == 3
                    ? AppStyle.primary
                    : AppStyle.transparent,
                borderRadius: BorderRadius.circular(10.r)),
            child: IconButton(
              onPressed: () {
                ref.read(mainProvider.notifier).changeIndex(3);
              },
              icon: SvgPicture.asset(
                state.selectIndex == 3
                    ? Assets.svgSelectTable
                    : Assets.svgTable,
              ),
            ),
          ),
          28.verticalSpace,
          Container(
            decoration: BoxDecoration(
                color: state.selectIndex == 4
                    ? AppStyle.primary
                    : AppStyle.transparent,
                borderRadius: BorderRadius.circular(10.r)),
            child: IconButton(
                onPressed: () {
                  ref.read(mainProvider.notifier).changeIndex(4);
                },
                icon: Icon(
                  state.selectIndex == 4
                      ? FlutterRemix.money_dollar_circle_fill
                      : FlutterRemix.money_dollar_circle_line,
                  color:
                      state.selectIndex == 4 ? AppStyle.white : AppStyle.icon,
                )),
          ),
          28.verticalSpace,
          Container(
            decoration: BoxDecoration(
                color: state.selectIndex == 5
                    ? AppStyle.primary
                    : AppStyle.transparent,
                borderRadius: BorderRadius.circular(10.r)),
            child: IconButton(
                onPressed: () {
                  ref.read(mainProvider.notifier).changeIndex(5);
                },
                icon: Icon(
                  state.selectIndex == 5
                      ? FlutterRemix.pie_chart_fill
                      : FlutterRemix.pie_chart_line,
                  color:
                      state.selectIndex == 5 ? AppStyle.white : AppStyle.icon,
                )),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              ref.read(mainProvider.notifier).changeIndex(6);
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: state.selectIndex == 6
                        ? AppStyle.primary
                        : AppStyle.transparent,
                  ),
                  borderRadius: BorderRadius.circular(20.r)),
              child: CommonImage(
                  width: 40,
                  height: 40,
                  radius: 20,
                  imageUrl: LocalStorage.getUser()?.img ?? ""),
            ),
          ),
          24.verticalSpace,
          IconButton(
              onPressed: () {
                context.replaceRoute(const LoginRoute());
                ref.read(newOrdersProvider.notifier).stopTimer();
                ref.read(acceptedOrdersProvider.notifier).stopTimer();
                ref.read(cookingOrdersProvider.notifier).stopTimer();
                ref.read(readyOrdersProvider.notifier).stopTimer();
                ref.read(onAWayOrdersProvider.notifier).stopTimer();
                ref.read(deliveredOrdersProvider.notifier).stopTimer();
                ref.read(canceledOrdersProvider.notifier).stopTimer();
                LocalStorage.clearStore();
              },
              icon: const Icon(
                FlutterRemix.logout_circle_line,
                color: AppStyle.icon,
              )),
          32.verticalSpace
        ],
      ),
    );
  }

  Container bottomLeftNavigationBarKitchen(MainState state) {
    return Container(
      height: double.infinity,
      width: 90.w,
      color: AppStyle.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          28.verticalSpace,
          Container(
            decoration: BoxDecoration(
                color: state.selectIndex == 0
                    ? AppStyle.primary
                    : AppStyle.transparent,
                borderRadius: BorderRadius.circular(10.r)),
            child: IconButton(
              onPressed: () {
                ref.read(mainProvider.notifier).changeIndex(0);
              },
              icon: SvgPicture.asset(
                state.selectIndex == 0
                    ? Assets.svgSelectKitchen
                    : Assets.svgKitchen,
              ),
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              ref.read(mainProvider.notifier).changeIndex(1);
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: state.selectIndex == 1
                        ? AppStyle.primary
                        : AppStyle.transparent,
                  ),
                  borderRadius: BorderRadius.circular(20.r)),
              child: CommonImage(
                  width: 40,
                  height: 40,
                  radius: 20,
                  imageUrl: LocalStorage.getUser()?.img ?? ""),
            ),
          ),
          24.verticalSpace,
          IconButton(
              onPressed: () {
                context.replaceRoute(const LoginRoute());
                ref.read(kitchenProvider.notifier).stopTimer();
                LocalStorage.clearStore();
              },
              icon: const Icon(
                FlutterRemix.logout_circle_line,
                color: AppStyle.icon,
              )),
          32.verticalSpace
        ],
      ),
    );
  }

  Container bottomLeftNavigationBarWaiter(MainState state) {
    return Container(
      height: double.infinity,
      width: 90.w,
      color: AppStyle.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          24.verticalSpace,
          Container(
            decoration: BoxDecoration(
                color: state.selectIndex == 0
                    ? AppStyle.primary
                    : AppStyle.transparent,
                borderRadius: BorderRadius.circular(10.r)),
            child: IconButton(
                onPressed: () {
                  ref.read(mainProvider.notifier).changeIndex(0);
                },
                icon: Icon(
                  state.selectIndex == 0
                      ? FlutterRemix.home_smile_fill
                      : FlutterRemix.home_smile_line,
                  color:
                      state.selectIndex == 0 ? AppStyle.white : AppStyle.icon,
                )),
          ),
          28.verticalSpace,
          Container(
            decoration: BoxDecoration(
                color: state.selectIndex == 1
                    ? AppStyle.primary
                    : AppStyle.transparent,
                borderRadius: BorderRadius.circular(10.r)),
            child: IconButton(
                onPressed: () {
                  ref.read(mainProvider.notifier).changeIndex(1);
                },
                icon: Icon(
                  state.selectIndex == 1
                      ? FlutterRemix.shopping_bag_fill
                      : FlutterRemix.shopping_bag_line,
                  color:
                      state.selectIndex == 1 ? AppStyle.white : AppStyle.icon,
                )),
          ),
          28.verticalSpace,
          Container(
            decoration: BoxDecoration(
                color: state.selectIndex == 2
                    ? AppStyle.primary
                    : AppStyle.transparent,
                borderRadius: BorderRadius.circular(10.r)),
            child: IconButton(
              onPressed: () {
                ref.read(mainProvider.notifier).changeIndex(2);
              },
              icon: SvgPicture.asset(
                state.selectIndex == 2
                    ? Assets.svgSelectTable
                    : Assets.svgTable,
              ),
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              ref.read(mainProvider.notifier).changeIndex(3);
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: state.selectIndex == 3
                        ? AppStyle.primary
                        : AppStyle.transparent,
                  ),
                  borderRadius: BorderRadius.circular(20.r)),
              child: CommonImage(
                  width: 40,
                  height: 40,
                  radius: 20,
                  imageUrl: LocalStorage.getUser()?.img ?? ""),
            ),
          ),
          24.verticalSpace,
          IconButton(
              onPressed: () {
                context.replaceRoute(const LoginRoute());
                ref.read(newOrdersProvider.notifier).stopTimer();
                ref.read(acceptedOrdersProvider.notifier).stopTimer();
                ref.read(cookingOrdersProvider.notifier).stopTimer();
                ref.read(readyOrdersProvider.notifier).stopTimer();
                ref.read(onAWayOrdersProvider.notifier).stopTimer();
                ref.read(deliveredOrdersProvider.notifier).stopTimer();
                ref.read(canceledOrdersProvider.notifier).stopTimer();
                LocalStorage.clearStore();
              },
              icon: const Icon(
                FlutterRemix.logout_circle_line,
                color: AppStyle.icon,
              )),
          32.verticalSpace
        ],
      ),
    );
  }
}

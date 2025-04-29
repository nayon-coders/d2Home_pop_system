import 'package:admin_desktop/generated/assets.dart';
import 'package:admin_desktop/app_constants.dart';
import 'package:admin_desktop/src/core/constants/tr_keys.dart';
import 'package:admin_desktop/src/core/utils/app_helpers.dart';
import 'package:admin_desktop/src/models/data/address_data.dart';
import 'package:admin_desktop/src/models/data/location_data.dart';
import 'package:admin_desktop/src/presentation/components/buttons/animation_button_effect.dart';
import 'package:admin_desktop/src/presentation/components/login_button.dart';
import 'package:admin_desktop/src/presentation/components/buttons/pop_button.dart';
import 'package:admin_desktop/src/presentation/components/keyboard_disable.dart';
import 'package:admin_desktop/src/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../profile/edit_profile/riverpod/provider/edit_profile_provider.dart';
import 'riverpod/select_address_provider.dart';

class SelectAddressPage extends StatefulWidget {
  final ValueChanged<AddressData> onSelect;
  final LocationData? location;
  final bool isShopEdit;

  const SelectAddressPage(
      {super.key,
      required this.onSelect,
      this.location,
      this.isShopEdit = false})
     ;

  @override
  State<SelectAddressPage> createState() => _SelectAddressPageState();
}

class _SelectAddressPageState extends State<SelectAddressPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  CameraPosition? _cameraPosition;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDisable(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Consumer(
          builder: (context, ref, child) {
            final state = ref.watch(selectAddressProvider);
            final event = ref.read(selectAddressProvider.notifier);
            return Stack(
              children: [
                GoogleMap(
                  tiltGesturesEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                    bearing: 0,
                    target: LatLng(
                      widget.location?.latitude ??
                          AppHelpers.getInitialLatitude() ??
                          AppConstants.demoLatitude,
                      widget.location?.longitude ??
                          AppHelpers.getInitialLongitude() ??
                          AppConstants.demoLongitude,
                    ),
                    tilt: 0,
                    zoom: 17,
                  ),
                  onMapCreated: (controller) {
                    event.setMapController(controller);
                    event.gotToPlace(widget.location);
                  },
                  onCameraMoveStarted: () {
                    _animationController.repeat(
                      min: AppConstants.pinLoadingMin,
                      max: AppConstants.pinLoadingMax,
                      period: _animationController.duration! *
                          (AppConstants.pinLoadingMax -
                              AppConstants.pinLoadingMin),
                    );
                    event.setChoosing(true);
                  },
                  onCameraIdle: () {
                    event
                      ..fetchLocationName(_cameraPosition?.target)
                      ..checkDriverZone(
                        context: context,
                        location: _cameraPosition?.target,
                        isShopEdit: widget.isShopEdit,
                      );
                    _animationController.forward(
                      from: AppConstants.pinLoadingMax,
                    );
                    event.setChoosing(false);
                  },
                  onCameraMove: (cameraPosition) {
                    _cameraPosition = cameraPosition;
                  },
                ),
                IgnorePointer(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 78.0,
                      ),
                      child: lottie.Lottie.asset(
                        Assets.lottiePin,
                        onLoaded: (composition) {
                          _animationController.duration = composition.duration;
                        },
                        controller: _animationController,
                        width: 250,
                        height: 250,
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    54.verticalSpace,
                    Container(
                      height: 50.r,
                      padding: REdgeInsets.symmetric(horizontal: 16),
                      margin: REdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: AppStyle.mainBack,
                            offset: Offset(0, 2),
                            blurRadius: 2,
                            spreadRadius: 0,
                          ),
                        ],
                        color: AppStyle.white,
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            FlutterRemix.search_line,
                            size: 20.r,
                            color: AppStyle.black,
                          ),
                          12.horizontalSpace,
                          Expanded(
                            child: TextFormField(
                              controller: state.textController,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                color: AppStyle.black,
                                letterSpacing: -0.5,
                              ),
                              onChanged: (value) {
                                event.setQuery(context);
                              },
                              cursorWidth: 1.r,
                              cursorColor: AppStyle.black,
                              decoration: InputDecoration.collapsed(
                                hintText: AppHelpers.getTranslation(
                                    TrKeys.searchLocation),
                                hintStyle: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                  color: AppStyle.iconButtonBack,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: event.clearSearchField,
                            splashRadius: 20.r,
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              FlutterRemix.close_line,
                              size: 20.r,
                              color: AppStyle.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (state.isSearching)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          color: AppStyle.white,
                        ),
                        margin:
                            REdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        padding:
                            REdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.searchedPlaces.length,
                            padding: EdgeInsets.only(bottom: 22.h),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  event.goToLocation(
                                      place: state.searchedPlaces[index]);
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    22.verticalSpace,
                                    Text(
                                      state.searchedPlaces[index]
                                              .address?["country"] ??
                                          "",
                                    ),
                                    Text(
                                      state.searchedPlaces[index].displayName,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Divider(
                                      color: AppStyle.border,
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                  ],
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 150),
                  bottom: state.isChoosing ? -60.r : 32.r,
                  left: 15.r,
                  right: 15.r,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PopButton(
                        heroTag: 'heroTagAddOrderButton',
                        onTap: widget.isShopEdit
                            ? () {
                                ref
                                    .read(editProfileProvider.notifier)
                                    .setShopEdit(1);
                              }
                            : null,
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          event.goToMyLocation();
                        },
                        child: AnimationButtonEffect(
                          child: Container(
                            width: 56.r,
                            height: 56.r,
                            decoration: BoxDecoration(
                                color: AppStyle.white,
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(color: AppStyle.black)),
                            child: const Center(
                                child: Icon(FlutterRemix.navigation_fill)),
                          ),
                        ),
                      ),
                      16.horizontalSpace,
                      SizedBox(
                        width: 200.w,
                        child: Consumer(
                          builder: (context, ref, child) {
                            return LoginButton(
                                isActive: state.isActive,
                                isLoading: state.isLoading,
                                title: AppHelpers.getTranslation(
                                    TrKeys.confirmLocation),
                                onPressed: () {
                                  if (state.isActive) {
                                    context.maybePop();
                                    widget.onSelect(
                                      AddressData(
                                        location: LocationData(
                                          longitude:
                                              _cameraPosition?.target.longitude,
                                          latitude:
                                              _cameraPosition?.target.latitude,
                                        ),
                                        address:
                                            state.textController?.text ?? "",
                                      ),
                                    );
                                  } else {
                                    AppHelpers.showSnackBar(
                                      context,
                                      AppHelpers.getTranslation(
                                          TrKeys.noDriverZone),
                                    );
                                  }
                                });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

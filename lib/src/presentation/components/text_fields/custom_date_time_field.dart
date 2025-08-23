import 'dart:io';

import 'package:admin_desktop/src/core/constants/constants.dart';
import 'package:admin_desktop/src/core/utils/time_service.dart';
import 'package:admin_desktop/src/core/utils/utils.dart';
import 'package:admin_desktop/src/presentation/theme/app_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CustomDateTimeField extends StatefulWidget {
  final String? Function(String?)? validation;
  final void Function(DateTime)? onDateChange;
  final void Function(TimeOfDay)? onTimeChange;
  final CupertinoDatePickerMode mode;
  final DateTime? initialDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final int minuteInterval;
  final double iconSize;
  final EdgeInsetsGeometry? contentPadding;
  final bool readOnly;
  final String? label;

  const CustomDateTimeField({
    super.key,
    this.validation,
    this.onDateChange,
    this.onTimeChange,
    this.minDate,
    this.maxDate,
    this.mode = CupertinoDatePickerMode.time,
    this.minuteInterval = 1,
    this.iconSize = 18,
    this.contentPadding,
    this.readOnly = false,
    this.label,
    this.initialDate,
  });

  @override
  State<CustomDateTimeField> createState() => _CustomDateTimeFieldState();
}

class _CustomDateTimeFieldState extends State<CustomDateTimeField>
    with SingleTickerProviderStateMixin {
  RenderBox? _childBox;
  OverlayEntry? _overlayEntry;
  TimePickerSpinnerController? _controller;

  late AnimationController _animationController;
  late Tween<double> _colorTween;
  late Animation<double?> _animation;

  DateTime? _selectedDateTime;
  late DateTime _selectedDateTimeSpinner;
  IconData? iconAssets;
  String? time;
  late Function setStateValue;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialDate;
    _selectedDateTimeSpinner = widget.initialDate ?? DateTime.now().add(const Duration(minutes: 1));
    _controller = TimePickerSpinnerController();
    _controller?.addListener(_updateView);
    setInitialTimes();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        _childBox = context.findRenderObject() as RenderBox?;
      }
    });

    _colorTween = Tween(begin: 0, end: 1);
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    _animation = _colorTween.animate(_animationController);
  }

  @override
  void didUpdateWidget(covariant CustomDateTimeField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _selectedDateTime =  widget.initialDate;
    _selectedDateTimeSpinner = widget.initialDate ?? DateTime.now().add(const Duration(minutes: 1));
  }

  setInitialTimes() {
    switch (widget.mode) {
      case CupertinoDatePickerMode.time:
        time = _selectedDateTime == null
            ? null
            : TimeService.timeFormat(_selectedDateTime);
        iconAssets = Icons.access_time;
        break;
      case CupertinoDatePickerMode.date:
        time = _selectedDateTime == null
            ? null
            : TimeService.dateFormatDM(_selectedDateTime!);
        iconAssets = Icons.calendar_month;
        break;
      case CupertinoDatePickerMode.dateAndTime:
        time = _selectedDateTime == null
            ? null
            : DateFormat('dd/MM/yyyy HH:mm').format(_selectedDateTime!);
        iconAssets = Icons.calendar_month;
        break;
      case CupertinoDatePickerMode.monthYear:
        break;
    }
  }

  @override
  void dispose() {
    _hideMenu();
    _controller?.removeListener(_updateView);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
        validator: widget.validation,
        initialValue: time,
        builder: (FormFieldState<String> state) {
          var child = _timeWidget(state);
          setStateValue = () => state.didChange(time);
          if (Platform.isIOS) {
            return child;
          } else {
            return PopScope(
              onPopInvoked: (s) => _hideMenu(),
              canPop: true,
              child: child,
            );
          }
        });
  }

  _showMenu() {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        double screenWidth = MediaQuery.sizeOf(context).width;
        double screenHeight = MediaQuery.sizeOf(context).height;

        final size = _childBox!.size;
        final offset = _childBox!.localToGlobal(const Offset(0, 0));

        final confirmButton = Expanded(
            child: GestureDetector(
          onTap: () {
            _animationController.reverse();
            setState(() => _selectedDateTime = _selectedDateTimeSpinner);
            Future.delayed(const Duration(milliseconds: 150), () {
              if (widget.mode == CupertinoDatePickerMode.time) {
                widget.onTimeChange
                    ?.call(_selectedDateTimeSpinner.toTime);
              } else {
                widget.onDateChange?.call(_selectedDateTimeSpinner);
              }
              setInitialTimes();
              setStateValue();
              _hideMenu();
            });
          },
          child: Text(
            AppHelpers.getTranslation(TrKeys.ok),
            style: AppStyle.interNormal(size: 14),
            textAlign: TextAlign.center,
          ),
        ));

        final cancelButton = Expanded(
          child: GestureDetector(
            onTap: () {
              _animationController.reverse();
              _selectedDateTimeSpinner = _selectedDateTime ?? DateTime.now();
              Future.delayed(const Duration(milliseconds: 150), () {
                _hideMenu();
              });
            },
            child: Text(
              AppHelpers.getTranslation(TrKeys.cancel),
              style: AppStyle.interNormal(size: 14),
              textAlign: TextAlign.center,
            ),
          ),
        );

        Widget menu = Container(
          margin: const EdgeInsets.all(16),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radius),
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: AppStyle.black.withOpacity(0.08),
                spreadRadius: 0,
                blurRadius: 8,
                offset: const Offset(0, 2), // changes position of shadow
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 225,
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                        dateTimePickerTextStyle: AppStyle.interNormal()),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: size.width + 2,
                      ),
                      child: CupertinoDatePicker(
                        minimumDate: widget.minDate,
                        maximumDate: widget.maxDate,
                        minuteInterval: widget.minuteInterval,
                        initialDateTime: _selectedDateTimeSpinner,
                        use24hFormat: true,
                        mode: widget.mode,
                        onDateTimeChanged: (dateTime) {
                          if (widget.minDate != null &&
                              dateTime.isBefore(widget.minDate!)) {
                            _selectedDateTimeSpinner = widget.minDate!;
                          } else if (widget.maxDate != null &&
                              dateTime.isAfter(widget.maxDate!)) {
                            _selectedDateTimeSpinner = widget.maxDate!;
                          } else {
                            _selectedDateTimeSpinner = dateTime;
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              DefaultTextStyle(
                style: AppStyle.interNormal(),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [cancelButton, confirmButton]),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );

        Widget menuWithPositioned = AnimatedBuilder(
          animation: _animation,
          builder: (BuildContext context, Widget? child) {
            final value = _animation.value ?? 0;

            final centerHorizontal = offset.dx + (size.width) / 2;

            double left = centerHorizontal - (((size.width) / 2) * value);
            double right =
                screenWidth - (centerHorizontal + (((size.width) / 2) * value));
            double? top = offset.dy - ((220 / 2) * value);
            double? bottom;

            if (left < 0) {
              left = 5;
              right = screenWidth - (5 + size.width + 2);
            }

            if (right < 0) {
              right = 5;
              left = screenWidth - (5 + size.width + 2);
            }

            if (top < 0) {
              top = 5;
              bottom = null;
            }

            if (top + 240 > screenHeight) {
              bottom = 5;
              top = null;
            }

            return Positioned(
              left: left - 10,
              right: right - 10,
              top: top == null ? null : (top - 10),
              bottom: bottom == null ? null : (bottom - 10),
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 270 * value,
                  ),
                  child: SingleChildScrollView(child: menu)),
            );
          },
        );

        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => _controller?.hideMenu(),
                child: Container(color: Colors.black12),
              ),
            ),
            menuWithPositioned,
          ],
        );
      },
    );
    if (_overlayEntry != null) {
      Overlay.of(context).insert(_overlayEntry!);
      _animationController.forward();
    }
  }

  Widget _timeWidget(FormFieldState<String> state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: REdgeInsets.only(right: 6, bottom: 2),
            child: Text(
              "${AppHelpers.getTranslation(widget.label ?? '')} ${widget.validation != null ? '*' : ''}",
              style: AppStyle.interNormal(size: 14),
            ),
          ),
        InkWell(
          onTap: widget.readOnly
              ? null
              : () {
                  _controller?.showMenu();
                },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.fromBorderSide(
                BorderSide.merge(
                  const BorderSide(color: AppStyle.icon),
                  const BorderSide(color: AppStyle.icon),
                ),
              ),
              borderRadius: BorderRadius.circular(AppConstants.radius.r),
            ),
            padding: widget.contentPadding ??
                REdgeInsets.symmetric(vertical: 14, horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    state.value ??
                        AppHelpers.getTranslation(TrKeys.pleaseSelect),
                    style: AppStyle.interNormal(
                      size: 14,
                      color: state.value == null ? AppStyle.hint : AppStyle.black,
                    ),
                  ),
                ),
                Icon(
                  iconAssets,
                  size: widget.iconSize,
                  color: state.value == null ? AppStyle.hint : AppStyle.black,
                ),
              ],
            ),
          ),
        ),
        state.hasError
            ? Padding(
                padding: REdgeInsets.only(left: 14, top: 4),
                child: Text(
                  state.errorText ?? '',
                  style: AppStyle.interRegular(size: 12, color: AppStyle.red),
                ),
              )
            : Container()
      ],
    );
  }

  _hideMenu() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  _updateView() {
    bool menuIsShowing = _controller?.menuIsShowing ?? false;
    if (menuIsShowing) {
      _showMenu();
    } else {
      _hideMenu();
    }
  }
}

class TimePickerSpinnerController extends ChangeNotifier {
  bool menuIsShowing = false;
  bool isUpdate = false;

  void showMenu() {
    menuIsShowing = true;
    notifyListeners();
  }

  void hideMenu() {
    menuIsShowing = false;
    notifyListeners();
  }

  void toggleMenu() {
    menuIsShowing = !menuIsShowing;
    notifyListeners();
  }

  void updateMenu() {
    isUpdate = true;
    hideMenu();
    showMenu();
    isUpdate = false;
  }
}

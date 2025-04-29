export 'custom_dropdown.dart';

import 'package:admin_desktop/src/presentation/pages/main/widgets/order_detail/order_riverpod/order_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:admin_desktop/src/core/constants/constants.dart';
import 'package:admin_desktop/src/core/utils/utils.dart';
import 'package:admin_desktop/src/models/models.dart';
import '../../pages/main/widgets/customers/components/custom_add_customer_dialog.dart';
import '../../pages/main/widgets/right_side/riverpod/right_side_provider.dart';
import '../../theme/theme.dart';

part 'dropdown_field.dart';
part 'animated_section.dart';
part 'dropdown_overlay.dart';
part 'overlay_builder.dart';

class CustomDropdown extends StatefulWidget {
  final DropDownType dropDownType;
  final String? hintText;
  final String? searchHintText;
  final String? initialValue;
  final int? initialId;
  final Function(String)? onChanged;

  const CustomDropdown({
    super.key,
    required this.dropDownType,
    this.hintText,
    this.searchHintText,
    this.onChanged,
    this.initialValue, this.initialId,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  final layerLink = LayerLink();
  late TextEditingController controller;


  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hintText = widget.hintText ?? 'Select value';
    final searchHintText = widget.searchHintText ?? 'Search value';
    return _OverlayBuilder(
      overlay: (size, hideCallback) {
        return _DropdownOverlay(
          searchHintText: searchHintText,
          controller: controller,
          size: size,
          layerLink: layerLink,
          hideOverlay: hideCallback,
          hintText: hintText,
          onChanged: widget.onChanged,
          dropDownType: widget.dropDownType,
        );
      },
      child: (showCallback) {
        return CompositedTransformTarget(
          link: layerLink,
          child: _DropDownField(
            controller: controller,
            onTap: showCallback,
            hintText: hintText,
            dropDownType: widget.dropDownType,
          ),
        );
      },
    );
  }
}

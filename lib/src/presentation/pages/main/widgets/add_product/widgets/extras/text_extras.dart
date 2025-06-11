import 'package:admin_desktop/src/models/models.dart';
import 'package:admin_desktop/src/presentation/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'size_item.dart';

class TextExtras extends StatelessWidget {
  final int groupIndex;
  final List<UiExtra> uiExtras;
  final Function(UiExtra) onUpdate;

  const TextExtras({
    super.key,
    required this.groupIndex,
    required this.uiExtras,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: uiExtras.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,       // Number of columns you want
        crossAxisSpacing: 10,    // Horizontal spacing between grid items
        mainAxisSpacing: 10,     // Vertical spacing between grid items
        childAspectRatio: 150 / 100,
      ),
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            if (uiExtras[index].isSelected) {
              return;
            }
            onUpdate(uiExtras[index]);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: uiExtras[index].isSelected ? AppStyle.primary : Colors.white,
              border: Border.all(width: 1, color: AppStyle.primary),
              borderRadius: BorderRadius.circular(5),
            ),
            alignment: Alignment.center, // Center text inside grid cell
            child: Text(
              "${uiExtras[index].value}",
              style: TextStyle(
                color: uiExtras[index].isSelected ? Colors.white : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        );
      },
    );
  }
}

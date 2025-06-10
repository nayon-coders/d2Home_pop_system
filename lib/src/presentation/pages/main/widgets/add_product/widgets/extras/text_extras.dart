import 'package:admin_desktop/src/models/models.dart';
import 'package:admin_desktop/src/presentation/theme/app_style.dart';
import 'package:flutter/material.dart';

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
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: uiExtras.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: (){
              if (uiExtras[index].isSelected) {
                return;
              }
              onUpdate(uiExtras[index]);
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 10),
            width: 200,
            height: 40,
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
            decoration: BoxDecoration(
              color: uiExtras[index].isSelected ? AppStyle.primary : Colors.white,
              border:  Border.all(width: 1, color: AppStyle.primary),
              borderRadius: BorderRadius.circular(5)
            ),
            child: Text("${uiExtras[index].value}",
              style: TextStyle(
                color:  uiExtras[index].isSelected ? Colors.white:  Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400
              ),
            ),
          ),
        ); 
        // return SizeItem(
        //   onTap: () {
        //     if (uiExtras[index].isSelected) {
        //       return;
        //     }
        //     onUpdate(uiExtras[index]);
        //   },
        //   isActive: uiExtras[index].isSelected,
        //   title: uiExtras[index].value,
        // );
      },
    );
  }
}

// import 'package:admin_desktop/src/core/constants/constants.dart';
// import 'package:admin_desktop/src/core/utils/app_helpers.dart';
// import 'package:admin_desktop/src/models/data/addons_data.dart';
// import 'package:admin_desktop/src/presentation/theme/theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import 'ingredient_item.dart';
//
// class WIngredientScreen extends StatelessWidget {
//   final List<Addons> list;
//   final ValueChanged<int> onChange;
//   final ValueChanged<int> add;
//   final ValueChanged<int> remove;
//
//   const WIngredientScreen(
//       {required this.list,
//       super.key,
//       required this.onChange,
//       required this.add,
//       required this.remove})
//      ;
//
//   @override
//   Widget build(BuildContext context) {
//     return list.isEmpty
//         ? const SizedBox.shrink()
//         : Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: list.isEmpty ? AppStyle.transparent : AppStyle.white,
//               borderRadius: BorderRadius.circular(10.r),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   AppHelpers.getTranslation(TrKeys.ingredients),
//                   style: GoogleFonts.inter(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                     color: AppStyle.black,
//                     letterSpacing: -0.4,
//                   ),
//                 ),
//                 16.verticalSpace,
//                 ListView.builder(
//                   physics: const NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: list.length,
//                   padding: EdgeInsets.zero,
//                   itemBuilder: (context, index) {
//                     return IngredientItem(
//                       onTap: () {
//                         onChange(index);
//                       },
//                       addon: list[index],
//                       add: () {
//                         add(index);
//                       },
//                       remove: () {
//                         remove(index);
//                       },
//                     );
//                   },
//                 ),
//               ],
//             ),
//           );
//   }
// }


import 'package:admin_desktop/src/core/constants/constants.dart';
import 'package:admin_desktop/src/core/utils/app_helpers.dart';
import 'package:admin_desktop/src/models/data/addons_data.dart';
import 'package:admin_desktop/src/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ingredient_item.dart';

class WIngredientScreen extends StatelessWidget {
  final List<Addons> list;
  final ValueChanged<int> onChange;
  final ValueChanged<int> add;
  final ValueChanged<int> remove;

  const WIngredientScreen(
      {required this.list,
        super.key,
        required this.onChange,
        required this.add,
        required this.remove})
  ;

  @override
  Widget build(BuildContext context) {
    return list.isEmpty
        ? const SizedBox.shrink()
        : Container(
          width:200,
          decoration: BoxDecoration(
            color: list.isEmpty ? AppStyle.transparent : AppStyle.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppHelpers.getTranslation(TrKeys.ingredients),
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppStyle.black,
                  letterSpacing: -0.4,
                ),
              ),
              16.verticalSpace,
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: list.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12.r,
                  mainAxisSpacing: 12.r,
                  childAspectRatio: 1,// adjust as per design
                ),
                itemBuilder: (context, index) {
                  return IngredientItem(
                    onTap: () => onChange(index),
                    addon: list[index],
                    add: () => add(index),
                    remove: () => remove(index),
                  );
                },
              ),
            ],
          ),
        );
  }
}

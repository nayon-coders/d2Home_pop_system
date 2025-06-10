import 'package:admin_desktop/src/presentation/components/buttons/animation_button_effect.dart';
import 'package:admin_desktop/src/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryTabBarItem extends StatelessWidget {
  final String? title;
  final String? image;
  final bool isActive;
  final Function() onTap;

  const CategoryTabBarItem({
    super.key,
    this.title,
    this.image,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationButtonEffect(
      child: GestureDetector(
        onTap: isActive ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),

          width: 110.r,
          height: 80.r,

          decoration: BoxDecoration(
            color: isActive ? AppStyle.primary.withOpacity(0.2) : AppStyle.white,
            borderRadius: BorderRadius.circular(5.r),
            boxShadow: [
              BoxShadow(
                color: AppStyle.white.withOpacity(0.07),
                spreadRadius: 0,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          alignment: Alignment.center,
          padding: REdgeInsets.symmetric(horizontal: 18, vertical: 5),
          margin: REdgeInsets.only(right: 8),
          child: Column(
            children: [
              SizedBox(
                height: 70.r,
                child: ClipRRect(
                  borderRadius: BorderRadiusDirectional.circular(10),
                    child: Image.network(image ?? "https://cdn-icons-png.freepik.com/256/12130/12130914.png?semt=ais_hybrid", fit: BoxFit.cover
                      ,)),
              ),
              SizedBox(height: 10,),
              Text(
                '$title',
                textAlign: TextAlign.center,
                maxLines: 1,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: AppStyle.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:admin_desktop/src/core/utils/app_helpers.dart';
import '../theme/theme.dart';
import 'shimmers/make_shimmer.dart';

class CommonImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final double radius;
  final bool isResponsive;
  final bool isRedious;
  final File? fileImage;


  const CommonImage({
    super.key,
    required this.imageUrl,
    this.width = double.infinity,
    this.height = 50,
    this.radius = 10,  this.isResponsive=true,
    this.fileImage,
    this.isRedious = true
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius.r),
      child: fileImage != null ? Image.file(
        fileImage!,
        height: height,
        width: width,
        fit: BoxFit.cover,
      ) : AppHelpers.checkIsSvg(imageUrl)
        ? SvgPicture.network(
      '$imageUrl',
      width: isResponsive? width.r :width,
      height: isResponsive? height.r :height,
      fit: BoxFit.cover,
      placeholderBuilder: (_) => Container(
        decoration: BoxDecoration(
          borderRadius: isRedious ? BorderRadius.circular(radius.r) :  null ,
          color: AppStyle.white,
        ),
      ),
    ):
      CachedNetworkImage(
        imageUrl: '$imageUrl',
        width: isResponsive? width.r :width,
        height:  isResponsive? height.r :height,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, progress) {
          return MakeShimmer(
            child: Container(
              decoration: BoxDecoration(
                borderRadius:  isRedious ? BorderRadius.circular(isResponsive ?radius.r :radius) : null,
                color: AppStyle.mainBack,
              ),
            ),
          );
        },
        errorWidget: (context, url, error) {
          return Container(
            width: isResponsive? width.r :width,
            height:  isResponsive? height.r :height,
            decoration: BoxDecoration(
              borderRadius: isRedious ? BorderRadius.circular(isResponsive ?radius.r :radius) : null,
              border: Border.all(color: AppStyle.border),
              color: AppStyle.mainBack,
            ),
            alignment: Alignment.center,
            child: Icon(
              FlutterRemix.image_line,
              color: AppStyle.black.withOpacity(0.5),
              size: isResponsive? 20.r :20,
            ),
          );
        },
      ),
    );
  }
}

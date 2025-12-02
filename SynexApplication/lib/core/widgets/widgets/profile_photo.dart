import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../resources/app_assets.dart';
import '../../resources/app_colors.dart';

class ProfilePhoto extends StatelessWidget {
  final double? photoSize;
  final String? url;

  const ProfilePhoto({
    super.key,
    this.photoSize,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.transparent,
          width: 10,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.bgColor.withAlpha(120),
            width: 5,
          ),
        ),
        child: Container(
            padding: EdgeInsets.all(3),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: ClipOval(
              child: SizedBox.fromSize(
                size: Size.fromRadius(photoSize ?? 26),
                child: getImage(),
              ),
            )),
      ),
    );
  }

  Widget getImage() {
    if (url is String) {
      if (url!.isNotEmpty) {
        return CachedNetworkImage(
          imageUrl: url!,
          fit: BoxFit.cover,
        );
      }
    }
    return Image.asset(
      AppAssets.unknown_user,
      fit: BoxFit.cover,
    );
  }
}

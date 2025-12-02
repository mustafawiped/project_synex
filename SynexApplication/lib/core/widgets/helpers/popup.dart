import 'package:flutter/material.dart';
import 'package:suffadaemon/utils/popup/popup.dart';
import 'package:suffadaemon/utils/resources/sizes.dart';

import '../../resources/app_colors.dart';

class AppPopupHelper {
  static void showPopup(
      BuildContext context,
      String headerText,
      String descText,
      String okBtnText,
      String cancelBtnText,
      VoidCallback okBtnFunc,
      {VoidCallback? cancelBtnFunc,
      bool? dismissState,
      PopupType? type}) {
    SuffaPopup.showPopup(
      context,
      headerText,
      descText,
      okBtnText,
      type as PopupType,
      okBtnFunc,
      declineBtnText: cancelBtnText,
      declineBtnFnc: cancelBtnFunc,
      dialogBgColor: AppColors.bgColor,
      okBtnColor: AppColors.primaryColor,
      cancelBtnColor: AppColors.lightGray,
      dismissOutSide: dismissState,
      titleTextStyle: TextStyle(
        fontSize: SuffaSizes.xLargeTextSize,
        color: AppColors.openGray,
        fontWeight: FontWeight.w700,
      ),
      descTextStyle: const TextStyle(
        fontSize: SuffaSizes.mediumTextSize,
        color: AppColors.lightColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

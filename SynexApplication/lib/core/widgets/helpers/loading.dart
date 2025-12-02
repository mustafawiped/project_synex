// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';

class loadingDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: Center(
            child: Container(
              width: 150.0,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: AppColors.darkGray.withAlpha(200),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: AppColors.primaryColor),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

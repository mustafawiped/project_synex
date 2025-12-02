import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:synex/pages/auth/loginpage/login_page.dart';
import 'package:synex/pages/home/home_page.dart';
import 'package:synex/utils/shareds.dart';
import '../../core/resources/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const String routeName = "splash_page_route_name";

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    // logo animation adjusted
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // animation definition
    animation = Tween<double>(begin: 2, end: 2.2).animate(controller);

    // make the animation repeat continuously
    controller.repeat(reverse: true);

    // operations to be done in SplashScreen
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      splashMethod(context);
    });
  }

  Future<void> splashMethod(BuildContext context) async {
    await initializeDateFormatting('tr_TR', null);
    final accData = await SharedUtils.getShared();
    if (accData != null) {
      if (accData.isNotEmpty) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomePage.routeName,
          (route) => false,
        );
        return;
      }
    }
    Navigator.pushNamedAndRemoveUntil(
      context,
      LoginPage.routeName,
      (route) => false,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
        children: [
          // animated company logo
          // Expanded(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       AnimatedBuilder(
          //         animation: controller,
          //         builder: (BuildContext context, Widget? child) {
          //           return Transform.scale(
          //             scale: animation.value,
          //             child: Image.asset(
          //               "",
          //               width: 150,
          //               height: 150,
          //             ),
          //           );
          //         },
          //       ),
          //       const SizedBox(
          //         height: 100,
          //       ),
          //     ],
          //   ),
          // ),

          // the company that developed the software
          const Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              "SuffaTech © 2025",
              style: TextStyle(color: Colors.grey, fontSize: 9),
            ),
          ),
        ],
      ),
    );
  }
}

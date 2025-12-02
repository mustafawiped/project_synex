import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suffadaemon/components/components.dart';
import 'package:suffadaemon/utils/utils.dart';
import 'package:synex/core/resources/app_colors.dart';
import 'package:synex/pages/auth/registerpage/register_page.dart';
import 'package:synex/utils/extensions.dart';
import 'package:synex/viewmodel/auth/login_page_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static String routeName = "login_page_route_name";

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  LoginPageViewModel viewModel = LoginPageViewModel();

  @override
  void dispose() {
    super.dispose();

    viewModel.usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ChangeNotifierProvider<LoginPageViewModel>(
          create: (context) => viewModel,
          builder: (context, child) {
            return Consumer<LoginPageViewModel>(
              builder: (context, value, child) {
                return buildUI();
              },
            );
          },
        ),
      ),
    );
  }

  Widget buildUI() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Kullanıcı Adı girişi
            SuffaInput(
              bgColor: AppColors.dimColor,
              height: 55,
              prefixIcon: Icons.person,
              focusNode: viewModel.usernameFocusNode,
              textFont: TextStyle(
                color: AppColors.lightColor,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              hintFont: TextStyle(
                color: AppColors.lightGray,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              borderColor: Colors.transparent,
              controller: viewModel.usernameController,
              hintText: "Kullanıcı Adı..",
              keyboardType: TextInputType.text,
            ),

            // sizedbox
            // SizedBox(height: 20),
            20.h,

            // Şifre girişi
            SuffaInput(
              bgColor: AppColors.dimColor,
              height: 55,
              maxLines: 1,
              prefixIcon: Icons.password,
              focusNode: viewModel.passwordFocusNode,
              textFont: TextStyle(
                color: AppColors.lightColor,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              hintFont: TextStyle(
                color: AppColors.lightGray,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              borderColor: Colors.transparent,
              controller: viewModel.passwordController,
              pswState: viewModel.pswState,
              pswFunc: () => viewModel.pswChange(),
              hintText: "Şifre..",
              keyboardType: TextInputType.text,
            ),

            20.h,

            SuffaButton(
              bgColor: AppColors.logoColor,
              title: "Giriş",
              onClick: () => viewModel.login(context),
            ),

            10.h,

            // divider
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Divider(
                color: AppColors.lightGray,
              ),
            ),

            // sizedbox
            20.h,

            // register
            buildRegister(),
          ],
        ),
      ),
    );
  }

  Widget buildRegister() {
    return SizedBox(
      height: 30,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SuffaText(
            alignment: Alignment.centerRight,
            title: "Henüz bir hesabın yok mu?",
            maxLines: 1,
            textFont: TextStyle(
              fontSize: SuffaSizes.xMediumTextSize,
              color: Colors.grey.shade300,
              fontWeight: FontWeight.w400,
            ),
          ),
          5.w,
          InkWell(
            onTap: () => Navigator.pushNamed(context, RegisterPage.routeName),
            child: SuffaText(
              alignment: Alignment.center,
              title: "Kayıt Ol!",
              maxLines: 1,
              textFont: const TextStyle(
                fontSize: SuffaSizes.mediumTextSize,
                color: AppColors.lightColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

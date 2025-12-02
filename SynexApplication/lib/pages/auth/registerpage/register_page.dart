import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suffadaemon/components/components.dart';
import 'package:suffadaemon/utils/utils.dart';
import 'package:synex/utils/extensions.dart';
import 'package:synex/viewmodel/auth/register_page_view_model.dart';

import '../../../core/resources/app_colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static String routeName = "register_page_route_name";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  RegisterPageViewModel viewModel = RegisterPageViewModel();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ChangeNotifierProvider<RegisterPageViewModel>(
          create: (context) => viewModel,
          builder: (context, child) {
            return Consumer<RegisterPageViewModel>(
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
            // username
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
            20.h,

            // email
            SuffaInput(
              bgColor: AppColors.dimColor,
              height: 55,
              prefixIcon: Icons.email,
              focusNode: viewModel.emailFocusNode,
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
              controller: viewModel.emailController,
              hintText: "E Posta..",
              keyboardType: TextInputType.emailAddress,
            ),

            // sizedbox
            20.h,

            // password
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
              hintText: "Şifre..",
              keyboardType: TextInputType.text,
            ),

            // sizedbox
            20.h,

            // password again
            SuffaInput(
              bgColor: AppColors.dimColor,
              height: 55,
              maxLines: 1,
              prefixIcon: Icons.password,
              focusNode: viewModel.passwordAgainFocusNode,
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
              controller: viewModel.passwordAgainController,
              hintText: "Şifre Tekrarı..",
              keyboardType: TextInputType.text,
            ),

            20.h,

            // kayıt ol butonu
            SuffaButton(
              bgColor: AppColors.logoColor,
              title: "Kayıt Ol",
              onClick: () => viewModel.createUser(context),
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
            buildGoLogin(),
          ],
        ),
      ),
    );
  }

  Widget buildGoLogin() {
    return SizedBox(
      height: 30,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SuffaText(
            alignment: Alignment.centerRight,
            title: "Zaten hesabın var mı?",
            maxLines: 1,
            textFont: TextStyle(
              fontSize: SuffaSizes.xMediumTextSize,
              color: Colors.grey.shade300,
              fontWeight: FontWeight.w400,
            ),
          ),
          5.w,
          InkWell(
            onTap: () => Navigator.pop(context),
            child: SuffaText(
              alignment: Alignment.center,
              title: "Giriş Yap!",
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

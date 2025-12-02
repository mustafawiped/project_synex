import 'package:flutter/material.dart';
import 'package:suffadaemon/utils/helpers/toasts.dart';
import 'package:synex/core/widgets/helpers/loading.dart';
import 'package:synex/models/User/user_model.dart';
import 'package:synex/resources/user/user_repo.dart';

class RegisterPageViewModel extends ChangeNotifier {
  UserRepo userRepo = UserRepo();

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordAgainController = TextEditingController();

  FocusNode usernameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode passwordAgainFocusNode = FocusNode();

  void createUser(BuildContext context) async {
    usernameFocusNode.unfocus();
    emailFocusNode.unfocus();
    passwordFocusNode.unfocus();
    passwordAgainFocusNode.unfocus();

    String username = usernameController.text,
        email = emailController.text,
        password = passwordController.text,
        passwordAgain = passwordAgainController.text;

    bool inputControls =
        inputControl(context, username, email, password, passwordAgain);

    if (!inputControls) return;

    UserModel userModel =
        UserModel(id: 0, username: username, email: email, password: password);

    loadingDialog.show(context);

    dynamic apiResponse = await userRepo.createUser(userModel);

    Navigator.pop(context);

    if (apiResponse[0]) {
      Navigator.pop(context);
      ScreenMessage.showSuccessToast(context, apiResponse[1]);
    } else {
      ScreenMessage.showErrorToast(context, apiResponse[1]);
    }
  }

  bool inputControl(BuildContext context, String username, String email,
      String password, String passwordAgain) {
    // empty control
    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        passwordAgain.isEmpty) {
      ScreenMessage.showErrorToast(
          context, "Lütfen bilgilerinizi eksiksiz bir şekilde doldurun.");
      return false;
    }

    // username length control
    if (username.length < 3 || username.length > 25) {
      ScreenMessage.showErrorToast(
          context, "Kullanıcı adı minimum 3, maksimum 25 karakter olabilir.");
      return false;
    }

    if (email.length > 35 ||
        !(email.contains("@")) ||
        !(email.contains(".com")) ||
        email == "@.com") {
      ScreenMessage.showErrorToast(
          context, "Lütfen geçerli bir e-posta adresi giriniz.");
      return false;
    }

    if (password.length < 4) {
      ScreenMessage.showErrorToast(
          context, "Şifre minimum 4 karakter olabilir.");
      return false;
    }

    if (password != passwordAgain) {
      ScreenMessage.showErrorToast(
          context, "Şifre ile şifre tekrarı birbiriyle uyuşmuyor.");
      return false;
    }

    return true;
  }
}

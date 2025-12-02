import 'package:flutter/material.dart';
import 'package:suffadaemon/utils/utils.dart';
import 'package:synex/core/widgets/helpers/loading.dart';
import 'package:synex/pages/home/home_page.dart';
import 'package:synex/resources/token/token_repo.dart';
import 'package:synex/resources/user/user_repo.dart';
import 'package:synex/utils/shareds.dart';

class LoginPageViewModel extends ChangeNotifier {
  UserRepo userRepo = UserRepo();
  TokenRepo tokenRepo = TokenRepo();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode usernameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  bool pswState = true;

  void pswChange() {
    pswState = !pswState;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    usernameFocusNode.unfocus();
    passwordFocusNode.unfocus();

    String username = usernameController.text,
        password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScreenMessage.showErrorToast(
          context, "Lütfen kullanıcı adı ya da şifrenizi girin.");
      return;
    }

    loadingDialog.show(context);

    dynamic response = await userRepo.loginUser(username, password);

    Navigator.pop(context);

    if (response[0]) {
      await SharedUtils.addOrUpdateShared(username);
      bool tokenState = await tokenRepo.registerToken(username);
      if (!tokenState) {
        ScreenMessage.showErrorToast(context,
            "Bildirim izni verilmediği için giriş başarısız, daha sonra tekrar deneyin.");
        return;
      }

      ScreenMessage.showSuccessToast(context, response[1]);
      Navigator.pushNamedAndRemoveUntil(
          context, HomePage.routeName, (route) => false);
    } else {
      ScreenMessage.showErrorToast(context, response[1]);
    }
  }
}

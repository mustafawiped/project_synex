import 'package:flutter/material.dart';
import 'package:suffadaemon/utils/utils.dart';
import 'package:synex/models/User/user_model.dart';
import 'package:synex/pages/splash/splash_page.dart';
import 'package:synex/resources/notification/notification_repo.dart';
import 'package:synex/resources/user/user_repo.dart';
import 'package:synex/utils/shareds.dart';

class PeoplePageViewModel extends ChangeNotifier {
  UserRepo userRepo = UserRepo();
  NotificationRepo notificationRepo = NotificationRepo();

  bool pageLoading = true;

  ScrollController scrollController = ScrollController();

  List<UserModel> userList = [];

  int itemsToShow = 12;

  Future<void> initComps(BuildContext context) async {
    String username = await SharedUtils.getShared() ?? "";

    if (username.isEmpty) {
      ScreenMessage.showErrorToast(
          context, "Kullanıcı bilgisi alınamadı, lütfen tekrar deneyin.");
      Navigator.pushNamedAndRemoveUntil(
          context, SplashPage.routeName, (route) => false);
      return;
    }

    var response = await userRepo.getAllUser(username);

    if (response is! List<UserModel>) {
      ScreenMessage.showErrorToast(
          context, "Sayfa yüklenemedi, lütfen tekrar deneyin.");
      Navigator.pop(context);
      return;
    }

    userList = response;
    pageLoading = false;

    notifyListeners();
  }

  void loadMore() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      itemsToShow = itemsToShow + 12;
      notifyListeners();
    }
  }

  Future<void> sendNotification(BuildContext context, int otherUserId) async {
    String? thisUsername = await SharedUtils.getShared();
    if (thisUsername == null) return;

    await notificationRepo.sendNotification("$thisUsername Seni Arıyor!",
        otherUserId, "Aramaya cevap verebilmek için tıklayın.", -1);
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suffadaemon/components/components.dart';
import 'package:suffadaemon/utils/utils.dart';
import 'package:synex/core/widgets/helpers/loading.dart';
import 'package:synex/core/widgets/helpers/popup.dart';
import 'package:synex/core/widgets/widgets/profile_photo.dart';
import 'package:synex/models/User/user_model.dart';
import 'package:synex/pages/chat/image_show_page.dart';
import 'package:synex/pages/splash/splash_page.dart';
import 'package:synex/resources/token/token_repo.dart';
import 'package:synex/utils/extensions.dart';
import 'package:synex/utils/shareds.dart';
import 'package:synex/viewmodel/profile/profile_page_view_model.dart';

import '../../core/resources/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.userModel});

  final UserModel userModel;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfilePageViewModel viewModel = ProfilePageViewModel();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        viewModel.initComps(widget.userModel);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.secondaryColor,
          elevation: 0,
          titleSpacing: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, viewModel.userModel);
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.lightColor,
            ),
          ),
          title: SuffaText(
            title: "Profilin",
            textFont: TextStyle(
              color: AppColors.lightColor,
              fontSize: SuffaSizes.xxLargeTextSize,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            if (viewModel.isProfileOwner)
              IconButton(
                onPressed: () {
                  AppPopupHelper.showPopup(
                      context,
                      "Hesabından çıkıyorsun...",
                      "Hesabından çıkmak istediğine emin misin?",
                      "Çıkış",
                      "İptal", () async {
                    loadingDialog.show(context);
                    await TokenRepo().deleteTokens(widget.userModel.id);
                    await SharedUtils.addOrUpdateShared("");
                    Navigator.pop(context);
                    Navigator.pushNamedAndRemoveUntil(
                        context, SplashPage.routeName, (route) => false);
                  },
                      cancelBtnFunc: () {},
                      dismissState: false,
                      type: PopupType.warning);
                },
                icon: Icon(
                  Icons.logout,
                  color: AppColors.deleteColor,
                ),
              ),
          ],
        ),
        body: ChangeNotifierProvider<ProfilePageViewModel>(
          create: (context) => viewModel,
          builder: (context, child) {
            return Consumer<ProfilePageViewModel>(
              builder: (context, value, child) {
                if (viewModel.loadingState) {
                  return buildLoading();
                } else {
                  return buildUI();
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(color: AppColors.secondaryColor),
    );
  }

  Widget buildUI() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // sizedbox
          20.h,

          // profile photo
          GestureDetector(
            onTap: () {
              if (viewModel.userModel.photo is String) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ImageShowPage(imageUrl: viewModel.userModel.photo!),
                    ));
              }
            },
            child: ProfilePhoto(
              photoSize: 70,
              url: viewModel.userModel.photo,
            ),
          ),

          // sizedbox
          if (viewModel.isProfileOwner) 10.h,

          // edit button
          if (viewModel.isProfileOwner)
            InkWell(
              onTap: () => viewModel.changeProfilePhoto(context),
              child: IntrinsicWidth(
                child: Container(
                  padding: EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                  decoration: BoxDecoration(
                    color: AppColors.logoColor,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Center(
                    child: SuffaText(
                      title: "Değiştir",
                      textFont: TextStyle(
                        color: AppColors.lightColor,
                        fontWeight: FontWeight.bold,
                        fontSize: SuffaSizes.mediumTextSize,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // sizedbox
          30.h,

          // container
          buildProfileOption(
            Icons.person,
            viewModel.userModel.username,
            () => viewModel.updateBio(context, "newusername", "Kullanıcı Adı"),
          ),

          // container
          buildProfileOption(
            Icons.edit,
            viewModel.userModel.about ?? "Henüz hakkında eklenmedi",
            () => viewModel.updateBio(context, "about", "Hakkında"),
          ),

          // container
          buildProfileOption(
            Icons.badge_sharp,
            viewModel.userModel.title ?? "Henüz ünvan eklenmedi",
            () => viewModel.updateBio(context, "title", "Ünvan"),
          ),

          // container
          if (viewModel.isProfileOwner)
            buildProfileOption(
              Icons.password,
              "Şifreyi Güncelle",
              () => viewModel.updateBio(context, "password", "Şifre"),
            ),
        ],
      ),
    );
  }

  Widget buildProfileOption(IconData icon, String text, Function() onTap) {
    return InkWell(
      onTap: () {
        if (viewModel.isProfileOwner) {
          onTap();
        }
      },
      child: Container(
        margin: EdgeInsets.all(10),
        width: double.infinity,
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Center(
          child: Row(
            children: [
              // icon
              Icon(
                icon,
                color: AppColors.lightColor,
                size: 30,
              ),

              // sizedbox
              20.w,

              // text
              Expanded(
                child: SuffaText(
                  title: text,
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  textFont: TextStyle(
                    color: AppColors.lightColor,
                    fontWeight: FontWeight.w500,
                    fontSize: SuffaSizes.bigMediumTextSize,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

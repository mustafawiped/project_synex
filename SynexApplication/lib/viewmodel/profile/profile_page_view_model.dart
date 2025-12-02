import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:suffadaemon/utils/helpers/toasts.dart';
import 'package:synex/core/widgets/helpers/loading.dart';
import 'package:synex/models/User/user_model.dart';
import 'package:synex/pages/profile/widgets/bottom_sheet.dart';
import 'package:synex/resources/message/message_repo.dart';
import 'package:synex/resources/user/update_repo.dart';
import 'package:synex/utils/shareds.dart';

import '../../core/resources/app_colors.dart';

class ProfilePageViewModel extends ChangeNotifier {
  UserUpdateRepo userUpdateRepo = UserUpdateRepo();
  MessageRepo messageRepo = MessageRepo();
  bool loadingState = true;
  bool isProfileOwner = false;

  late UserModel userModel;

  void initComps(UserModel otherUserModel) async {
    String? username = await SharedUtils.getShared();
    if (username == null) return;

    if (username == otherUserModel.username) {
      isProfileOwner = true;
    }
    userModel = otherUserModel;

    loadingState = false;
  }

  void changeProfilePhoto(BuildContext context) async {
    try {
      loadingDialog.show(context);

      final ImagePicker picker = ImagePicker();
      XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      XFile? profilePhoto;

      if (pickedFile == null) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        return;
      }

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 70,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'SYNEX | Resim Düzenleyici',
              toolbarColor: const Color.fromARGB(255, 32, 36, 47),
              toolbarWidgetColor: const Color.fromARGB(255, 220, 220, 220),
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'SYNEX | Resmi Düzenle',
          ),
        ],
      );

      if (croppedFile != null) {
        profilePhoto = XFile(croppedFile.path);
      } else {
        profilePhoto = pickedFile;
      }

      String? url = await messageRepo.uploadPhoto(profilePhoto.path);

      if (url == null) {
        ScreenMessage.showErrorToast(
            context, "Fotoğraf yüklenemedi, lütfen daha sonra tekrar deneyin.");
        return;
      }

      String user = await SharedUtils.getShared() as String;

      bool status = await userUpdateRepo.updateProfilePhoto(user, url);

      Navigator.pop(context);

      if (status) {
        ScreenMessage.showSuccessToast(
            context, "Başarıyla profil fotoğrafın değiştirildi!");

        userModel = UserModel(
            id: userModel.id,
            username: userModel.username,
            email: userModel.email,
            password: userModel.password,
            about: userModel.about,
            photo: url,
            title: userModel.title);
        notifyListeners();
      } else {
        ScreenMessage.showErrorToast(context, "Bir şeyler ters gitti.");
      }
    } catch (e) {
      ScreenMessage.showErrorToast(
          context, "Beklenmeyen hata! lütfen tekrar deneyin. $e");
    }
  }

  void updateBio(BuildContext context, String type, String screenText) async {
    showModalBottomSheet(
      backgroundColor: AppColors.bgColor,
      context: context,
      builder: (context) {
        return ProfilePageEditBottomSheet(editName: screenText);
      },
    ).then(
      (value) async {
        if (value is String) {
          String newValue = "";
          if (type == "newusername") {
            newValue = value.trim().toLowerCase();
            if (newValue.length < 3 || newValue.length > 25) {
              ScreenMessage.showErrorToast(context,
                  "Kullanıcı adı minimum 3 maksimum 25 karakter olabilir.");
              return;
            }
          } else if (type == "about") {
            newValue = value.trim();
            if (newValue.length < 3 || newValue.length > 300) {
              ScreenMessage.showErrorToast(context,
                  "Hakkında minimum 3 maksimum 300 karakter olabilir.");
              return;
            }
          } else if (type == "title") {
            newValue = value.trim();
            if (newValue.isEmpty || newValue.length > 300) {
              ScreenMessage.showErrorToast(
                  context, "Ünvan minimum 1 maksimum 300 karakter olabilir.");
              return;
            }
          } else if (type == "password") {
            newValue = value.trim();
            if (newValue.isEmpty || newValue.length > 30) {
              ScreenMessage.showErrorToast(
                  context, "Şifre minimum 1 maksimum 30 karakter olabilir.");
              return;
            }
          }
          loadingDialog.show(context);

          dynamic response = await userUpdateRepo.updateBio(
              userModel.username, type, newValue);

          Navigator.pop(context);

          if (response == null || response is bool) {
            ScreenMessage.showErrorToast(
                context, "Beklenmeyen bir hata oluştu, işlem başarısız.");
          } else {
            if (response[0]) {
              ScreenMessage.showSuccessToast(
                  context, "Başarıyla $screenText güncellendi.");

              switch (type) {
                case "newusername":
                  await SharedUtils.addOrUpdateShared(newValue);
                  userModel = UserModel(
                      id: userModel.id,
                      username: newValue,
                      email: userModel.email,
                      password: userModel.password,
                      about: userModel.about,
                      photo: userModel.photo,
                      title: userModel.title);
                  break;
                case "about":
                  userModel = UserModel(
                      id: userModel.id,
                      username: userModel.username,
                      email: userModel.email,
                      password: userModel.password,
                      about: newValue,
                      photo: userModel.photo,
                      title: userModel.title);
                  break;
                case "title":
                  userModel = UserModel(
                      id: userModel.id,
                      username: userModel.username,
                      email: userModel.email,
                      password: userModel.password,
                      about: userModel.about,
                      photo: userModel.photo,
                      title: newValue);
                  break;
                case "password":
                  userModel = UserModel(
                      id: userModel.id,
                      username: userModel.username,
                      email: userModel.email,
                      password: newValue,
                      about: userModel.about,
                      photo: userModel.photo,
                      title: userModel.title);
                  break;
                default:
                  break;
              }

              notifyListeners();
            } else {
              ScreenMessage.showSuccessToast(context, "HATA! ${response[1]}");
            }
          }
        }
      },
    );
  }
}

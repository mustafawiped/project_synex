import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:suffadaemon/utils/utils.dart';
import 'package:synex/models/Conversations/conversation_model.dart';
import 'package:synex/models/Message/message_model.dart';
import 'package:synex/models/User/user_model.dart';
import 'package:synex/network/hubs/message_hub.dart';
import 'package:synex/pages/profile/profile_page.dart';
import 'package:synex/resources/conversations/conversation_repo.dart';
import 'package:synex/resources/message/message_repo.dart';
import 'package:synex/resources/user/user_repo.dart';
import 'package:synex/utils/shareds.dart';

import '../../core/widgets/helpers/loading.dart';
import '../../resources/notification/notification_repo.dart';

class ChatPageViewModel extends ChangeNotifier {
  MessageRepo messageRepo = MessageRepo();
  ConversationRepo conversationRepo = ConversationRepo();
  NotificationRepo notificationRepo = NotificationRepo();
  UserRepo userRepo = UserRepo();
  bool pageLoading = true;

  ScrollController msgListController = ScrollController();

  TextEditingController msgController = TextEditingController();
  FocusNode msgFocusNode = FocusNode();

  bool isEmojiVisible = false;

  List<MessageModel> messageList = [];
  int loadedCount = 25;

  int? conversationId;

  late MessageHub messageHub;

  void changeEmojiVisibility(BuildContext context) {
    if (isEmojiVisible) {
      FocusScope.of(context).requestFocus(msgFocusNode);
    } else {
      msgFocusNode.unfocus();
    }
    isEmojiVisible = !isEmojiVisible;
    notifyListeners();
  }

  void scrollConfig() {
    if (msgListController.position.pixels ==
        msgListController.position.maxScrollExtent) {
      loadOlderMessages();
    }
  }

  Future<void> initComps(BuildContext context, int user1Id, int user2Id) async {
    var conversationResponse =
        await conversationRepo.getOrCreateConversations(user1Id, user2Id);

    if (conversationResponse is ConversationModel) {
      var response = await messageRepo.getChatMessages(conversationResponse.id);

      if (response is List<MessageModel>) {
        messageList = response;
      } else {
        print("messageResponse: ${response.toString()}");
      }
    } else {
      ScreenMessage.showErrorToast(context,
          "Sohbet oluşturulamadı, internet bağlantınızı kontrol edin.");
      print("conversationResponse: ${conversationResponse.toString()}");
      return;
    }

    conversationId = conversationResponse.id;

    msgListController.addListener(scrollConfig);
    messageHub = MessageHub(user1Id, user2Id, conversationResponse.id);

    pageLoading = false;
    notifyListeners();
  }

  void screenMessages(List<MessageModel> messages) {
    messageList = messages;
    notifyListeners();
  }

  void loadOlderMessages() {
    if (loadedCount >= messageList.length) return;

    loadedCount += 20;

    if (loadedCount > messageList.length) {
      loadedCount = messageList.length;
    }
    notifyListeners();
  }

  Future<void> sendPhotoMessage(
      BuildContext context, int thisUserId, int otherUserId) async {
    try {
      loadingDialog.show(context);

      final ImagePicker picker = ImagePicker();
      XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      XFile? photo;

      if (pickedFile == null) {
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
        photo = XFile(croppedFile.path);
      } else {
        photo = pickedFile;
      }

      String? url = await messageRepo.uploadPhoto(photo.path);

      Navigator.pop(context);

      if (url == null) {
        ScreenMessage.showErrorToast(context, "Resim yüklenemedi...");
        return;
      }

      print("yüklenen resim: $url");

      Future.delayed(
        Duration(milliseconds: 500),
        () {
          messageHub.sendMessage(
            MessageModel(
              senderId: thisUserId,
              receiverId: otherUserId,
              content: url,
              conversationId: conversationId!,
              wasItSeen: false,
              id: 0,
              createdAt: DateTime.now(),
              messageType: MessageType.image,
            ),
          );
          sendNotification(context, otherUserId, "Bir fotoğraf gönderdi.");
        },
      );
    } catch (e) {
      print("ChatPageViewModel | sendPhotoMessage | TRY-CATCH | hata: $e");
    }
  }

  Future<void> goToUserProfile(BuildContext context, String username) async {
    try {
      loadingDialog.show(context);

      UserModel? response = await userRepo.getUserData(username);

      Navigator.pop(context);

      if (response is UserModel) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(userModel: response),
          ),
        );
      } else {
        ScreenMessage.showErrorToast(
            context, "Kullanıcıya ait veriler bulunamadı, bir hata oluştu.");
      }
    } catch (e) {
      ScreenMessage.showErrorToast(
          context, "Bir şeyler ters gitti, daha sonra tekrar deneyin.");
      print("ChatPageViewModel | goToUserProfile | TRY-CATCH | Hata: $e");
    }
  }

  Future<void> sendNotification(
      BuildContext context, int otherUserId, String text) async {
    String? thisUsername = await SharedUtils.getShared();
    if (thisUsername == null) return;

    await notificationRepo.sendNotification(
        thisUsername, otherUserId, text, conversationId!);
  }
}

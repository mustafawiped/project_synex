import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:suffadaemon/utils/helpers/toasts.dart';
import 'package:synex/models/Calls/caller_model.dart';
import 'package:synex/models/Stories/story_model_dto.dart';
import 'package:synex/models/User/user_model.dart';
import 'package:synex/network/hubs/active_calls_hub.dart';
import 'package:synex/network/hubs/conversation_hub.dart';
import 'package:synex/pages/peoples/people_page.dart';
import 'package:synex/pages/story/add_story_page.dart';
import 'package:synex/pages/story/show_story_page.dart';
import 'package:synex/resources/calls/calls_repo.dart';
import 'package:synex/resources/conversations/conversation_repo.dart';
import 'package:synex/resources/message/message_repo.dart';
import 'package:synex/resources/notification/notification_repo.dart';
import 'package:synex/resources/story/story_repo.dart';
import '../../core/widgets/helpers/loading.dart';
import '../../models/Conversations/conversation_dto_model.dart';
import '../../pages/profile/profile_page.dart';
import '../../resources/user/user_repo.dart';
import '../../utils/shareds.dart';

class HomePageViewModel extends ChangeNotifier {
  UserRepo userRepo = UserRepo();
  CallsRepo callsRepo = CallsRepo();
  StoryRepo storyRepo = StoryRepo();
  ConversationRepo conversationRepo = ConversationRepo();
  NotificationRepo notificationRepo = NotificationRepo();
  MessageRepo messageRepo = MessageRepo();

  bool pageLoading = true;

  int pageIndex = 0;

  UserModel? userData;

  List<ConversationDtoModel> conversationList = [];

  late ConversationHub conversationHub;

  CallerModel? caller;
  ActiveCallsHub? activeCallsHub;

  PageController pageController = PageController();

  List<CallerModel> callerList = [];

  List<StoryModelDto> storyList = [];

  StoryModelDto? thisUserStory;

  bool isChangeablePage = true;

  TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();

  Future<void> initComps(BuildContext context) async {
    try {
      String username = await SharedUtils.getShared() as String;

      var value = await userRepo.getUserData(username);
      if (value == null) {
        ScreenMessage.showErrorToast(context, "Hesap bilgileri alınamadı.");
        return;
      }
      userData = value;

      var response = await conversationRepo.getAllConversations(value.id);

      conversationHub = ConversationHub(value.id);

      if (response == null) {
        ScreenMessage.showErrorToast(context, "Mesaj geçmişi yüklenemedi...");
      } else {
        pageLoading = false;
        conversationList = response;
        notifyListeners();
      }
    } catch (e) {
      ScreenMessage.showErrorToast(context,
          "Uygulama açılırken bir sorunla karşılaştı, lütfen tekrar deneyiniz.");
      print("Hata: HomePage / initComps / try-catch / hata: $e");
    }
  }

  Future<void> changePageIndex(BuildContext context, int index) async {
    if (pageLoading || pageIndex == index) return;

    if (pageIndex == 1 && index != pageIndex && activeCallsHub != null) {
      await activeCallsHub!.stopConnection();
    }

    if (index == 0) {
      var response = await conversationRepo.getAllConversations(userData!.id);

      if (response == null) {
        ScreenMessage.showErrorToast(context, "Mesaj geçmişi yüklenemedi...");
      } else {
        conversationList = response;
      }
      conversationHub = ConversationHub(userData!.id);
    } else if (pageIndex == 0 && index != 0) {
      conversationHub.stopConnection();
    }

    if (pageIndex != 1 && index == 1) {
      activeCallsHub = ActiveCallsHub(userData!.id);
    }

    if (index == 2) {
      getStories(context);
    }

    pageIndex = index;
    pageController.jumpToPage(index);
    if (index == 1) {
      callerControl();
    }
  }

  void updateUserData(UserModel user) {
    userData = user;
  }

  void goPeopleScreen(BuildContext context) {
    if (userData is UserModel) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PeoplePage(userId: userData!.id, pageIndex: pageIndex),
        ),
      ).then(
        (value) {
          if (pageIndex == 1) {
            afterCall();
          }
        },
      );
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

  Future<void> callerControl() async {
    caller = await callsRepo.getCall(userData!.id);
    List<CallerModel>? newCallerListData =
        await callsRepo.getCallHistory(userData!.id);

    if (newCallerListData != null) {
      callerList = newCallerListData;
    }
    notifyListeners();
  }

  Future<void> afterCall() async {
    try {
      caller = null;

      List<CallerModel>? newCallerListData =
          await callsRepo.getCallHistory(userData!.id);

      if (newCallerListData != null) {
        callerList = newCallerListData;
      }
      notifyListeners();
    } catch (e) {
      print("HomePageViewModel | afterCall | TRY-CATCH | Hata: $e");
    }
  }

  Future<void> sendNotification(BuildContext context, int otherUserId) async {
    String? thisUsername = await SharedUtils.getShared();
    if (thisUsername == null) return;

    await notificationRepo.sendNotification("$thisUsername Seni Arıyor!",
        otherUserId, "Aramaya cevap verebilmek için tıklayın.", -1);
  }

  Future<void> getStories(BuildContext context) async {
    try {
      List<StoryModelDto>? newStoryList = await storyRepo.getAllStory();

      if (newStoryList != null) {
        thisUserStory = newStoryList
            .where((element) => element.userId == userData!.id)
            .firstOrNull;

        if (thisUserStory != null) {
          newStoryList.remove(thisUserStory);
        }

        newStoryList.sort((a, b) => (b.latestCreatedAt ?? DateTime(1970))
            .compareTo(a.latestCreatedAt ?? DateTime(1970)));

        storyList = newStoryList;
        notifyListeners();
      }
    } catch (e) {
      print("HomePageViewModel | getStories | TRY-CATCH | Hata: $e");
    }
  }

  Future<void> addStoryPart1(BuildContext context) async {
    loadingDialog.show(context);

    final ImagePicker picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    XFile? profilePhoto;

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
      profilePhoto = XFile(croppedFile.path);
    } else {
      profilePhoto = pickedFile;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddStoryPage(userModel: userData!, photoPath: profilePhoto!.path),
      ),
    ).then(
      (value) async {
        addStoryPart2(context, value, profilePhoto!.path);
      },
    );
  }

  Future<void> addStoryPart2(
      BuildContext context, var value, String photoPath) async {
    if (value == null) return;

    String? url = await messageRepo.uploadPhoto(photoPath);

    if (url != null) {
      bool status = await storyRepo.addStory(userData!.id, url, value[1] ?? "");

      Navigator.pop(context);

      if (status) {
        ScreenMessage.showSuccessToast(context, "Başarıyla hikaye eklendi.");
        if (pageIndex == 2) getStories(context);
      } else {
        ScreenMessage.showErrorToast(
            context, "Hikaye eklenirken sorun oluştu.");
      }
    } else {
      Navigator.pop(context);
      ScreenMessage.showErrorToast(
          context, "Bir şeyler ters gitti, işlem başarısız.");
    }
  }

  void seeOtherUserStories(BuildContext context, StoryModelDto storyModelDto) {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShowStoryPage(storyModelDto: storyModelDto),
        ),
      ).then(
        (value) async {
          loadingDialog.show(context);

          bool status = await storyRepo.markStoriesAsSeen(
              storyModelDto.userId, userData!.id);

          Navigator.pop(context);

          if (status) {
            getStories(context);
          } else {
            print("hata: status false döndü. seeOtherUserStories");
          }
        },
      );
    } catch (e) {
      print("HomePageViewModel | seeOtherUserStories | TRY-CATCH | Hata: $e");
    }
  }
}

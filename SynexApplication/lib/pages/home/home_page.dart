import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suffadaemon/components/components.dart';
import 'package:suffadaemon/utils/utils.dart';
import 'package:synex/core/resources/app_assets.dart';
import 'package:synex/core/resources/app_colors.dart';
import 'package:synex/core/widgets/widgets/profile_photo.dart';
import 'package:synex/models/Calls/active_call_model.dart';
import 'package:synex/models/Calls/caller_model.dart';
import 'package:synex/models/Conversations/conversation_dto_model.dart';
import 'package:synex/models/Message/message_model.dart';
import 'package:synex/models/Stories/story_model_dto.dart';
import 'package:synex/models/User/user_dto_model.dart';
import 'package:synex/models/User/user_model.dart';
import 'package:synex/network/hubs/active_calls_hub.dart';
import 'package:synex/network/hubs/conversation_hub.dart';
import 'package:synex/pages/chat/chat_page.dart';
import 'package:synex/pages/profile/profile_page.dart';
import 'package:synex/pages/story/show_story_page.dart';
import 'package:synex/pages/voice_chat/voice_chat_page.dart';
import 'package:synex/utils/date.dart';
import 'package:synex/utils/extensions.dart';
import 'package:synex/viewmodel/home/home_page_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static String routeName = "home_page_route_name";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageViewModel viewModel = HomePageViewModel();
  bool searchState = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      viewModel.initComps(context).then((value) {
        setState(() {});
        // Bildirime tıklayıp uygulama arka plandayken açılırsa
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          if (viewModel.pageLoading) {
            return print("Sayfa yüklenirken geldiği için bisi yapmadı.");
          }

          if (message.data["conversationId"] != null) {
            if (message.data["conversationId"].toString() == "-1") {
              viewModel.changePageIndex(context, 1).then((value) {
                setState(() {});
              });
            } else {
              ConversationDtoModel data = viewModel.conversationList.firstWhere(
                (element) =>
                    element.id.toString() ==
                    message.data["conversationId"].toString(),
              );

              UserDtoModel userDtoModel = UserDtoModel(
                  id: viewModel.userData!.id == data.user1Id
                      ? data.user2Id
                      : data.user1Id,
                  username: data.otherUsername,
                  photo: data.otherProfile);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    otherUser: userDtoModel,
                    thisUserId: viewModel.userData!.id == data.user1Id
                        ? data.user1Id
                        : data.user2Id,
                  ),
                ),
              );
            }
          }
          print(
              "Uygulama arkada açıkken bildirime bastı. ${message.toString()}");
        });

        FirebaseMessaging.instance.getInitialMessage().then((message) {
          if (message == null) return;
          if (viewModel.pageLoading) {
            return print("Sayfa yüklenirken geldiği için bisi yapmadı.");
          }

          if (message.data["conversationId"] != null) {
            if (message.data["conversationId"].toString() == "-1") {
              viewModel.changePageIndex(context, 1).then((value) {
                setState(() {});
              });
            } else {
              ConversationDtoModel data = viewModel.conversationList.firstWhere(
                (element) =>
                    element.id.toString() ==
                    message.data["conversationId"].toString(),
              );

              UserDtoModel userDtoModel = UserDtoModel(
                  id: viewModel.userData!.id == data.user1Id
                      ? data.user2Id
                      : data.user1Id,
                  username: data.otherUsername,
                  photo: data.otherProfile);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    otherUser: userDtoModel,
                    thisUserId: viewModel.userData!.id == data.user1Id
                        ? data.user1Id
                        : data.user2Id,
                  ),
                ),
              );
            }
          }
          print(
              "Uygulama tamamen kapalıyken bildirime bastı. ${message.toString()}");
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.conversationHub.stopConnection();
    viewModel.pageController.dispose();
    viewModel.searchController.dispose();
    viewModel.focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildTopMenuAppBar(),
      body: ChangeNotifierProvider<HomePageViewModel>(
        create: (context) => viewModel,
        builder: (context, child) {
          return Consumer<HomePageViewModel>(
            builder: (context, value, child) {
              if (viewModel.pageLoading) {
                return buildLoading();
              } else {
                return buildScreen();
              }
            },
          );
        },
      ),
      bottomNavigationBar: buildNavBar(),
      floatingActionButton: buildFloatButtons(),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.primaryColor,
      ),
    );
  }

  Widget buildScreen() {
    return SafeArea(
      child: PageView.builder(
        physics: NeverScrollableScrollPhysics(),
        controller: viewModel.pageController,
        itemCount: 3,
        onPageChanged: (value) {},
        itemBuilder: (context, index) {
          if (index == 0) {
            return buildConversationScreen();
          } else if (index == 1) {
            return buildCallsScreen();
          } else {
            return buildStorysScreen();
          }
        },
      ),
    );
  }

  Widget buildStorysScreen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // sizedbox
          20.h,

          // your story
          buildYourStory(),

          // sizedbox
          20.h,

          // info text
          SuffaText(
            title: "Diğer Kullanıcıların Hikayeleri",
            textAlign: TextAlign.start,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 20.0),
            textFont: TextStyle(
              color: AppColors.lightColor,
              fontSize: SuffaSizes.bigMediumTextSize,
              fontWeight: FontWeight.w600,
            ),
          ),

          // sizedbox
          10.h,

          // info
          if (viewModel.storyList.isEmpty)
            SuffaText(
              title: "Henüz herhangi bir kullanıcı hikaye eklemedi.",
              textAlign: TextAlign.start,
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 30.0),
              textFont: TextStyle(
                color: AppColors.lightGray,
                fontSize: SuffaSizes.xMediumTextSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          // list
          if (viewModel.storyList.isNotEmpty)
            Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: viewModel.storyList.length > 20
                    ? 20
                    : viewModel.storyList.length,
                itemBuilder: (context, index) {
                  StoryModelDto story = viewModel.storyList[index];

                  bool isContainsDontSee = story.storys.any(
                    (element) =>
                        !element.seenBy.contains(viewModel.userData!.id),
                  );

                  return GestureDetector(
                    onTap: () {
                      viewModel.seeOtherUserStories(context, story);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IntrinsicWidth(
                          child: ProfilePhoto(
                            photoSize: 32,
                            url: story.photoUrl,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SuffaText(
                                title: story.username,
                                maxLines: 1,
                                textAlign: TextAlign.start,
                                textFont: TextStyle(
                                  color: AppColors.lightColor,
                                  fontSize: SuffaSizes.bigMediumTextSize,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SuffaText(
                                title: isContainsDontSee
                                    ? "Yeni hikaye ekledi!"
                                    : "Görüldü",
                                textAlign: TextAlign.start,
                                textFont: TextStyle(
                                  color: isContainsDontSee
                                      ? AppColors.successColor
                                      : AppColors.lightGray,
                                  fontSize: SuffaSizes.bigSmallText,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
        ],
      ),
    );
  }

  Widget buildYourStory() {
    bool isStoryContains = viewModel.thisUserStory != null;
    return GestureDetector(
      onTap: () {
        if (viewModel.thisUserStory != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ShowStoryPage(storyModelDto: viewModel.thisUserStory!),
              ));
        }
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IntrinsicWidth(
              child: ProfilePhoto(
                photoSize: 32,
                url: viewModel.userData!.photo,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SuffaText(
                    title: isStoryContains
                        ? "Hikayen"
                        : "Henüz hikaye eklememişsin",
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    textFont: TextStyle(
                      color: AppColors.lightColor,
                      fontSize: SuffaSizes.bigMediumTextSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SuffaText(
                    title: isStoryContains
                        ? "Hikayeni görüntülemek için buraya tıkla."
                        : "Hikaye eklemek için sol alttaki ikona tıklayabilirsin.",
                    textAlign: TextAlign.start,
                    textFont: TextStyle(
                      color: AppColors.lightGray,
                      fontSize: SuffaSizes.bigSmallText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCallsScreen() {
    return ChangeNotifierProvider<ActiveCallsHub>(
      create: (context) => viewModel.activeCallsHub!,
      builder: (context, child) {
        return Consumer<ActiveCallsHub>(
          builder: (context, activeCallsHub, child) {
            if (activeCallsHub.callerModelData != null) {
              viewModel.caller = activeCallsHub.callerModelData is String
                  ? null
                  : activeCallsHub.callerModelData;
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  if (viewModel.caller is CallerModel)
                    // sizedbox
                    20.h,

                  if (viewModel.caller is CallerModel)
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ProfilePhoto(
                            photoSize: 21,
                            url: viewModel.caller!.callerPhotoUrl,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SuffaText(
                                  title: viewModel.caller!.callerUsername,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  padding: EdgeInsets.only(left: 20.0),
                                  textFont: TextStyle(
                                    color: AppColors.lightColor,
                                    fontSize: SuffaSizes.mediumTextSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SuffaText(
                                  title: "Seni arıyor...",
                                  textAlign: TextAlign.start,
                                  padding: EdgeInsets.only(left: 20.0),
                                  textFont: TextStyle(
                                    color: AppColors.lightGray,
                                    fontSize: SuffaSizes.mediumTextSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Tooltip(
                                message: "Cevapla",
                                child: IconButton(
                                  onPressed: () {
                                    String roomId = "";
                                    if (viewModel.userData!.id >
                                        viewModel.caller!.call.callerId) {
                                      roomId =
                                          "Synex-VoiceRoom_${viewModel.userData!.id}-${viewModel.caller!.call.callerId}";
                                    } else {
                                      roomId =
                                          "Synex-VoiceRoom_${viewModel.caller!.call.callerId}-${viewModel.userData!.id}";
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VoiceChatPage(
                                          profilePhotoUrl:
                                              viewModel.caller!.callerPhotoUrl,
                                          roomId: roomId,
                                          thisUserId: viewModel.userData!.id,
                                          otherUserId:
                                              viewModel.caller!.call.callerId,
                                          isAnswered: true,
                                        ),
                                      ),
                                    ).then(
                                      (value) {
                                        activeCallsHub.callerModelData = null;
                                        viewModel.afterCall();
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    Icons.call,
                                    color: AppColors.successColor,
                                  ),
                                ),
                              ),
                              Tooltip(
                                message: "Reddet",
                                child: IconButton(
                                  onPressed: () async {
                                    String roomId = "";
                                    if (viewModel.userData!.id >
                                        viewModel.caller!.call.callerId) {
                                      roomId =
                                          "Synex-VoiceRoom_${viewModel.userData!.id}-${viewModel.caller!.call.callerId}";
                                    } else {
                                      roomId =
                                          "Synex-VoiceRoom_${viewModel.caller!.call.callerId}-${viewModel.userData!.id}";
                                    }
                                    if (viewModel.activeCallsHub != null) {
                                      await viewModel.activeCallsHub!
                                          .cancelRinging(roomId);
                                      viewModel.afterCall();
                                    }
                                  },
                                  icon: Icon(
                                    Icons.call_end,
                                    color: AppColors.deleteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          10.w,
                        ],
                      ),
                    ),

                  // sizedbox
                  20.h,

                  // header
                  SuffaText(
                    title: "Arama Geçmişi",
                    textAlign: TextAlign.start,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20.0),
                    textFont: TextStyle(
                      color: AppColors.lightColor,
                      fontSize: SuffaSizes.bigMediumTextSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  // sizedbox
                  20.h,

                  // call history
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: viewModel.callerList.length > 20
                          ? 20
                          : viewModel.callerList.length,
                      itemBuilder: (context, index) {
                        CallerModel callData = viewModel.callerList[index];

                        String infoString = callData.call.status ==
                                CallStatus.ringing
                            ? callData.call.callerId == viewModel.userData!.id
                                ? "Arama Cevaplanmadı - ${DateHelper.formatMessageDate(callData.call.startedAt)}"
                                : "Cevapsız Çağrı - ${DateHelper.formatMessageDate(callData.call.startedAt)}"
                            : "Görüşme gerçekleşti - ${DateHelper.formatMessageDate(callData.call.startedAt)}";

                        Color infoColor = callData.call.status ==
                                CallStatus.ringing
                            ? callData.call.callerId == viewModel.userData!.id
                                ? AppColors.darkPrimary
                                : AppColors.deleteColor
                            : AppColors.successColor;

                        int otherUserId =
                            callData.call.callerId == viewModel.userData!.id
                                ? callData.call.receiverId
                                : callData.call.callerId;

                        return Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 10.0),
                          decoration: BoxDecoration(
                            color: AppColors.dimColor.withAlpha(100),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  viewModel.goToUserProfile(
                                      context, callData.callerUsername);
                                },
                                child: ProfilePhoto(
                                  photoSize: 21,
                                  url: callData.callerPhotoUrl,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SuffaText(
                                      title: callData.callerUsername,
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      padding: EdgeInsets.only(left: 20.0),
                                      textFont: TextStyle(
                                        color: AppColors.lightColor,
                                        fontSize: SuffaSizes.mediumTextSize,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SuffaText(
                                      title: infoString,
                                      textAlign: TextAlign.start,
                                      padding: EdgeInsets.only(left: 20.0),
                                      textFont: TextStyle(
                                        color: infoColor,
                                        fontSize: SuffaSizes.bigSmallText,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Tooltip(
                                    message: "Tekrar ara",
                                    child: IconButton(
                                      onPressed: () {
                                        if (viewModel.caller is CallerModel) {
                                          ScreenMessage.showErrorToast(context,
                                              "Yeni arama yapmadan önce mevcut aramayı cevaplayın.");
                                          return;
                                        }
                                        String roomId = "";
                                        if (viewModel.userData!.id >
                                            otherUserId) {
                                          roomId =
                                              "Synex-VoiceRoom_${viewModel.userData!.id}-$otherUserId";
                                        } else {
                                          roomId =
                                              "Synex-VoiceRoom_$otherUserId-${viewModel.userData!.id}";
                                        }
                                        viewModel.sendNotification(
                                            context, otherUserId);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => VoiceChatPage(
                                              profilePhotoUrl:
                                                  callData.callerPhotoUrl,
                                              roomId: roomId,
                                              thisUserId:
                                                  viewModel.userData!.id,
                                              otherUserId: otherUserId,
                                            ),
                                          ),
                                        ).then(
                                          (value) {
                                            activeCallsHub.callerModelData =
                                                null;
                                            viewModel.afterCall();
                                          },
                                        );
                                      },
                                      icon: Icon(
                                        Icons.call,
                                        color: AppColors.lightColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              10.w,
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget buildConversationScreen() {
    return SingleChildScrollView(
      child: Center(
        child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            child: ChangeNotifierProvider<ConversationHub>(
              create: (context) => viewModel.conversationHub,
              builder: (context, child) {
                return Consumer<ConversationHub>(
                  builder: (context, conversationProvider, child) {
                    if (conversationProvider.newConversationData != null) {
                      final index = viewModel.conversationList.indexWhere((m) =>
                          m.id == conversationProvider.newConversationData!.id);
                      if (index != -1) {
                        viewModel.conversationList[index] =
                            conversationProvider.newConversationData!;
                      } else {
                        viewModel.conversationList
                            .add(conversationProvider.newConversationData!);
                      }
                    }

                    viewModel.conversationList.sort((a, b) {
                      if (a.lastMessage == null && b.lastMessage == null) {
                        return 0;
                      }
                      if (a.lastMessage == null) return -1;
                      if (b.lastMessage == null) return 1;
                      return b.lastMessage!.createdAt
                          .compareTo(a.lastMessage!.createdAt);
                    });

                    List<ConversationDtoModel> screenList = [];
                    screenList.addAll(viewModel.conversationList);

                    if (searchState) {
                      String searchText = viewModel.searchController.text;
                      screenList = screenList
                          .where(
                            (element) => element.otherUsername
                                .contains(searchText.trim().toLowerCase()),
                          )
                          .toList();
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: screenList.length,
                      itemBuilder: (context, index) {
                        ConversationDtoModel data = screenList[index];
                        int unreadCount = viewModel.userData!.id == data.user1Id
                            ? data.unreadCountUser1
                            : data.unreadCountUser2;

                        return GestureDetector(
                          onTap: () {
                            UserDtoModel userDtoModel = UserDtoModel(
                                id: viewModel.userData!.id == data.user1Id
                                    ? data.user2Id
                                    : data.user1Id,
                                username: data.otherUsername,
                                photo: data.otherProfile);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  otherUser: userDtoModel,
                                  thisUserId:
                                      viewModel.userData!.id == data.user1Id
                                          ? data.user1Id
                                          : data.user2Id,
                                ),
                              ),
                            );
                          },
                          child: SizedBox(
                            height: 70,
                            child: Row(
                              children: [
                                // photo
                                GestureDetector(
                                  onTap: () => viewModel.goToUserProfile(
                                      context, data.otherUsername),
                                  child: ProfilePhoto(
                                    photoSize: 16,
                                    url: data.otherProfile,
                                  ),
                                ),

                                // sizedbox
                                5.w,

                                // name and last msg
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: SuffaText(
                                              title: data.otherUsername,
                                              maxLines: 1,
                                              textAlign: TextAlign.start,
                                              textFont: TextStyle(
                                                color: AppColors.lightColor,
                                                fontSize: SuffaSizes
                                                    .bigMediumTextSize,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          5.w,
                                          SuffaText(
                                            title: DateHelper.formatMessageDate(
                                                data.lastMessage != null
                                                    ? data
                                                        .lastMessage!.createdAt
                                                    : data.updatedAt!),
                                            maxLines: 1,
                                            textFont: TextStyle(
                                              color: AppColors.lightGray,
                                              fontSize:
                                                  SuffaSizes.xMediumTextSize,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                if (data.lastMessage != null)
                                                  if (data.lastMessage!
                                                          .messageType ==
                                                      MessageType.image)
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.photo,
                                                          size: 16,
                                                          color: AppColors
                                                              .lightColor,
                                                        ),
                                                        5.w,
                                                      ],
                                                    ),
                                                Expanded(
                                                  child: SuffaText(
                                                    title: data.lastMessage !=
                                                            null
                                                        ? data.lastMessage!
                                                                    .messageType ==
                                                                MessageType
                                                                    .image
                                                            ? "Fotoğraf"
                                                            : data.lastMessage!
                                                                .content
                                                        : "Mesaj Gönder",
                                                    maxLines: 1,
                                                    textAlign: TextAlign.start,
                                                    textFont: TextStyle(
                                                      color:
                                                          AppColors.lightGray,
                                                      fontSize: SuffaSizes
                                                          .bigSmallText,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          5.w,
                                          if (data.lastMessage != null)
                                            if (data.lastMessage!.senderId ==
                                                viewModel.userData!.id)
                                              Icon(
                                                data.lastMessage!.wasItSeen
                                                    ? Icons.done_all
                                                    : Icons.done,
                                                size: 16,
                                                color: AppColors.lightColor,
                                              ),
                                          if (unreadCount > 0)
                                            Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryColor,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Text(
                                                unreadCount > 99
                                                    ? "+99"
                                                    : unreadCount.toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // sizedbox
                                5.w,

                                // date and read status
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            )),
      ),
    );
  }

  PreferredSizeWidget buildTopMenuAppBar() {
    return AppBar(
      backgroundColor: AppColors.secondaryColor,
      elevation: 0,
      titleSpacing: 0,
      title: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (viewModel.userData is UserModel) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfilePage(userModel: viewModel.userData!),
                  ),
                ).then(
                  (value) {
                    if (value is UserModel) {
                      viewModel.updateUserData(value);
                      setState(() {});
                    }
                  },
                );
              } else {
                ScreenMessage.showErrorToast(context,
                    "Profil verileri yüklenemediği için şu anda profile giremezsiniz.");
              }
            },
            child: ProfilePhoto(
              photoSize: 18,
              url: viewModel.pageLoading ? null : viewModel.userData!.photo,
            ),
          ),
          if (!searchState)
            Image.asset(
              AppAssets.app_logo,
              width: 120,
              height: 50,
            ),
          if (searchState)
            Expanded(
              child: TextField(
                controller: viewModel.searchController,
                focusNode: viewModel.focusNode,
                style: const TextStyle(color: Colors.white),
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  setState(() {});
                },
                maxLength: 30,
                decoration: const InputDecoration(
                  hintText: "Ara...",
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  counter: SizedBox(),
                ),
                maxLines: 1,
              ),
            ),
        ],
      ),
      actions: [
        if (viewModel.pageIndex == 0)
          IconButton(
            onPressed: () {
              if (!searchState) {
                viewModel.focusNode.requestFocus();
              } else {
                viewModel.focusNode.unfocus();
              }
              setState(() {
                searchState = !searchState;
              });
            },
            icon: Icon(
              searchState ? Icons.close : Icons.search,
              color: AppColors.lightColor,
              size: 25,
            ),
          ),
      ],
    );
  }

  Widget buildNavBar() {
    return BottomNavigationBar(
      backgroundColor: AppColors.secondaryColor,
      currentIndex: viewModel.pageIndex,
      onTap: (value) async {
        await viewModel.changePageIndex(context, value);
        setState(() {});
      },
      elevation: 1,
      selectedItemColor: AppColors.lightColor,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
      unselectedItemColor: AppColors.lightGray,
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w700,
      ),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.chat_bubble_2),
          label: "Sohbet",
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.phone),
          label: "Aramalar",
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.photo_on_rectangle),
          label: "Hikayeler",
        ),
      ],
    );
  }

  Widget buildFloatButtons() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "storyFab",
            backgroundColor: AppColors.dimColor.withAlpha(100),
            child: const Icon(
              Icons.camera_alt_outlined,
              color: AppColors.lightColor,
              size: 28,
            ),
            onPressed: () => viewModel.addStoryPart1(context),
          ),
          16.h,
          if (viewModel.pageIndex != 2)
            FloatingActionButton(
              heroTag: "chatFab",
              backgroundColor: AppColors.secondaryColor,
              child: Icon(
                viewModel.pageIndex == 0 ? Icons.edit : Icons.call,
                color: AppColors.lightColor,
                size: 28,
              ),
              onPressed: () {
                if (viewModel.pageIndex == 1 &&
                    viewModel.caller is CallerModel) {
                  ScreenMessage.showErrorToast(context,
                      "Yeni arama yapmadan önce mevcut aramayı cevaplayın.");
                  return;
                }

                viewModel.goPeopleScreen(context);
              },
            ),
        ],
      ),
    );
  }
}

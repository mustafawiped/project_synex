import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suffadaemon/components/components.dart';
import 'package:suffadaemon/utils/utils.dart';
import 'package:synex/models/User/user_dto_model.dart';
import 'package:synex/models/User/user_model.dart';
import 'package:synex/pages/chat/chat_page.dart';
import 'package:synex/pages/voice_chat/voice_chat_page.dart';
import 'package:synex/utils/extensions.dart';
import 'package:synex/viewmodel/people/people_page_view_model.dart';
import '../../core/resources/app_colors.dart';
import '../../core/widgets/widgets/profile_photo.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({super.key, required this.userId, required this.pageIndex});

  final int userId;
  final int pageIndex;

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  PeoplePageViewModel viewModel = PeoplePageViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.scrollController.addListener(viewModel.loadMore);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      viewModel.initComps(context);
    });
  }

  @override
  void dispose() {
    super.dispose();

    viewModel.scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.lightColor,
          ),
        ),
        title: SuffaText(
          title: widget.pageIndex == 1 ? "Yeni Arama" : "Yeni Sohbet Oluştur",
          textFont: TextStyle(
            color: AppColors.lightColor,
            fontSize: SuffaSizes.xxLargeTextSize,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: ChangeNotifierProvider<PeoplePageViewModel>(
        create: (context) => viewModel,
        builder: (context, child) {
          return Consumer<PeoplePageViewModel>(
            builder: (context, value, child) {
              if (viewModel.pageLoading) {
                return buildLoading();
              } else {
                return buildUI();
              }
            },
          );
        },
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.primaryColor,
      ),
    );
  }

  Widget buildUI() {
    return SingleChildScrollView(
      controller: viewModel.scrollController,
      child: Column(
        children: [
          // sizedbox
          20.h,

          // info text
          SuffaText(
            title: widget.pageIndex == 1
                ? "Arayacağınız kullanıcıyı seçiniz."
                : "Sohbet başlatmak için bir kullanıcı seçiniz",
            textFont: TextStyle(
              color: AppColors.lightGray,
              fontSize: SuffaSizes.mediumTextSize,
              fontWeight: FontWeight.w600,
            ),
          ),

          // sizedbox
          20.h,

          // user list
          buildUserList(),
        ],
      ),
    );
  }

  Widget buildUserList() {
    List<UserModel> screenList =
        viewModel.userList.take(viewModel.itemsToShow).toList();
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: screenList.length,
        itemBuilder: (context, index) {
          UserModel data = screenList[index];
          return GestureDetector(
            onTap: () {
              if (widget.pageIndex == 0) {
                UserDtoModel userDtoModel = UserDtoModel(
                    id: data.id, username: data.username, photo: data.photo);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      otherUser: userDtoModel,
                      thisUserId: widget.userId,
                    ),
                  ),
                );
              } else {
                String roomId = "";
                if (widget.userId > data.id) {
                  roomId = "Synex-VoiceRoom_${widget.userId}-${data.id}";
                } else {
                  roomId = "Synex-VoiceRoom_${data.id}-${widget.userId}";
                }
                viewModel.sendNotification(context, data.id);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VoiceChatPage(
                        profilePhotoUrl: data.photo,
                        roomId: roomId,
                        thisUserId: widget.userId,
                        otherUserId: data.id,
                      ),
                    ));
              }
            },
            child: Container(
              height: 80,
              margin: EdgeInsets.only(bottom: 5.0),
              decoration: BoxDecoration(
                color: AppColors.dimColor.withAlpha(10),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                children: [
                  // photo
                  ProfilePhoto(
                    photoSize: 20,
                    url: data.photo,
                  ),

                  // sizedbox
                  5.w,

                  // naem and last msg
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SuffaText(
                          title: data.username,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          textFont: TextStyle(
                            color: AppColors.lightColor,
                            fontSize: SuffaSizes.xxLargeTextSize - 2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SuffaText(
                          title: data.about ??
                              "Bu kullanıcı hakkında kısmını doldurmamış.",
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          textFont: TextStyle(
                            color: AppColors.lightGray,
                            fontSize: SuffaSizes.bigSmallText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // sizedbox
                  5.w,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

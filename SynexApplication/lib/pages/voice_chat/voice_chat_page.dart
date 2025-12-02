import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suffadaemon/components/components.dart';
import 'package:suffadaemon/utils/utils.dart';
import 'package:synex/utils/extensions.dart';

import '../../core/resources/app_colors.dart';
import '../../core/widgets/widgets/profile_photo.dart';
import '../../viewmodel/voice_chat/voice_chat_view_model.dart';

class VoiceChatPage extends StatefulWidget {
  const VoiceChatPage(
      {super.key,
      required this.profilePhotoUrl,
      required this.roomId,
      required this.thisUserId,
      required this.otherUserId,
      this.isAnswered});

  final String? profilePhotoUrl;
  final String roomId;
  final int thisUserId;
  final int otherUserId;
  final bool? isAnswered;

  @override
  State<VoiceChatPage> createState() => _VoiceChatPageState();
}

class _VoiceChatPageState extends State<VoiceChatPage> {
  late VoiceChatPageViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = VoiceChatPageViewModel();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      viewModel.initComps(widget.roomId, () => Navigator.pop(context),
          widget.thisUserId, widget.otherUserId);
    });
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VoiceChatPageViewModel>.value(
      value: viewModel,
      child: Consumer<VoiceChatPageViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.secondaryColor,
              elevation: 0,
              titleSpacing: 0,
              leading: IconButton(
                onPressed: () async {
                  await vm.webRTCService.leaveRoom(widget.roomId);
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.lightColor,
                ),
              ),
              title: const SuffaText(
                title: "Sesli Sohbet",
                textFont: TextStyle(
                  color: AppColors.lightColor,
                  fontSize: SuffaSizes.xxLargeTextSize,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // profile photo
                    ProfilePhoto(
                      photoSize: 140,
                      url: widget.profilePhotoUrl,
                    ),

                    10.h,

                    // info text
                    SuffaText(
                      title: vm.webRTCService.isConnected
                          ? vm.userCount > 1
                              ? "Görüşme başladı"
                              : widget.isAnswered != null
                                  ? "Görüşme başladı"
                                  : "Çalıyor..."
                          : "Aranıyor...",
                      textFont: TextStyle(
                        color: vm.webRTCService.isConnected
                            ? AppColors.successColor
                            : AppColors.lightGray,
                        fontSize: SuffaSizes.bigMediumTextSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    30.h,
                    // end call button
                    InkWell(
                      onTap: () async {
                        await vm.webRTCService.leaveRoom(widget.roomId);
                        Navigator.pop(context);
                      },
                      child: IntrinsicWidth(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.deleteColor,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: const Center(
                            child: SuffaText(
                              title: "Aramayı Sonlandır",
                              textFont: TextStyle(
                                color: AppColors.lightColor,
                                fontWeight: FontWeight.bold,
                                fontSize: SuffaSizes.xxLargeTextSize,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

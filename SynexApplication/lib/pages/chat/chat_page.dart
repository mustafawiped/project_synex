import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suffadaemon/components/components.dart';
import 'package:suffadaemon/utils/utils.dart';
import 'package:synex/core/widgets/helpers/popup.dart';
import 'package:synex/models/Message/message_model.dart';
import 'package:synex/models/User/user_dto_model.dart';
import 'package:synex/network/hubs/message_hub.dart';
import 'package:synex/pages/chat/image_show_page.dart';
import 'package:synex/utils/date.dart';
import 'package:synex/utils/extensions.dart';
import 'package:synex/viewmodel/chat/chat_page_view_model.dart';
import '../../core/resources/app_colors.dart';
import '../../core/widgets/widgets/profile_photo.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {super.key, required this.otherUser, required this.thisUserId});

  final UserDtoModel otherUser;
  final int thisUserId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  ChatPageViewModel viewModel = ChatPageViewModel();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      viewModel.initComps(context, widget.thisUserId, widget.otherUser.id);
    });
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.messageHub.stopConnection();
    viewModel.msgController.dispose();
    viewModel.msgListController.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      viewModel.messageHub
          .ensureConnected(widget.thisUserId, widget.otherUser.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: ChangeNotifierProvider<ChatPageViewModel>(
        create: (context) => viewModel,
        builder: (context, child) {
          return Consumer<ChatPageViewModel>(
            builder: (context, value, child) {
              print("loaded: ${viewModel.loadedCount}");
              if (viewModel.pageLoading) {
                return buildLoading();
              } else {
                return buildMessages();
              }
            },
          );
        },
      ),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.secondaryColor,
      surfaceTintColor: AppColors.secondaryColor,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back,
          color: AppColors.lightColor,
        ),
      ),
      elevation: 0,
      titleSpacing: 0,
      title: Row(
        children: [
          GestureDetector(
            onTap: () =>
                viewModel.goToUserProfile(context, widget.otherUser.username),
            child: ProfilePhoto(
              photoSize: 18,
              url: widget.otherUser.photo,
            ),
          ),
          Expanded(
            child: SuffaText(
              title: widget.otherUser.username,
              textAlign: TextAlign.start,
              maxLines: 1,
              textFont: TextStyle(
                color: AppColors.lightColor,
                fontWeight: FontWeight.w500,
                fontSize: SuffaSizes.xxLargeTextSize,
              ),
            ),
          ),
        ],
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

  Widget buildMessages() {
    return ChangeNotifierProvider<MessageHub>(
      create: (context) => viewModel.messageHub,
      builder: (context, child) {
        return Consumer<MessageHub>(
          builder: (context, chatProvider, child) {
            if (chatProvider.seenData != null) {
              final messageId = chatProvider.seenData!['messageId'];
              final seenAt = DateTime.parse(chatProvider.seenData!['seenAt']);
              final index =
                  viewModel.messageList.indexWhere((m) => m.id == messageId);
              if (index != -1) {
                viewModel.messageList[index] =
                    viewModel.messageList[index].copyWith(
                  wasItSeen: true,
                  seenAt: seenAt,
                );
              }
            }

            if (chatProvider.newMessage != null) {
              if (viewModel.messageList
                  .where(
                    (element) => element.id == chatProvider.newMessage!.id,
                  )
                  .isEmpty) {
                viewModel.messageList.add(chatProvider.newMessage!);
              }
            }

            if (chatProvider.deleteMsgId != null) {
              viewModel.messageList.removeWhere(
                  (element) => element.id == chatProvider.deleteMsgId);
            }

            List<MessageModel> visibleMessages = [];

            if (viewModel.messageList.isNotEmpty) {
              final total = viewModel.messageList.length;
              final count = viewModel.loadedCount;

              // listenin son 'count' kadar elemanı
              final start = total - count < 0 ? 0 : total - count;

              visibleMessages = viewModel.messageList.sublist(start, total);

              visibleMessages = visibleMessages.reversed.toList();
            }

            return Column(
              children: [
                // messages
                Expanded(
                  child: ListView.builder(
                    controller: viewModel.msgListController,
                    reverse: true,
                    padding: const EdgeInsets.all(10),
                    itemCount: visibleMessages.length,
                    itemBuilder: (context, index) {
                      final message = visibleMessages[index];
                      final isMe = message.senderId == widget.thisUserId;

                      if (!isMe && message.wasItSeen == false) {
                        Future.delayed(
                          Duration(milliseconds: 500),
                          () {
                            chatProvider.seenMessage(
                                message, widget.thisUserId);
                          },
                        );
                      }

                      return buildMessage(isMe, message, chatProvider);
                    },
                  ),
                ),

                // bottom input
                buildInput(chatProvider),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildMessage(
      bool isMe, MessageModel message, MessageHub chatProvider) {
    Widget messageContent;

    if (message.messageType == MessageType.image) {
      try {
        messageContent = ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: message.content,
            placeholder: (context, url) => Container(
              width: 150,
              height: 150,
              color: Colors.grey.shade200,
              child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            imageBuilder: (context, imageProvider) {
              return FutureBuilder<Size>(
                future: getImageSize(imageProvider),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      width: 150,
                      height: 150,
                      color: Colors.grey.shade200,
                    );
                  }

                  final size = snapshot.data!;
                  final aspectRatio = size.width / size.height;

                  return ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 250,
                      maxHeight: 350,
                    ),
                    child: AspectRatio(
                      aspectRatio: aspectRatio,
                      child: Image(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      } catch (e) {
        messageContent = Text(
          "Gönderilen resim açılamadı",
          style: TextStyle(color: Colors.red),
        );
      }
    } else {
      messageContent = Text(
        message.content,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isMe ? Colors.white : Colors.black,
        ),
      );
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          if (message.messageType == MessageType.image) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImageShowPage(imageUrl: message.content),
              ),
            );
          }
        },
        onLongPress: () {
          AppPopupHelper.showPopup(
            context,
            "Mesajı silmek ister misin?",
            "Üzerine basılı tuttuğunuz mesajı silmek ister misin?",
            "Sil",
            "Vazgeç",
            () {
              chatProvider.deleteMessage(message);
            },
            cancelBtnFunc: () {},
            dismissState: true,
            type: PopupType.question,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: isMe ? Colors.blue : Colors.grey.shade300,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
              bottomRight: isMe ? Radius.zero : const Radius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              messageContent,
              const SizedBox(height: 4),
              IntrinsicWidth(
                child: Row(
                  children: [
                    Text(
                      DateHelper.formatMessageDate(message.createdAt),
                      style: TextStyle(
                        color: isMe ? AppColors.lightColor : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: SuffaSizes.xSmallTextSize,
                      ),
                    ),
                    5.w,
                    if (isMe)
                      Icon(
                        message.wasItSeen ? Icons.done_all : Icons.done,
                        size: 16,
                        color: message.wasItSeen
                            ? AppColors.darkColor
                            : Colors.white,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInput(MessageHub chatProvider) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          SizedBox(
            height: 70,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.dimColor,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      children: [
                        // icons
                        IconButton(
                          onPressed: () =>
                              viewModel.changeEmojiVisibility(context),
                          icon: Icon(
                            viewModel.isEmojiVisible
                                ? Icons.keyboard
                                : Icons.emoji_emotions,
                            color: AppColors.lightColor,
                          ),
                        ),

                        // sizedbox
                        5.w,

                        // input
                        Expanded(
                          child: TextField(
                            controller: viewModel.msgController,
                            minLines: 1,
                            maxLines: 4,
                            focusNode: viewModel.msgFocusNode,
                            cursorColor: AppColors.logoColor,
                            cursorErrorColor: AppColors.deleteColor,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (value) {
                              if (value.trim().isNotEmpty) {
                                chatProvider.sendMessage(
                                  MessageModel(
                                    senderId: widget.thisUserId,
                                    receiverId: widget.otherUser.id,
                                    content: value,
                                    conversationId: viewModel.conversationId!,
                                    wasItSeen: false,
                                    id: 0,
                                    createdAt: DateTime.now(),
                                    messageType: MessageType.text,
                                  ),
                                );
                                viewModel.sendNotification(
                                    context, widget.otherUser.id, value);
                                viewModel.msgController.clear();
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Mesaj yaz...",
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: AppColors.lightGray,
                                fontWeight: FontWeight.w500,
                              ),
                              prefixIconColor: AppColors.logoColor,
                            ),
                            style: TextStyle(
                              color: AppColors.lightColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        // add photo
                        IconButton(
                          onPressed: () => viewModel.sendPhotoMessage(
                              context, widget.thisUserId, widget.otherUser.id),
                          icon: Icon(
                            Icons.attach_file,
                            color: AppColors.lightColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // sizedbox
                5.w,

                // send msg button
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.logoColor.withAlpha(150),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: AppColors.lightColor),
                    onPressed: () {
                      if (viewModel.msgController.text.trim().isNotEmpty) {
                        chatProvider.sendMessage(
                          MessageModel(
                            senderId: widget.thisUserId,
                            receiverId: widget.otherUser.id,
                            content: viewModel.msgController.text,
                            conversationId: viewModel.conversationId!,
                            wasItSeen: false,
                            id: 0,
                            createdAt: DateTime.now(),
                            messageType: MessageType.text,
                          ),
                        );
                        viewModel.sendNotification(context, widget.otherUser.id,
                            viewModel.msgController.text);
                        viewModel.msgController.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Offstage(
            offstage: !viewModel.isEmojiVisible,
            child: SizedBox(
              height: 250,
              child: EmojiPicker(
                textEditingController: viewModel.msgController,
                config: Config(
                  locale: Locale("tr", "TR"),
                  height: 250,
                  checkPlatformCompatibility: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Size> getImageSize(ImageProvider provider) async {
    final completer = Completer<Size>();
    final img = Image(image: provider);
    img.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        final mySize = Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        );
        completer.complete(mySize);
      }),
    );
    return completer.future;
  }
}

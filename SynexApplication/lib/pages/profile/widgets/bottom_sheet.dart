import 'package:flutter/material.dart';
import 'package:suffadaemon/components/components.dart';
import 'package:suffadaemon/utils/utils.dart';

import '../../../../core/resources/app_colors.dart';

class ProfilePageEditBottomSheet extends StatefulWidget {
  const ProfilePageEditBottomSheet({super.key, required this.editName});

  final String editName;

  @override
  State<ProfilePageEditBottomSheet> createState() =>
      _ProfilePageEditBottomSheetState();
}

class _ProfilePageEditBottomSheetState
    extends State<ProfilePageEditBottomSheet> {
  TextEditingController textController = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool focusState = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(
      () => setState(() {
        focusState = focusNode.hasFocus;
      }),
    );

    focusNode.requestFocus();
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: focusState ? 600 : 230,
      width: double.infinity,
      padding: const EdgeInsets.only(
          left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
      child: Column(
        children: [
          SuffaText(
            title: "Yeni ${widget.editName}",
            textSize: SuffaSizes.mediumTextSize,
            textColor: AppColors.lightColor,
          ),

          // sizedbox
          const SizedBox(height: 10.0),

          // input
          SizedBox(
            height: 50,
            child: SuffaInput(
              controller: textController,
              hintText: "${widget.editName}...",
              focusNode: focusNode,
              textSize: SuffaSizes.bigMediumTextSize,
              keyboardType: TextInputType.text,
              prefixIcon: Icons.edit,
              capitalization: TextCapitalization.sentences,
            ),
          ),

          // sizedbox
          const SizedBox(height: 10.0),

          // save button
          SuffaButton(
            title: "Güncelle",
            bgColor: AppColors.logoColor,
            height: 80,
            titleSize: SuffaSizes.xLargeTextSize,
            iconSize: SuffaSizes.xLargeTextSize,
            onClick: () {
              String groupName = textController.text;
              if (groupName.isNotEmpty) {
                Navigator.pop(context, groupName);
              } else {
                ScreenMessage.showErrorToast(
                    context, "${widget.editName} boş olamaz.");
              }
            },
            icon: Icons.save,
            iconState: true,
          )
        ],
      ),
    );
  }
}

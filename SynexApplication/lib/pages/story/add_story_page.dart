import 'dart:io';
import 'package:flutter/material.dart';
import 'package:suffadaemon/components/texts/title_text.dart';
import 'package:suffadaemon/utils/resources/sizes.dart';
import 'package:synex/models/User/user_model.dart';
import 'package:synex/viewmodel/story/add_story_page_view_model.dart';

import '../../core/resources/app_colors.dart';

class AddStoryPage extends StatefulWidget {
  const AddStoryPage({
    super.key,
    required this.userModel,
    required this.photoPath,
  });

  final UserModel userModel;
  final String photoPath;

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  AddStoryPageViewModel viewModel = AddStoryPageViewModel();

  @override
  void dispose() {
    super.dispose();
    viewModel.captionController.dispose();
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
          title: "Hikaye Ekle",
          textFont: TextStyle(
            color: AppColors.lightColor,
            fontSize: SuffaSizes.xxLargeTextSize,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              String text = viewModel.captionController.text;
              Navigator.pop(context, [true, text.isNotEmpty ? text : null]);
            },
            icon: Icon(
              Icons.check,
              color: AppColors.successColor,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.file(
              File(widget.photoPath),
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.black54,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: TextField(
                controller: viewModel.captionController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Bir açıklama ekle...",
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  counterStyle: TextStyle(
                    color: AppColors.lightColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                maxLines: 1,
                maxLength: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

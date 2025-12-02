import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:suffadaemon/utils/utils.dart';
import 'package:synex/models/Stories/story_model_dto.dart';

class ShowStoryPage extends StatefulWidget {
  const ShowStoryPage({super.key, required this.storyModelDto});

  final StoryModelDto storyModelDto;

  @override
  State<ShowStoryPage> createState() => _ShowStoryPageState();
}

class _ShowStoryPageState extends State<ShowStoryPage> {
  PageController pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stories = widget.storyModelDto.storys;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            PageView.builder(
              controller: pageController,
              itemCount: stories.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final story = stories[index];
                return Stack(
                  children: [
                    Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: story.content,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Story caption
                    if (story.contentMsg.isNotEmpty)
                      Positioned(
                        bottom: 60,
                        left: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            story.contentMsg,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    // User info
                    Positioned(
                      top: 50,
                      left: 16,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(widget.storyModelDto.photoUrl),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.storyModelDto.username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: SuffaSizes.bigMediumTextSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Progress indicators
                    Positioned(
                      top: 20,
                      left: 16,
                      right: 16,
                      child: Row(
                        children: List.generate(
                          stories.length,
                          (i) => Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              height: 3,
                              decoration: BoxDecoration(
                                color: i <= _currentIndex
                                    ? Colors.white
                                    : Colors.white24,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            // Close button
            Positioned(
              top: 50,
              right: 16,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

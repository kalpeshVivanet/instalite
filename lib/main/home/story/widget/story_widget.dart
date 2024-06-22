// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:story_view/story_view.dart';

import '../../../../model/story.dart';
import '../../../../model/user.dart';

import '../page/stories_post.dart';

import 'profile_widget.dart';

class StoryWidget extends StatefulWidget {
  final UserStory user;
  final PageController controller;

  const StoryWidget({
    super.key,
    required this.user,
    required this.controller,
  });

  @override
  _StoryWidgetState createState() => _StoryWidgetState();
}

class _StoryWidgetState extends State<StoryWidget> {
  final storyItems = <StoryItem>[];
  late StoryController controller;
  late StoryController videoController;
  late Timestamp date;

  void addStoryItems() {
    for (final story in widget.user.stories) {
      switch (story.mediaType) {
        case MediaType.image:
          storyItems.add(StoryItem.pageImage(
            url: story.url!,
            controller: controller,
            caption: Text(story.caption),
            duration: Duration(
              milliseconds: (story.duration * 1000).toInt(),
            ),
          ));
          break;
        case MediaType.video:
          storyItems.add(
            StoryItem.pageVideo(
              story.url!,
              controller: controller,
              // url: "",
              // controller: videoController,
              // caption: story.caption,
              duration: Duration(
                milliseconds: (story.duration * 1000).toInt(),
              ),
              // // title: story.caption,
              // // backgroundColor: story.color,
              // duration: Duration(
              //   milliseconds: (story.duration * 1000).toInt(),
              // ),
              // controller: null,
            ),
          );
          break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    controller = StoryController();
    addStoryItems();
    date = widget.user.stories[0].date;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void handleCompleted() {
    widget.controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );

    final currentIndex = users.indexOf(widget.user);
    final isLastPage = users.length - 1 == currentIndex;

    if (isLastPage) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          Material(
            type: MaterialType.transparency,
            child: StoryView(
              storyItems: storyItems,
              controller: controller,
              onComplete: handleCompleted,
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.pop(context);
                }
              },
              // onStoryShow: (storyItem) {
              //   final index = storyItems.indexOf(storyItem);

              //   // if (index > 0) {
              //   //   setState(() {
              //   //     date = widget.user.stories[index].date;
              //   //   });
              //   // }
              // },
            ),
          ),
          ProfileWidget(
            user: widget.user,
            date: date,
          ),
        ],
      );
}

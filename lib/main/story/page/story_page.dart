import 'package:flutter/material.dart';

import '../../../model/user.dart';

import '../widget/story_widget.dart';
import 'stories_post.dart';

class StoryPage extends StatefulWidget {
  final UserStory user;

  const StoryPage({
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late PageController controller;

  @override
  void initState() {
    super.initState();

    final initialPage = users.indexOf(widget.user);
    controller = PageController(initialPage: initialPage);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      children: users
          .map((user) => StoryWidget(
                user: user,
                controller: controller,
              ))
          .toList(),
    );
  }
}

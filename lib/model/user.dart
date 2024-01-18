import 'story.dart';

class UserStory {
  final String name;
  final String imgUrl;
  final List<Story> stories;

  const UserStory({
    required this.name,
    required this.imgUrl,
    required this.stories,
  });
}

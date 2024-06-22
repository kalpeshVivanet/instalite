import 'package:flutter/material.dart';
import 'package:instalite/main_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../data/database.dart';
import '../../../../model/user.dart';

import 'story_page.dart';

List<UserStory> users = [];

class StoriesPost extends StatelessWidget {
  StoriesPost({Key? key}) : super(key: key);

  String profilePicture = userDetailData.profilePicture;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserStory>>(
      stream: DataBaseEvent().getStoryStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          users = snapshot.data ?? [];
          return SizedBox(
            height: 110.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: users.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 8, bottom: 0, right: 8, top: 8),
                    child: Column(children: <Widget>[
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            // clipBehavior: Clip.antiAliasWithSaveLayer,
                            width: 70.0,
                            height: 70.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.pink,
                                width: 2.0,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Container(
                                  clipBehavior: Clip.antiAlias,
                                  width: 30.0,
                                  height: 30.0,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: userDetailData.profilePicture,
                                    placeholder: (context, url) => Container(
                                      color: const Color.fromARGB(
                                          255, 239, 239, 239),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      'assets/images/user.png',
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                  )),
                              // CircleAvatar(
                              //     radius: 30.0,
                              //     backgroundImage: NetworkImage(
                              //         userDetailData.profilePicture)
                              //     // NetworkImage(
                              //     //     "https://wallpapercave.com/wp/wp2568544.jpg"),
                              //     ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2.0,
                              ),
                            ),
                            child: const CircleAvatar(
                              radius: 12.0,
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                        // child:
                      ),
                      const SizedBox(height: 4.0),
                      const Text(
                        'Your Story',
                        style: TextStyle(fontSize: 12.0),
                      )
                    ]),
                  );
                } else {
                  final storyIndex = index - 1;
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              StoryPage(user: users[storyIndex]),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, bottom: 0, right: 8, top: 8),
                      child: Column(
                        children: [
                          Container(
                            width: 70.5,
                            height: 70.5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.pink,
                                width: 2.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: CircleAvatar(
                                radius: 30.0,
                                backgroundImage:
                                    NetworkImage(users[storyIndex].imgUrl),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            users[storyIndex].name,
                            style: const TextStyle(fontSize: 12.0),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          );
        }
      },
    );
  }
}

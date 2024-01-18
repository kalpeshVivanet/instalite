import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instalite/utilites/constant.dart';
import '../model/story.dart';
import '../model/user.dart';
import 'feed_post.dart';
import 'story/page/stories_post.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                floating: true,
                snap: true,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                titleSpacing: 25,
                toolbarHeight: 60,
                elevation: 0.0,
                title: const Text(
                  "Instagram",
                  style: TextStyle(
                      fontFamily: 'Billabong',
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
                actions: [
                  IconButton(
                    iconSize: 30,
                    icon: const Icon(Icons.favorite_border_outlined),
                    onPressed: () async {
                      //feed
                      // QuerySnapshot<Map<String, dynamic>> querySnapshot =
                      //     await FirebaseFirestore.instance.collection("post").get();
                      // for (QueryDocumentSnapshot<
                      //         Map<String, dynamic>> documentSnapshot
                      //     in querySnapshot.docs) {
                      //   // Access data using documentSnapshot.data()
                      //   print(documentSnapshot.data());
                      // }
                      //story
                      UserStory user = UserStory(
                        name: 'kalpesh',
                        imgUrl:
                            'https://www.trickscity.com/wp-content/uploads/2018/06/anonymous-dp-for-boys.jpg',
                        stories: [
                          Story(
                            mediaType: MediaType.image,
                            url:
                                'https://www.photo-paysage.com/albums/userpics/10001/Cascade_-15.JPG',
                            duration: 5,
                            caption: 'Story 1 Caption',
                            date: Timestamp.now(),
                          ),
                          Story(
                            mediaType: MediaType.video,
                            url:
                                'https://firebasestorage.googleapis.com/v0/b/instaclone-b0c32.appspot.com/o/WhatsApp%20Video%202023-12-17%20at%2020.32.45_c5a02048.mp4?alt=media&token=60514e17-817e-4c51-bf83-7360dcd8b2ea',
                            duration: 20,
                            caption: 'Story 1 Caption',
                            date: Timestamp.now(),
                          ),
                          // Add more stories as needed
                        ],
                      );
                      FirebaseFirestore.instance.collection('Story').add({
                        'name': user.name,
                        'imgUrl': user.imgUrl,
                        'stories': user.stories
                            .map((story) => {
                                  'mediaType': story.mediaType
                                      .toString()
                                      .split('.')
                                      .last,
                                  'url': story.url,
                                  'duration': story.duration,
                                  'caption': story.caption,
                                  'date': story.date,
                                })
                            .toList(),
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.facebookMessenger),
                    onPressed: () {
                      // Handle direct message button press
                    },
                  ),
                  spacewt5
                ],
              ),
            ];
          },
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  StoriesPost(),
                  FeedPost(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

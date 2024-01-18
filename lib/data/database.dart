// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instalite/model/user_detail.dart';

import '../model/story.dart';
import '../model/user.dart';

class DataBaseEvent {
  final StreamController<List<UserStory>> _eventStreamController =
      StreamController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  Stream<List<UserStory>> getStoryStream() {
    try {
      // Using snapshots() to get real-time updates
      db.collection("Story").snapshots().listen((querySnapshot) {
        List<UserStory> itemList = [];

        querySnapshot.docs.forEach((element) {
          Map<String, dynamic> data = element.data();
          List<dynamic> rawStories = data['stories'] ?? [];

          List<Story> stories = rawStories.map((rawStory) {
            Map<String, dynamic> storyData = rawStory as Map<String, dynamic>;
            return Story(
              mediaType: MediaType.values.firstWhere(
                (e) => e.toString() == 'MediaType.${storyData['mediaType']}',
                orElse: () => MediaType.image,
              ),
              caption: storyData['caption'] ?? "",
              date: storyData['date'],
              url: storyData['url'] ?? "",
              duration: storyData['duration'],
            );
          }).where((story) {
            DateTime storyDate = story.date.toDate();
            return DateTime.now().difference(storyDate).inHours <= 24;
          }).toList();

          if (stories.isEmpty) {
            db.collection("Story").doc(element.id).delete();
          } else {
            UserStory user = UserStory(
              name: data["name"],
              imgUrl: data["imgUrl"],
              stories: stories,
            );

            itemList.add(user);
          }
        });

        _eventStreamController.add(itemList);
      });

      return _eventStreamController.stream;
    } catch (e) {
      return const Stream.empty();
    }
  }

  Future<UserDetail?> getUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      return await db
          .collection("UserDetail")
          .doc(uid)
          .get()
          .then((documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic> userData =
              documentSnapshot.data() as Map<String, dynamic>;

          return UserDetail(
              email: userData["Email"],
              fullName: userData["FullName"],
              mobileNumber: userData["Mobile"],
              userName: userData["UserName"],
              profilePicture: userData["ProfilePicture"]);
        } else {
          // Handle the case where the document does not exist
          print("Document does not exist");
          return null; // or return null, or throw an exception, depending on your requirements
        }
      });
    } catch (e) {
      // Handle the error

      return null; // or return null, or throw an exception, depending on your requirements
    }
  }

  void dispose() {
    _eventStreamController.close();
  }
}

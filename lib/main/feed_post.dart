import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedPost extends StatelessWidget {
  const FeedPost({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchPostData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Map<String, dynamic>> postDataList =
              snapshot.data as List<Map<String, dynamic>>;

          return Column(
            children: [
              for (int i = 0; i < postDataList.length; i++) ...[
                Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User information (avatar, username, etc.)
                      // Example: UserInfoWidget(),

                      // Post image
                      Image.network(
                        postDataList[i]['post'] ??
                            'https://placekitten.com/200/200',
                      ),

                      // Post actions (like, comment, share, etc.)
                      // Example: PostActionsWidget(),

                      // Caption and comments
                      // Example: CaptionAndCommentsWidget(),
                    ],
                  ),
                ),
              ]
            ],
          );
        }
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchPostData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection("post").get();

      List<Map<String, dynamic>> postDataList =
          querySnapshot.docs.map((doc) => doc.data()).toList();

      return postDataList;
    } catch (e) {
      print('Error fetching post data: $e');
      return [];
    }
  }
}

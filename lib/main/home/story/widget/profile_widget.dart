import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../model/user.dart';

class ProfileWidget extends StatelessWidget {
  final UserStory user;
  final Timestamp date;

  const ProfileWidget({
    required this.user,
    required this.date,
    Key? key,
  }) : super(key: key);

  String formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours} ${duration.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} ${duration.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime timestamp = date.toDate();
    Duration difference = now.difference(timestamp);
    String formattedDifference = formatDuration(difference);

    return Material(
      type: MaterialType.transparency,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 55),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(user.imgUrl),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "$formattedDifference",
                    style: const TextStyle(color: Colors.white38),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

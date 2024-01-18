import 'package:cloud_firestore/cloud_firestore.dart';

enum MediaType { image, video }

class Story {
  final MediaType mediaType;
  final String? url;
  final int duration;
  final String caption;
  final Timestamp date;

  Story({
    required this.mediaType,
    required this.caption,
    required this.date,
    this.url,
    this.duration = 5,
  });
}

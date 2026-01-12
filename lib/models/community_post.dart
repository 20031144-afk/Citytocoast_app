import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityPost {
  final String id;
  final String userId;
  final String userName;
  final String userRole;
  final String userProfileImage;
  final String text;
  final String? imageUrl;
  final int likes;
  final List<Map<String, dynamic>> comments;
  final DateTime timestamp;

  CommunityPost({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userRole,
    required this.userProfileImage,
    required this.text,
    this.imageUrl,
    this.likes = 0,
    this.comments = const [],
    required this.timestamp,
  });

  factory CommunityPost.fromMap(String id, Map<String, dynamic> data) {
    return CommunityPost(
      id: id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Anonymous',
      userRole: data['userRole'] ?? 'Member',
      userProfileImage: data['userProfileImage'] ?? '',
      text: data['text'] ?? '',
      imageUrl: data['imageUrl'],
      likes: data['likes'] ?? 0,
      comments:
          (data['comments'] as List<dynamic>?)
              ?.map((c) => Map<String, dynamic>.from(c as Map))
              .toList() ??
          [],
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userRole': userRole,
      'userProfileImage': userProfileImage,
      'text': text,
      'imageUrl': imageUrl,
      'likes': likes,
      'comments': comments,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}

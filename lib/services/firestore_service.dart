import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 🔹 Create user document
  Future<void> createUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).set(data);
  }

  // 🔹 Get user data
  Future<DocumentSnapshot> getUser(String uid) async {
    return _db.collection('users').doc(uid).get();
  }

  // 🔹 Update user data
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }

  // 🔹 Stream user data (for profile page)
  Stream<DocumentSnapshot> userStream(String uid) {
    return _db.collection('users').doc(uid).snapshots();
  }

  // 🔹 Get sitter list
  Future<QuerySnapshot> getSitters() async {
    return _db.collection('users').where('role', isEqualTo: 'sitter').get();
  }

  // 🔹 Stream sitter list
  Stream<QuerySnapshot> sittersStream() {
    return _db.collection('users')
              .where('role', isEqualTo: 'sitter')
              .snapshots();
  }
}

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SitterUploadService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> uploadSittersFromJson() async {
    // Load JSON from assets
    final String jsonString =
        await rootBundle.loadString('assets/sitters.json');

    // Decode JSON to List
    final List<dynamic> sitters = jsonDecode(jsonString);

    // Upload each sitter to Firestore
    for (var sitter in sitters) {
      await _db.collection('sitters').add(sitter);
    }
  }
}

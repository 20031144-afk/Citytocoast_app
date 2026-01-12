import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:citytocoast_app/models/booking_model.dart';
import 'package:citytocoast_app/models/chat_message.dart';
import 'package:citytocoast_app/models/community_post.dart';
import 'package:citytocoast_app/screens/sitter.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // dY"1 Create user document
  Future<void> createUser(String uid, Map<String, dynamic> data) async {
    final now = FieldValue.serverTimestamp();
    final payload = {
      ...data,
      'updatedAt': now,
      if (!data.containsKey('createdAt')) 'createdAt': now,
    };
    await _db
        .collection('users')
        .doc(uid)
        .set(payload, SetOptions(merge: true));
  }

  // dY"1 Get user data
  Future<DocumentSnapshot> getUser(String uid) async {
    return _db.collection('users').doc(uid).get();
  }

  // dY"1 Update user data
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }

  // dY"1 Stream user data (for profile page)
  Stream<DocumentSnapshot> userStream(String uid) {
    return _db.collection('users').doc(uid).snapshots();
  }

  // dY"1 Get sitter list
  Future<QuerySnapshot> getSitters() async {
    return _db.collection('users').where('role', isEqualTo: 'sitter').get();
  }

  // dY"1 Stream sitter list
  Stream<QuerySnapshot> sittersStream() {
    return _db
        .collection('users')
        .where('role', isEqualTo: 'sitter')
        .snapshots();
  }

  // dY"1 Get sitter by ID
  Future<Sitter?> getSitterById(String sitterId) async {
    final doc = await _db.collection('sitters').doc(sitterId).get();
    if (!doc.exists) return null;
    return Sitter.fromFirestore({"id": doc.id, ...doc.data()!});
  }

  // dY"1 Get all sitters from sitters collection (ONE-TIME)
  Future<List<Sitter>> fetchSitters() async {
    final snapshot = await _db.collection('sitters').get();

    return snapshot.docs
        .map((doc) => Sitter.fromFirestore({"id": doc.id, ...doc.data()}))
        .toList();
  }

  // dY"1 Get sitter list
  Future<List<Sitter>> fetchUserSitters() async {
    final snapshot = await _db
        .collection('users')
        .where('role', isEqualTo: 'sitter')
        .get();

    return snapshot.docs.map(_mapUserDocToSitter).toList();
  }

  Sitter _mapUserDocToSitter(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final firstName = data['firstName']?.toString().trim() ?? '';
    final lastName = data['lastName']?.toString().trim() ?? '';
    final displayName = [
      firstName,
      lastName,
    ].where((value) => value.isNotEmpty).join(' ').trim();

    final mapped = <String, dynamic>{
      ...data,
      'id': doc.id,
      'name': displayName.isNotEmpty ? displayName : data['name'],
      'contactNumber': data['contactNumber'] ?? data['phoneNumber'],
      'profileImageUrl':
          data['profileImageUrl'] ?? data['photoUrl'] ?? data['avatarUrl'],
    };

    return Sitter.fromFirestore(mapped);
  }

  // dY"1 Stream real-time sitter updates
  Stream<List<Sitter>> sittersCollectionStream() {
    return _db.collection('sitters').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Sitter.fromFirestore({"id": doc.id, ...doc.data()}))
          .toList();
    });
  }

  // One-time migration to new sitter schema
  Future<void> migrateSittersToNewSchema({bool deleteOldFields = false}) async {
    final snapshot = await _db.collection('sitters').get();
    final batch = _db.batch();

    for (final doc in snapshot.docs) {
      final data = doc.data();

      final careTypes = _resolveCareTypes(data);

      final services = Sitter.asStringList(
        data['services'] ?? data['servicesProvided'],
      );
      final specialties = Sitter.asStringList(
        data['specialties'] ?? data['specialities'],
      );
      final galleryImageUrls = Sitter.asStringList(
        data['galleryImageUrls'] ?? data['images'],
      );

      final ratePerHour =
          _toNumeric(data['ratePerHour'] ?? data['rate']) ?? 0.0;
      final ratingAvg = _toNumeric(data['ratingAvg'] ?? data['rating']) ?? 0.0;
      final ratingCount = _toInt(data['ratingCount'] ?? data['reviews']);
      final isAvailable = data['isAvailable'] is bool
          ? data['isAvailable']
          : true;
      final location = Sitter.parseGeoPoint(
        data['location'],
        data['lat'],
        data['long'],
      );

      final availabilitySlots = Sitter.parseAvailabilitySlots(
        data['availabilitySlots'],
      ).map((slot) => {'date': slot.date, 'slots': slot.slots}).toList();

      final profileImageUrl =
          (data['profileImageUrl'] ??
              (galleryImageUrls.isNotEmpty ? galleryImageUrls.first : null)) ??
          'https://picsum.photos/seed/${doc.id}/600/600';

      final updates = <String, dynamic>{
        'name': data['name'] ?? '',
        'bio': data['bio'] ?? '',
        'contactNumber': data['contactNumber'] ?? '',
        'careTypes': careTypes,
        'ratePerHour': ratePerHour,
        'ratingAvg': ratingAvg,
        'ratingCount': ratingCount,
        'isAvailable': isAvailable,
        'services': services,
        'specialties': specialties,
        'profileImageUrl': profileImageUrl,
        'galleryImageUrls': galleryImageUrls,
        'suburb': data['suburb'] ?? '',
        'location': location,
        'availabilitySlots': availabilitySlots,
        'updatedAt': FieldValue.serverTimestamp(),
        if (data['createdAt'] == null)
          'createdAt': FieldValue.serverTimestamp(),
      };

      if (deleteOldFields) {
        updates.addAll({
          'milesAway': FieldValue.delete(),
          'distance': FieldValue.delete(),
          'lat': FieldValue.delete(),
          'long': FieldValue.delete(),
          'type': FieldValue.delete(),
          'profileImage': FieldValue.delete(),
          'images': FieldValue.delete(),
          'servicesProvided': FieldValue.delete(),
          'specialities': FieldValue.delete(),
        });
      }

      batch.update(doc.reference, updates);
    }

    await batch.commit();
  }

  double? _toNumeric(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  List<String> _resolveCareTypes(Map<String, dynamic> data) {
    final normalized = Sitter.normalizeCareTypes(
      data['careTypes'],
    ).where((c) => c == 'baby' || c == 'pet').toList();
    if (normalized.isNotEmpty) return normalized.toSet().toList();

    final typeValue = data['type']?.toString().toLowerCase();
    if (typeValue != null) {
      if (typeValue == 'baby') return ['baby'];
      if (typeValue == 'pet') return ['pet'];
      if (typeValue == 'both') return ['baby', 'pet'];
      if (typeValue == 'baby care') return ['baby'];
      if (typeValue == 'pet care') return ['pet'];
    }

    final services = Sitter.asStringList(
      data['services'] ?? data['servicesProvided'],
    ).map((e) => e.toLowerCase()).toList();
    final specialties = Sitter.asStringList(
      data['specialties'] ?? data['specialities'],
    ).map((e) => e.toLowerCase()).toList();

    final inferred = <String>{};
    bool containsKeyword(List<String> list, List<String> keywords) =>
        list.any((e) => keywords.any((k) => e.contains(k)));

    if (containsKeyword(services, ['pet', 'dog', 'cat', 'animal']) ||
        containsKeyword(specialties, ['pet', 'dog', 'cat', 'animal'])) {
      inferred.add('pet');
    }
    if (containsKeyword(services, [
          'baby',
          'newborn',
          'child',
          'kid',
          'school',
        ]) ||
        containsKeyword(specialties, [
          'baby',
          'newborn',
          'child',
          'kid',
          'school',
        ])) {
      inferred.add('baby');
    }

    final result = inferred.where((c) => c == 'baby' || c == 'pet').toList();
    return result;
  }

  // Legacy alias
  Future<void> migrateSittersSchema({bool deleteOldFields = false}) {
    return migrateSittersToNewSchema(deleteOldFields: deleteOldFields);
  }

  /// One-time migration: copy signUp collection docs into users collection.
  Future<void> migrateSignUpToUsers() async {
    final snapshot = await _db.collection('signUp').get();
    final batch = _db.batch();
    final now = FieldValue.serverTimestamp();

    for (final doc in snapshot.docs) {
      final data = doc.data();
      batch.set(_db.collection('users').doc(doc.id), {
        ...data,
        'updatedAt': now,
        if (!data.containsKey('createdAt')) 'createdAt': now,
      }, SetOptions(merge: true));
    }

    await batch.commit();
  }

  Future<String> createBookingAndReserveSlot(BookingModel booking) async {
    final dateId = booking.dateStr;
    final slotKey = booking.timeStr;

    return _db.runTransaction((transaction) async {
      final sitterAvailabilityRef = _db
          .collection('sitters')
          .doc(booking.sitterId)
          .collection('availability')
          .doc(dateId);

      final availabilitySnapshot = await transaction.get(sitterAvailabilityRef);
      final availabilityData =
          availabilitySnapshot.data() ?? <String, dynamic>{};
      final slots = Map<String, dynamic>.from(
        availabilityData['slots'] as Map? ?? {},
      );

      if (slots[slotKey] == 'booked') {
        throw Exception('This time is already booked');
      }

      slots[slotKey] = 'booked';

      transaction.set(sitterAvailabilityRef, {
        ...availabilityData,
        'date': dateId,
        'slots': slots,
        'updatedAt': FieldValue.serverTimestamp(),
        if (!availabilitySnapshot.exists)
          'createdAt': FieldValue.serverTimestamp(),
        if (availabilityData['createdAt'] != null &&
            availabilitySnapshot.exists)
          'createdAt': availabilityData['createdAt'],
      }, SetOptions(merge: true));

      final bookingRef = _db.collection('bookings').doc();
      final bookingId = bookingRef.id;
      final timestamp = FieldValue.serverTimestamp();
      final bookingData = {
        ...booking.toMap(),
        'bookingId': bookingId,
        'createdAt': timestamp,
        'updatedAt': timestamp,
      };

      final userBookingRef = _db
          .collection('users')
          .doc(booking.clientId)
          .collection('bookings')
          .doc(bookingId);

      final sitterBookingRef = _db
          .collection('sitters')
          .doc(booking.sitterId)
          .collection('bookings')
          .doc(bookingId);

      transaction.set(bookingRef, bookingData);
      transaction.set(userBookingRef, bookingData);
      transaction.set(sitterBookingRef, bookingData);

      return bookingId;
    });
  }

  Future<String> createBooking(BookingModel booking) {
    return createBookingAndReserveSlot(booking);
  }

  Future<void> markBookingPaid({
    required String bookingId,
    required String clientId,
    required String sitterId,
    required String paymentRef,
    required String paymentMethod,
    String paymentProvider = 'stripe',
  }) async {
    final payload = {
      'status': 'paid',
      'paymentStatus': 'paid',
      'paymentRef': paymentRef,
      'paymentMethod': paymentMethod,
      'paymentProvider': paymentProvider,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    final bookingRef = _db.collection('bookings').doc(bookingId);
    final userBookingRef = _db
        .collection('users')
        .doc(clientId)
        .collection('bookings')
        .doc(bookingId);
    final sitterBookingRef = _db
        .collection('sitters')
        .doc(sitterId)
        .collection('bookings')
        .doc(bookingId);

    final batch = _db.batch();
    batch.set(bookingRef, payload, SetOptions(merge: true));
    batch.set(userBookingRef, payload, SetOptions(merge: true));
    batch.set(sitterBookingRef, payload, SetOptions(merge: true));

    await batch.commit();
  }

  Future<void> createPaymentRecord({
    required String bookingId,
    required String paymentIntentId,
    required String clientId,
    required String sitterId,
    required double amount,
    required String currency,
    required String paymentMethod,
    String paymentProvider = 'stripe',
    String status = 'succeeded',
  }) async {
    final now = FieldValue.serverTimestamp();
    final payload = {
      'bookingId': bookingId,
      'clientId': clientId,
      'sitterId': sitterId,
      'paymentIntentId': paymentIntentId,
      'amount': amount,
      'currency': currency,
      'paymentProvider': paymentProvider,
      'paymentMethod': paymentMethod,
      'status': status,
      'createdAt': now,
      'updatedAt': now,
    };

    final paymentsRef = _db.collection('payments').doc(paymentIntentId);
    final userPaymentRef = _db
        .collection('users')
        .doc(clientId)
        .collection('payments')
        .doc(paymentIntentId);
    final bookingPaymentRef = _db
        .collection('bookings')
        .doc(bookingId)
        .collection('payments')
        .doc(paymentIntentId);

    final batch = _db.batch();
    batch.set(paymentsRef, payload, SetOptions(merge: true));
    batch.set(userPaymentRef, payload, SetOptions(merge: true));
    batch.set(bookingPaymentRef, payload, SetOptions(merge: true));

    await batch.commit();
  }

  Stream<List<BookingModel>> userBookingsStream(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('bookings')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => BookingModel.fromMap(doc.data(), documentId: doc.id),
              )
              .toList(),
        );
  }

  Stream<List<BookingModel>> sitterBookingsStream(String sitterId) {
    return _db
        .collection('sitters')
        .doc(sitterId)
        .collection('bookings')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => BookingModel.fromMap(doc.data(), documentId: doc.id),
              )
              .toList(),
        );
  }

  Future<BookingModel?> getBookingById(String bookingId) async {
    final doc = await _db.collection('bookings').doc(bookingId).get();
    if (!doc.exists) return null;
    return BookingModel.fromMap(
      doc.data() ?? <String, dynamic>{},
      documentId: doc.id,
    );
  }

  // dY"1 Favorites Logic
  Future<void> addToFavorites(String uid, Sitter sitter) async {
    final now = FieldValue.serverTimestamp();
    // Store minimal sitter data + timestamp
    final payload = {
      'id': sitter.id,
      'name': sitter.name,
      'profileImageUrl': sitter.profileImageUrl,
      'suburb': sitter.suburb,
      'ratingAvg': sitter.ratingAvg,
      'careTypes': sitter.careTypes,
      'ratePerHour': sitter.ratePerHour,
      'addedAt': now,
    };
    await _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(sitter.id)
        .set(payload);
  }

  Future<void> removeFromFavorites(String uid, String sitterId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(sitterId)
        .delete();
  }

  Future<bool> isSitterFavorite(String uid, String sitterId) async {
    final doc = await _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(sitterId)
        .get();
    return doc.exists;
  }

  Stream<List<Map<String, dynamic>>> getFavoritesStream(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> cancelBooking({
    required String bookingId,
    required String sitterId,
    required String clientId,
    required String date,
    required String time,
  }) async {
    final bookingRef = _db.collection('bookings').doc(bookingId);
    final userBookingRef = _db
        .collection('users')
        .doc(clientId)
        .collection('bookings')
        .doc(bookingId);
    final sitterBookingRef = _db
        .collection('sitters')
        .doc(sitterId)
        .collection('bookings')
        .doc(bookingId);
    final availabilityRef = _db
        .collection('sitters')
        .doc(sitterId)
        .collection('availability')
        .doc(date);

    await _db.runTransaction((transaction) async {
      final bookingSnapshot = await transaction.get(bookingRef);
      if (!bookingSnapshot.exists) {
        throw Exception('Booking not found');
      }

      final availabilitySnapshot = await transaction.get(availabilityRef);
      final availabilityData =
          availabilitySnapshot.data() ?? <String, dynamic>{};
      final slots = Map<String, dynamic>.from(
        availabilityData['slots'] as Map? ?? {},
      );

      slots[time] = 'free';

      transaction.set(availabilityRef, {
        ...availabilityData,
        'date': date,
        'slots': slots,
        'updatedAt': FieldValue.serverTimestamp(),
        if (!availabilitySnapshot.exists)
          'createdAt': FieldValue.serverTimestamp(),
        if (availabilityData['createdAt'] != null &&
            availabilitySnapshot.exists)
          'createdAt': availabilityData['createdAt'],
      }, SetOptions(merge: true));

      final statusUpdate = {
        'status': 'cancelled',
        'updatedAt': FieldValue.serverTimestamp(),
      };

      transaction.update(bookingRef, statusUpdate);
      transaction.set(userBookingRef, statusUpdate, SetOptions(merge: true));
      transaction.set(sitterBookingRef, statusUpdate, SetOptions(merge: true));
    });
  }

  // dY"1 Messaging Logic
  Future<String> getOrCreateChatRoom(String clientId, String sitterId) async {
    final roomId = [clientId, sitterId]..sort();
    final id = roomId.join('_');

    final roomRef = _db.collection('chatRooms').doc(id);
    final roomDoc = await roomRef.get();

    if (!roomDoc.exists) {
      await roomRef.set({
        'clientId': clientId,
        'sitterId': sitterId,
        'participants': [clientId, sitterId],
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    return id;
  }

  Future<void> sendMessage(String roomId, ChatMessage message) async {
    final batch = _db.batch();

    final messageRef = _db
        .collection('chatRooms')
        .doc(roomId)
        .collection('messages')
        .doc();

    batch.set(messageRef, message.toMap());

    batch.update(_db.collection('chatRooms').doc(roomId), {
      'lastMessage': message.text,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  Stream<List<ChatMessage>> messagesStream(String roomId) {
    return _db
        .collection('chatRooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ChatMessage.fromMap(doc.id, doc.data()))
              .toList();
        });
  }

  // 🔹 Community Feed Methods
  Future<void> createPost(CommunityPost post) async {
    await _db.collection('communityPosts').add(post.toMap());
  }

  Stream<List<CommunityPost>> getPostsStream() {
    return _db
        .collection('communityPosts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => CommunityPost.fromMap(doc.id, doc.data()))
              .toList();
        });
  }

  Future<void> likePost(String postId) async {
    final postRef = _db.collection('communityPosts').doc(postId);
    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(postRef);
      if (snapshot.exists) {
        final currentLikes = snapshot.get('likes') ?? 0;
        transaction.update(postRef, {'likes': currentLikes + 1});
      }
    });
  }

  Future<void> addComment(String postId, Map<String, dynamic> comment) async {
    final postRef = _db.collection('communityPosts').doc(postId);
    await postRef.update({
      'comments': FieldValue.arrayUnion([comment]),
    });
  }

  Future<void> likeComment(String postId, String commentId) async {
    final postRef = _db.collection('communityPosts').doc(postId);
    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(postRef);
      if (snapshot.exists) {
        final List<dynamic> comments = snapshot.get('comments') ?? [];
        final updatedComments = comments.map((c) {
          final commentMap = Map<String, dynamic>.from(c as Map);
          if (commentMap['id'] == commentId) {
            commentMap['likes'] = (commentMap['likes'] ?? 0) + 1;
          }
          return commentMap;
        }).toList();
        transaction.update(postRef, {'comments': updatedComments});
      }
    });
  }

  Future<void> seedCommunityPosts({bool overwrite = false}) async {
    final collection = _db.collection('communityPosts');
    final snapshot = await collection.limit(1).get();

    if (snapshot.docs.isNotEmpty && !overwrite) return;

    if (overwrite) {
      final all = await collection.get();
      for (var doc in all.docs) {
        await doc.reference.delete();
      }
    }

    final dummyPosts = [
      {
        "userName": "Sarah Johnson",
        "userRole": "Sitter",
        "userProfileImage": "https://i.pravatar.cc/150?img=14",
        "text":
            "Such a fun day babysitting Emma today! Tea party and storytime. 💕",
        "imageUrl":
            "https://images.unsplash.com/photo-1544606111-99a175f52391?auto=format&fit=crop&q=80&w=1000",
        "likes": 15,
        "comments": [
          {
            "id": DateTime.now().millisecondsSinceEpoch.toString() + "1",
            "userName": "Emma's Mom",
            "text": "Thank you Sarah! Emma loved it ❤️",
            "likes": 2,
            "timestamp": DateTime.now().toIso8601String(),
          },
        ],
      },
      {
        "userName": "Lisa Wang",
        "userRole": "Parent",
        "userProfileImage": "https://i.pravatar.cc/150?img=32",
        "text":
            "Lucy had a wonderful weekend with Maria! Highly recommend ⭐⭐⭐⭐⭐",
        "imageUrl":
            "https://images.unsplash.com/photo-1484820540004-14229fe36ca4?auto=format&fit=crop&q=80&w=1000",
        "likes": 10,
        "comments": [],
      },
      {
        "userName": "Maria Santos",
        "userRole": "Sitter",
        "userProfileImage": "https://i.pravatar.cc/150?img=44",
        "text": "Emergency babysitting done ✅ Little Ella was an angel!",
        "imageUrl":
            "https://images.unsplash.com/photo-1473625247510-87b1a6407335?auto=format&fit=crop&q=80&w=1000",
        "likes": 20,
        "comments": [],
      },
      {
        "userName": "Emma Davis",
        "userRole": "Parent",
        "userProfileImage": "https://i.pravatar.cc/150?img=50",
        "text": "Shoutout to Mike for being so reliable and punctual 👏",
        "imageUrl":
            "https://images.unsplash.com/photo-1516627145497-ae6968895b74?auto=format&fit=crop&q=80&w=1000",
        "likes": 18,
        "comments": [],
      },
    ];

    for (var p in dummyPosts) {
      await collection.add({
        ...p,
        "userId": "system",
        "timestamp": FieldValue.serverTimestamp(),
      });
    }
  }
}

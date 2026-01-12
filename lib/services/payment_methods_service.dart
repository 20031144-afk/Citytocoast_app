import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SetupIntentResult {
  SetupIntentResult({
    required this.customerId,
    required this.ephemeralKey,
    required this.setupIntentClientSecret,
  });

  final String customerId;
  final String ephemeralKey;
  final String setupIntentClientSecret;
}

class PaymentMethodsService {
  PaymentMethodsService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    FirebaseFunctions? functions,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _functions = functions ?? FirebaseFunctions.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  User _requireUser() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('You must be logged in.');
    }
    return user;
  }

  DocumentReference<Map<String, dynamic>> _userRef(String uid) {
    return _firestore.collection('users').doc(uid);
  }

  CollectionReference<Map<String, dynamic>> _methodsRef(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('payment_methods');
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> paymentMethodsStream() {
    final user = _requireUser();
    return _methodsRef(
      user.uid,
    ).orderBy('createdAt', descending: true).snapshots();
  }

  Future<String> ensureCustomerId() async {
    final user = _requireUser();
    final doc = await _userRef(user.uid).get();
    final existing = doc.data()?['stripeCustomerId']?.toString();
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }

    final setupIntent = await createSetupIntent();
    return setupIntent.customerId;
  }

  Future<SetupIntentResult> createSetupIntent() async {
    try {
      final callable = _functions.httpsCallable('createSetupIntent');
      final result = await callable.call(<String, dynamic>{});
      final data = result.data;
      if (data is! Map) {
        throw Exception('Unexpected response from payment service.');
      }
      final customerId = data['customerId']?.toString();
      final ephemeralKey = data['ephemeralKey']?.toString();
      final clientSecret = data['setupIntentClientSecret']?.toString();
      if (customerId == null ||
          customerId.isEmpty ||
          ephemeralKey == null ||
          ephemeralKey.isEmpty ||
          clientSecret == null ||
          clientSecret.isEmpty) {
        throw Exception('Unable to start the Stripe setup flow.');
      }

      final user = _requireUser();
      await _userRef(
        user.uid,
      ).set({'stripeCustomerId': customerId}, SetOptions(merge: true));

      return SetupIntentResult(
        customerId: customerId,
        ephemeralKey: ephemeralKey,
        setupIntentClientSecret: clientSecret,
      );
    } catch (e) {
      if (e is FirebaseFunctionsException && e.code == 'unavailable') {
        throw Exception(
          'Cannot connect to backend (Functions Unavailable). '
          'Ensure "firebase emulators:start" is running and the port is 5002.',
        );
      }
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> _listPaymentMethods(
    String customerId,
  ) async {
    final callable = _functions.httpsCallable('listPaymentMethods');
    final result = await callable.call(<String, dynamic>{
      'customerId': customerId,
    });
    final data = result.data;
    if (data is List) {
      return List<Map<String, dynamic>>.from(
        data.map((item) => Map<String, dynamic>.from(item as Map)),
      );
    }
    throw Exception('Unexpected response from payment service.');
  }

  Future<void> syncPaymentMethods({String? customerId}) async {
    final user = _requireUser();
    final resolvedCustomerId = customerId ?? await ensureCustomerId();
    final methods = await _listPaymentMethods(resolvedCustomerId);

    final ref = _methodsRef(user.uid);
    final existing = await ref.get();
    final existingById = {for (final doc in existing.docs) doc.id: doc.data()};

    final idsFromStripe = methods.map((pm) => pm['paymentMethodId']).toSet();
    final hasDefault = existing.docs.any(
      (doc) => (doc.data()['isDefault'] ?? false) == true,
    );
    var assignedDefault = hasDefault;

    final batch = _firestore.batch();
    for (final pm in methods) {
      final paymentMethodId = pm['paymentMethodId']?.toString() ?? '';
      if (paymentMethodId.isEmpty) continue;

      final existingData = existingById[paymentMethodId] ?? {};
      var isDefault = existingData['isDefault'] ?? false;
      if (!assignedDefault) {
        isDefault = true;
        assignedDefault = true;
      }

      final label =
          existingData['label']?.toString() ??
          _defaultLabel(pm['brand']?.toString());

      batch.set(ref.doc(paymentMethodId), {
        'brand': pm['brand'],
        'last4': pm['last4'],
        'expMonth': pm['expMonth'],
        'expYear': pm['expYear'],
        'label': label,
        'isDefault': isDefault,
        'createdAt': existingData['createdAt'] ?? FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    for (final doc in existing.docs) {
      if (!idsFromStripe.contains(doc.id)) {
        batch.delete(doc.reference);
      }
    }

    await batch.commit();
  }

  Future<void> setDefaultPaymentMethod(String paymentMethodId) async {
    final user = _requireUser();
    final ref = _methodsRef(user.uid);
    final snapshot = await ref.get();
    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {'isDefault': doc.id == paymentMethodId});
    }
    await batch.commit();
  }

  Future<void> renamePaymentMethodLabel(
    String paymentMethodId,
    String label,
  ) async {
    final user = _requireUser();
    await _methodsRef(user.uid).doc(paymentMethodId).update({'label': label});
  }

  Future<void> deletePaymentMethod(String paymentMethodId) async {
    final callable = _functions.httpsCallable('detachPaymentMethod');
    await callable.call(<String, dynamic>{'paymentMethodId': paymentMethodId});

    final user = _requireUser();
    await _methodsRef(user.uid).doc(paymentMethodId).delete();
  }

  Future<String?> getDefaultPaymentMethodId() async {
    final user = _requireUser();
    final snapshot = await _methodsRef(user.uid)
        .orderBy('isDefault', descending: true)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.id;
  }

  Future<Map<String, dynamic>?> getPaymentMethodSummary(
    String paymentMethodId,
  ) async {
    final user = _requireUser();
    final doc = await _methodsRef(user.uid).doc(paymentMethodId).get();
    if (!doc.exists) return null;
    final data = doc.data() ?? {};
    return {
      'paymentMethodId': doc.id,
      'brand': data['brand'],
      'last4': data['last4'],
      'expMonth': data['expMonth'],
      'expYear': data['expYear'],
      'label': data['label'],
      'isDefault': data['isDefault'] ?? false,
    };
  }

  Future<Map<String, dynamic>?> getDefaultPaymentMethodSummary() async {
    final id = await getDefaultPaymentMethodId();
    if (id == null) return null;
    return getPaymentMethodSummary(id);
  }

  String _defaultLabel(String? brand) {
    if (brand == null || brand.isEmpty) return 'Card';
    return brand[0].toUpperCase() + brand.substring(1).toLowerCase();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final CollectionReference _users = FirebaseFirestore.instance.collection(
    'users',
  );

  // READ
  Stream<DocumentSnapshot?> getUserById(String userId) {
    return _users.doc(userId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return snapshot;
      } else {
        return null;
      }
    });
  }

  // READ: Check if premium is not expired
  Stream<bool> isPremiumUser(String userId) {
    return _users.doc(userId).snapshots().map((snapshot) {
      final premiumExpiryDate = snapshot.get('premiumExpiryDate');
      return DateTime.now().isBefore(premiumExpiryDate.toDate());
    });
  }

  // CREATE
  Future<void> createUser({
    required String userId,
    required String username,
    required String profileUrl,
  }) async {
    try {
      // Set the documentId to be the same as the userId from Firebase Auth
      await _users.doc(userId).set({
        'username': username,
        'profileUrl': profileUrl,
        'premiumExpiryDate': DateTime.now().subtract(Duration(seconds: 1)),
      });
    } catch (e) {
      print(e);
    }
  }

  // Update the user's premium expiry date
  Future<void> updateUserPremiumExpiryDate(String userId) async {
    try {
      await _users.doc(userId).update({
        'premiumExpiryDate': DateTime.now().add(Duration(days: 1)),
      });
    } catch (e) {
      print(e);
    }
  }
}

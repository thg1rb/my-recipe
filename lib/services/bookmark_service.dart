import 'package:cloud_firestore/cloud_firestore.dart';

class BookmarkService {
  final CollectionReference _bookmarks = FirebaseFirestore.instance.collection(
    'users',
  );

  // READ
  Stream<QuerySnapshot> getBookmarks(String userId) {
    return FirebaseFirestore.instance
        .collection('bookmarks')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  // CREATE
  // TODO: Return Future<String?> to detect errors
  Future<void> createBookmark({
    required String userId,
    required String name,
  }) async {
    try {
      await _bookmarks.add({
        'userId': userId,
        'name': name,
        'recipesId': [],
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      print(e);
    }
  }

  // TODO: UPDATE

  // TODO: DELETE
}

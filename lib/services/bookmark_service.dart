import 'package:cloud_firestore/cloud_firestore.dart';

class BookmarkService {
  final CollectionReference _bookmarks = FirebaseFirestore.instance.collection(
    'bookmarks',
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
      final response = await _bookmarks.add({
        'userId': userId,
        'bookmarkId': '',
        'name': name,
        'recipesId': [],
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      });
      // Update the bookmarkId with the document ID
      final bookmarkId = response.id;
      await _bookmarks.doc(bookmarkId).update({'bookmarkId': bookmarkId});
    } catch (e) {
      print(e);
    }
  }

  // TODO: UPDATE

  // TODO: DELETE
}

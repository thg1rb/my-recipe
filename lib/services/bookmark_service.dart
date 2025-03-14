import 'package:cloud_firestore/cloud_firestore.dart';

class BookmarkService {
  final CollectionReference _bookmarks = FirebaseFirestore.instance.collection(
    'bookmarks',
  );

  // READ: Get a list of bookmarks
  Stream<QuerySnapshot> getBookmarksById(String userId) {
    return _bookmarks.where('userId', isEqualTo: userId).snapshots();
  }

  // READ: Get the number of bookmarks
  Stream<int> getBookmarkCount(String userId) {
    return _bookmarks
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  // TODO: Return Future<String?> to detect errors
  // CREATE: Create a new bookmark
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

  // UPDATE: Update the bookmark name
  Future<void> updateBookmark(String bookmarkId, String updatedName) {
    return _bookmarks.doc(bookmarkId).update({'name': updatedName});
  }

  // DELETE: Delete a bookmark
  Future<void> deleteBookmark(String bookmarkId) {
    return _bookmarks.doc(bookmarkId).delete();
  }
}

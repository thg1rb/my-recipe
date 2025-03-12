import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeService {
  final CollectionReference _recipes = FirebaseFirestore.instance.collection(
    'recipes',
  );

  // READ: Get a list of recipes by userId
  Stream<QuerySnapshot> getRecipesByUserId(String userId) {
    return _recipes.where('userId', isEqualTo: userId).snapshots();
  }

  // READ: Get a list of recipes by keyword
  Stream<QuerySnapshot> getRecipes({String keyword = ''}) {
    if (keyword.isEmpty) {
      // If keyword is empty, return all recipes
      return _recipes.snapshots();
    } else {
      // If keyword is provided, filter recipes by name (supports Thai)
      return _recipes
          .where('name', isGreaterThanOrEqualTo: keyword)
          .where(
            'name',
            isLessThan: keyword + '\uf8ff',
          ) // Unicode character for prefix matching
          .snapshots();
    }
  }

  // READ: Get a single recipe by recipeId
  Stream<DocumentSnapshot?> getRecipeById(String recipeId) {
    return _recipes.doc(recipeId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return snapshot;
      } else {
        return null;
      }
    });
  }

  // CREATE

  // UPDATE

  // DELETE
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipeService {
  final CollectionReference _recipes = FirebaseFirestore.instance.collection(
    'recipes',
  );

  // READ: Get a list of recipes
  Stream<QuerySnapshot> getRecipes() {
    return _recipes.snapshots();
  }

  // READ: Get a list of recipes which has the most likes
  Stream<QuerySnapshot> getMostLikedRecipes() {
    return _recipes.orderBy('likes', descending: true).snapshots();
  }

  // READ: Get a list of recipes which has a video
  Stream<QuerySnapshot> getRecipesWithVideo() {
    return _recipes.where('videoUrl', isNotEqualTo: '').snapshots();
  }

  // READ: Get a list of recipes by userId
  Stream<QuerySnapshot> getRecipesByUserId(String userId) {
    return _recipes.where('userId', isEqualTo: userId).snapshots();
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

  // READ: Get a list of recipes by category
  Stream<QuerySnapshot> getRecipesByCategory(String category) {
    return _recipes.where('category', isEqualTo: category).snapshots();
  }

  // CREATE: Upload a file to Supabase Storage
  Future<String?> uploadFile({
    required String bucket,
    required String path,
    required File file,
  }) async {
    try {
      // Upload the file to Supabase Storage
      await Supabase.instance.client.storage.from(bucket).upload(path, file);

      // Retrieve the public URL of the uploaded file
      final publicUrl = Supabase.instance.client.storage
          .from(bucket)
          .getPublicUrl(path);

      return publicUrl;
    } on StorageException catch (e) {
      // Handle Supabase Storage-specific exceptions
      print('Supabase Storage error: ${e.message}');
      return null;
    } catch (e) {
      // Handle any other exceptions
      print('Upload exception: $e');
      return null;
    }
  }

  // CREATE: Add a new recipe to Firestore
  Future<void> addRecipe({
    required String userId,
    required String name,
    required String category,
    required String difficulty,
    required String description,
    required String ingredient,
    required String instruction,
    File? imageFile,
    File? videoFile,
  }) async {
    try {
      // Add some fields
      final response = await _recipes.add({
        'userId': userId,
        'name': name,
        'category': category,
        'difficulty': difficulty,
        'description': description,
        'ingredient': ingredient,
        'instruction': instruction,
        'views': 0,
        'likes': 0,
        'imageUrl': '',
        'videoUrl': '',
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      });
      // Get the current recipe ID
      final recipeId = response.id;

      String? imageUrl;
      String? videoUrl;

      // If imageFile and videoFile are provided, upload them to Supabase Storage
      if (imageFile != null) {
        imageUrl = await uploadFile(
          bucket: "files",
          path: "images/$recipeId",
          file: imageFile,
        );
      }
      if (videoFile != null) {
        videoUrl = await uploadFile(
          bucket: "files",
          path: "videos/$recipeId",
          file: videoFile,
        );
      }

      // Update the image and video URLs if they are not null
      await _recipes.doc(recipeId).update({
        'imageUrl': imageUrl ?? '',
        'videoUrl': videoUrl ?? '',
      });
    } catch (e) {
      print('Add recipe exception: $e');
    }
  }

  // UPDATE

  // DELETE
}

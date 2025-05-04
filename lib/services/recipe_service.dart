import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipeService {
  final CollectionReference _recipes = FirebaseFirestore.instance.collection(
    'recipes',
  );

  // READ: Get a recipe by recipeId
  Stream<QuerySnapshot> getRecipeById(String recipeId) {
    return _recipes.where('recipeId', isEqualTo: recipeId).snapshots();
  }

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

  // READ: Get a list of recipes by category
  Stream<QuerySnapshot> getRecipesByCategory(String category) {
    return _recipes.where('category', isEqualTo: category).snapshots();
  }

  // READ: Get a list of recipes by recipeIds
  Stream<QuerySnapshot> getRecipesByIds(List<String> recipeIds) {
    if (recipeIds.isEmpty) {
      return Stream.empty();
    }
    return _recipes.where('recipeId', whereIn: recipeIds).snapshots();
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
        'recipeId': '',
        'userId': userId,
        'name': name,
        'category': category,
        'difficulty': difficulty,
        'description': description,
        'ingredient': ingredient,
        'instruction': instruction,
        'views': 0,
        'likes': [],
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
        'recipeId': recipeId,
        'imageUrl': imageUrl ?? '',
        'videoUrl': videoUrl ?? '',
      });
    } catch (e) {
      print('Add recipe exception: $e');
    }
  }

  // UPDATE: Update an existing recipe in Firestore
  Future<void> updateRecipe({
    required String recipeId,
    required String name,
    required String category,
    required String difficulty,
    required String description,
    required String ingredient,
    required String instruction,
    File? imageFile,
    File? videoFile,
    String? imageUrl,
    String? videoUrl,
  }) async {
    try {
      // If a new image file is provided, delete the old image and upload the new one
      if (imageFile != null) {
        // Delete the old image if it exists
        if (imageUrl != null && imageUrl.isNotEmpty) {
          await Supabase.instance.client.storage.from('files').remove([
            "images/${imageUrl.split('/').last}",
          ]);
        }

        await Future.delayed(Duration(seconds: 1));

        // Extemsion of the new image
        final imageExtension = ".${imageFile.path.split('.').last}";

        // Upload the new image
        imageUrl = await uploadFile(
          bucket: "files",
          path: "images/$recipeId$imageExtension",
          file: imageFile,
        );
      }

      // If a new video file is provided, delete the old video and upload the new one
      if (videoFile != null) {
        // Delete the old video if it exists
        if (videoUrl != null && videoUrl.isNotEmpty) {
          await Supabase.instance.client.storage.from('files').remove([
            "images/${videoUrl.split('/').last}",
          ]);
        }

        await Future.delayed(Duration(seconds: 1));

        // Extension of the new video
        final videoExtension = ".${videoFile.path.split('.').last}";

        // Upload the new video
        videoUrl = await uploadFile(
          bucket: "files",
          path: "videos/$recipeId$videoExtension",
          file: videoFile,
        );
      }

      // Update the recipe in Firestore
      await _recipes.doc(recipeId).update({
        'name': name,
        'category': category,
        'difficulty': difficulty,
        'description': description,
        'ingredient': ingredient,
        'instruction': instruction,
        'imageUrl': imageUrl,
        'videoUrl': videoUrl,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      print('Update recipe exception: $e');
    }
  }

  // UPDATE: Update views of a recipe by recipeId
  Future<void> updateRecipeViews(String recipeId, int newViews) {
    return _recipes.doc(recipeId).update({'views': newViews + 1});
  }

  // UPDATE: Update likes of a recipe by recipeId
  Future<void> updateRecipeLike(String recipeId, List<dynamic> newList) {
    return _recipes.doc(recipeId).update({'likes': newList});
  }

  // DELETE a recipe by recipeId (and its image and video from Supabase Storage)
  Future<void> deleteRecipe(
    String recipeId,
    String imageUrl,
    String videoUrl,
  ) async {
    try {
      // Delete the recipe from Firestore
      await _recipes.doc(recipeId).delete();

      // Remove the recipeId from bookmarks
      final bookmarks =
          await FirebaseFirestore.instance
              .collection('bookmarks')
              .where('recipeIds', arrayContains: recipeId)
              .get();

      for (final bookmark in bookmarks.docs) {
        final recipeIds = List<String>.from(bookmark['recipeIds']);
        recipeIds.remove(recipeId);
        await FirebaseFirestore.instance
            .collection('bookmarks')
            .doc(bookmark.id)
            .update({'recipeIds': recipeIds});
      }

      // Delete the image and video from Supabase Storage
      if (imageUrl.isNotEmpty) {
        await Supabase.instance.client.storage.from('files').remove([imageUrl]);
      }
      if (videoUrl.isNotEmpty) {
        await Supabase.instance.client.storage.from('files').remove([videoUrl]);
      }
    } catch (e) {
      print('Delete recipe exception: $e');
    }
  }
}

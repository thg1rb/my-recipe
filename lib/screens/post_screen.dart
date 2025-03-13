import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe/services/recipe_service.dart';
import 'package:my_recipe/services/user_service.dart';
import 'package:my_recipe/widgets/post/form.dart';
import 'package:my_recipe/widgets/post/upload.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final nameController = TextEditingController();
  final detailController = TextEditingController();
  final ingredientsController = TextEditingController();
  final instructionController = TextEditingController();
  File? image;
  File? video;
  String? category;
  String? difficulty;
  String? imageErrorMessage;
  String? categoryErrorMessage;
  String? difficultyErrorMessage;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final User _user = FirebaseAuth.instance.currentUser!;
  final UserService _userService = UserService();
  final RecipeService _recipeService = RecipeService();

  void handleImageSelected(File? file) {
    setState(() {
      image = file;
      imageErrorMessage = null;
    });
  }

  void handleVideoSelected(File? file) {
    setState(() => video = file);
  }

  // TODO: Implement Edit Recipe (UPDATE)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runSpacing: 20,
                  children: [
                    Column(
                      children: [
                        UploadButton(
                          btnSize: Size(400, 220),
                          text: 'อัปโหลดรูปภาพ',
                          icon: Icons.image,
                          iconSize: 60,
                          isRow: false,
                          isVideo: false,
                          onFileSelected: handleImageSelected,
                        ),
                        if (imageErrorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              imageErrorMessage!,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                    StreamBuilder<bool>(
                      stream: _userService.isPremiumUser(_user.uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Show a loading indicator while fetching premium status
                        }

                        final bool isPremiumUser = snapshot.data ?? false;

                        return isPremiumUser
                            ? UploadButton(
                              btnSize: Size(400, 80),
                              text: 'อัปโหลดวิดีโอ',
                              icon: Icons.movie_filter,
                              iconSize: 40,
                              isRow: true,
                              isVideo: true,
                              onFileSelected: handleVideoSelected,
                            )
                            : SizedBox.shrink(); // Hide the button if the user is not premium
                      },
                    ),
                    Column(
                      children: [
                        FineDropDownBox(
                          title: 'ประเภทอาหาร',
                          items: ['เมนูข้าว', 'เมนูเส้น', 'ของหวาน'],
                          colors: [Colors.yellow, Colors.yellow, Colors.yellow],
                          id: 'cateDropdown',
                          onSelected: (value) {
                            setState(() {
                              category = value;
                              categoryErrorMessage = null;
                            });
                          },
                        ),
                        if (categoryErrorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              categoryErrorMessage!,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                    Column(
                      children: [
                        FineDropDownBox(
                          title: 'ระดับความยาก',
                          items: ['ง่าย', 'ปานกลาง', 'ยาก'],
                          colors: [
                            Colors.lightGreenAccent,
                            Colors.orangeAccent,
                            Colors.redAccent,
                          ],
                          id: 'diffDropDown',
                          onSelected: (value) {
                            setState(() {
                              difficulty = value;
                              difficultyErrorMessage = null;
                            });
                          },
                        ),
                        if (difficultyErrorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              difficultyErrorMessage!,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                    CustomTextField(
                      label: 'ชื่อเมนู',
                      height: 56,
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณาระบุชื่อเมนู';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      label: 'รายละเอียด',
                      height: 150,
                      controller: detailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณาระบุรายละเอียด';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      label: 'วัตถุดิบที่ใช้',
                      height: 150,
                      controller: ingredientsController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณาระบุวัตถุดิบที่ใช้';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      label: 'ขั้นตอนวิธีทำ',
                      height: 150,
                      controller: instructionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณาระบุขั้นตอนวิธีทำ';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            image != null &&
                            category != null &&
                            difficulty != null) {
                          // Debugging
                          // print("Recipe Name: ${nameController.text}");
                          // print("Details: ${detailController.text}");
                          // print("Ingredients: ${ingredientsController.text}");
                          // print("Instructions: ${instructionController.text}");
                          // print("Category: $category");
                          // print("Difficulty: $difficulty");
                          // print("Image Path: ${image?.path}");
                          // print("Video Path: ${video?.path}");
                          _recipeService.addRecipe(
                            userId: _user.uid,
                            name: nameController.text,
                            category: category!,
                            difficulty: difficulty!,
                            description: detailController.text,
                            ingredient: ingredientsController.text,
                            instruction: instructionController.text,
                            imageFile: image,
                            videoFile: video,
                          );
                        } else {
                          if (image == null) {
                            setState(() {
                              imageErrorMessage = 'กรุณาเลือกรูปภาพ';
                            });
                          }
                          if (category == null) {
                            setState(() {
                              categoryErrorMessage = 'กรุณาเลือกประเภทอาหาร';
                            });
                          }
                          if (difficulty == null) {
                            setState(() {
                              difficultyErrorMessage = 'กรุณาเลือกระดับความยาก';
                            });
                          }
                        }
                        //
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'เผยแพร่สูตรอาหาร',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Slide Transiton Build
Route createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => PostScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

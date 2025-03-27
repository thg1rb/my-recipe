import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe/services/recipe_service.dart';
import 'package:my_recipe/services/user_service.dart';
import 'package:my_recipe/widgets/post/form.dart';
import 'package:my_recipe/widgets/post/upload.dart';

class PostScreen extends StatefulWidget {
  final String? recipeId;

  const PostScreen({super.key, this.recipeId});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _instructionController = TextEditingController();
  String? _category;
  String? _difficulty;
  File? _image;
  File? _video;
  String? _imageUrl;
  String? _videoUrl;
  String? _imageErrorMessage;
  String? _categoryErrorMessage;
  String? _difficultyErrorMessage;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final User _user = FirebaseAuth.instance.currentUser!;
  final UserService _userService = UserService();
  final RecipeService _recipeService = RecipeService();

  bool _isPosting = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.recipeId != null) {
      _fetchRecipeData(widget.recipeId!);
    } else {
      _isLoading = false;
    }
  }

  void _fetchRecipeData(String recipeId) async {
    final recipeSnapshot = await _recipeService.getRecipeById(recipeId).first;

    if (recipeSnapshot.docs.isNotEmpty) {
      final recipeData =
          recipeSnapshot.docs.first.data() as Map<String, dynamic>;
      setState(() {
        _nameController.text = recipeData['name'];
        _detailController.text = recipeData['description'];
        _ingredientsController.text = recipeData['ingredient'];
        _instructionController.text = recipeData['instruction'];
        _category = recipeData['category'];
        _difficulty = recipeData['difficulty'];
        _imageUrl = recipeData['imageUrl']; // Initialize image URL
        _videoUrl = recipeData['videoUrl']; // Initialize video URL
        _isLoading = false;
      });
    } else {
      // No recipe found, stop loading
      setState(() {
        _isLoading = false;
      });
    }
  }

  void handleImageSelected(File? file) {
    _imageErrorMessage = null;
    setState(() => _image = file);
  }

  void handleVideoSelected(File? file) {
    setState(() => _video = file);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
                          selectedImageUrl:
                              _imageUrl, // Pass the previous image URL from Firebase
                        ),
                        if (_imageErrorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _imageErrorMessage!,
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
                          return CircularProgressIndicator();
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
                              selectedVideoFilename:
                                  _videoUrl, // Pass the previous video filename
                            )
                            : SizedBox.shrink();
                      },
                    ),
                    Column(
                      children: [
                        FineDropDownBox(
                          title: 'ประเภทอาหาร',
                          items: [
                            'อาหารตามสั่ง',
                            'ก๋วยเตี๋ยว',
                            'ฟาสต์ฟู้ด',
                            'สลัดและยำ',
                            'เครื่องดื่ม',
                            'ขนมทานเล่น',
                            'อาหารญี่ปุ่น',
                            'อาหารเกาหลี',
                            'อาหารอินเดีย',
                          ],
                          colors: [
                            Colors.yellow,
                            Colors.yellow,
                            Colors.yellow,
                            Colors.yellow,
                            Colors.yellow,
                            Colors.yellow,
                            Colors.yellow,
                            Colors.yellow,
                            Colors.yellow,
                          ],
                          id: 'cateDropdown',
                          onSelected: (value) {
                            setState(() {
                              _category = value;
                              _categoryErrorMessage = null;
                            });
                          },
                          selectedItem:
                              _category, // Pass the selected category from Firebase
                        ),
                        if (_categoryErrorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _categoryErrorMessage!,
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
                              _difficulty = value;
                              _difficultyErrorMessage = null;
                            });
                          },
                          selectedItem: _difficulty,
                        ),
                        if (_difficultyErrorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _difficultyErrorMessage!,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                    CustomTextField(
                      label: 'ชื่อเมนู',
                      height: 85,
                      controller: _nameController,
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
                      controller: _detailController,
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
                      controller: _ingredientsController,
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
                      controller: _instructionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณาระบุขั้นตอนวิธีทำ';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed:
                          _isPosting
                              ? null
                              : () {
                                if (_formKey.currentState!.validate() &&
                                    (_image != null || _imageUrl != null) &&
                                    _category != null &&
                                    _difficulty != null) {
                                  setState(() {
                                    _isPosting = true;
                                  });
                                  if (widget.recipeId == null) {
                                    _recipeService.addRecipe(
                                      userId: _user.uid,
                                      name: _nameController.text,
                                      category: _category!,
                                      difficulty: _difficulty!,
                                      description: _detailController.text,
                                      ingredient: _ingredientsController.text,
                                      instruction: _instructionController.text,
                                      imageFile: _image,
                                      videoFile: _video,
                                    );
                                    setState(() {
                                      _isPosting = false;
                                    });
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(
                                      context,
                                    ).clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "✅ เผยแพร่สูตรอาหารสำเร็จ",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                          ),
                                        ),
                                        backgroundColor:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                      ),
                                    );
                                  } else {
                                    // Update the existing recipe
                                    _recipeService.updateRecipe(
                                      recipeId: widget.recipeId!,
                                      name: _nameController.text,
                                      category: _category!,
                                      difficulty: _difficulty!,
                                      description: _detailController.text,
                                      ingredient: _ingredientsController.text,
                                      instruction: _instructionController.text,
                                      imageFile: _image,
                                      videoFile: _video,
                                      imageUrl: _imageUrl,
                                      videoUrl: _videoUrl,
                                    );
                                    setState(() {
                                      _isPosting = false;
                                    });
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(
                                      context,
                                    ).clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "✅ อัปเดตสูตรอาหารสำเร็จ",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                          ),
                                        ),
                                        backgroundColor:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                      ),
                                    );
                                  }
                                } else {
                                  if (_image == null && _imageUrl == null) {
                                    setState(() {
                                      _imageErrorMessage = 'กรุณาเลือกรูปภาพ';
                                    });
                                  }
                                  if (_category == null) {
                                    setState(() {
                                      _categoryErrorMessage =
                                          'กรุณาเลือกประเภทอาหาร';
                                    });
                                  }
                                  if (_difficulty == null) {
                                    setState(() {
                                      _difficultyErrorMessage =
                                          'กรุณาเลือกระดับความยาก';
                                    });
                                  }
                                }
                              },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child:
                          _isPosting
                              ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                    ),
                                  ),
                                  Text("กำลังเผยแพร่สูตร..."),
                                ],
                              )
                              : Text(
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

// Slide Transition Build
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

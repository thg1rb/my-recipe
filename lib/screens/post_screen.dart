import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
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

  void handleImageSelected(File? file) {
    setState(() => image = file);
  }

  void handleVideoSelected(File? file) {
    setState(() => video = file);
  }

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
              Wrap(
                alignment: WrapAlignment.center,
                runSpacing: 20,
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
                  UploadButton(
                    btnSize: Size(400, 80),
                    text: 'อัปโหลดวิดีโอ',
                    icon: Icons.movie_filter,
                    iconSize: 40,
                    isRow: true,
                    isVideo: true,
                    onFileSelected: handleVideoSelected,
                  ),
                  FineDropDownBox(
                    title: 'ประเภทอาหาร',
                    items: ['เมนูข้าว', 'เมนูเส้น', 'ของหวาน'],
                    colors: [Colors.yellow, Colors.yellow, Colors.yellow],
                    id: 'cateDropdown',
                    onSelected: (value) {
                      setState(() {
                        category = value;  
                      });
                    },
                  ),
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
                      });
                    },
                  ),
                  CustomTextField(
                    label: 'ชื่อเมนู',
                    height: 56,
                    controller: nameController,
                  ),
                  CustomTextField(
                    label: 'รายละเอียด',
                    height: 150,
                    controller: detailController,
                  ),
                  CustomTextField(
                    label: 'วัตถุดิบที่ใช้',
                    height: 150,
                    controller: ingredientsController,
                  ),
                  CustomTextField(
                    label: 'ขั้นตอนวิธีทำ',
                    height: 150,
                    controller: instructionController,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // HOW TO USE
                      /*
                        nameController.text -> name value
                        detailController.text -> detailValue
                        ingredientsController.text -> ingredients value
                        instructionsController.text -> instruction value
                        image use ได้เลย (File / XFile ไม่แน่ใจ)
                        video use ได้เลย (File / XFile ไม่แน่ใจ)
                        category use ได้เลย
                        difficulty use ได้เลย
                       */
                      // DEBUG
                      print("Recipe Name: ${nameController.text}");
                      print("Details: ${detailController.text}");
                      print("Ingredients: ${ingredientsController.text}");
                      print("Instructions: ${instructionController.text}");
                      print("Category: $category");
                      print("Difficulty: $difficulty");
                      print("Image Path: ${image?.path}");
                      print("Video Path: ${video?.path}");
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

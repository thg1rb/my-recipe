import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe/widgets/post/form.dart';
import 'package:my_recipe/widgets/post/upload.dart';

class PostScreen extends ConsumerWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  ),
                  UploadButton(
                    btnSize: Size(400, 80),
                    text: 'อัปโหลดวิดีโอ',
                    icon: Icons.movie_filter,
                    iconSize: 40,
                    isRow: true,
                  ),
                  FineDropDownBox(title: 'ประเภทอาหาร', items: ['เมนูข้าว', 'เมนูเส้น', 'ของหวาน'], colors: [Colors.yellow,Colors.yellow,Colors.yellow], id: 'cateDropdown'),
                  FineDropDownBox(title: 'ระดับความยาก',items: ['ง่าย','ปานกลาง','ยาก'], colors: [Colors.lightGreenAccent, Colors.orangeAccent,Colors.redAccent], id: 'diffDropDown'),
                  CustomTextField(label: 'ชื่อเมนู', height: 56),
                  CustomTextField(label: 'รายละเอียด', height: 150),
                  CustomTextField(label: 'วัตถุดิบที่ใช้', height: 150),
                  CustomTextField(label: 'ขั้นตอนวิธีทำ', height: 150),
                  ElevatedButton(
                    onPressed: () {},
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
    pageBuilder: (context, animation, secondaryAnimation) => const PostScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

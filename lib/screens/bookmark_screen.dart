import 'dart:developer';

import 'package:flutter/material.dart';

// Hardcode check premium user
final bool isPremiumUser = true;

// Bookmarks Mock Object
final List<Map<String, dynamic>> bookmarks = [
  {"title": "🍳 บุ๊คมาร์คเริ่มต้น", "count": 10},
  {"title": "☀ มื้อเช้าแสนสดชื่น", "count": 20},
  {"title": "🕛 มื้อเที่ยงแสนอร่อย", "count": 20},
  {"title": "🌆 มื้อเย็นสุขสันต์", "count": 20},
  {"title": "✨ มื้อดึกแสนเปล่าเปลี่ยว", "count": 20},
];

class BookmarkScreen extends StatelessWidget {
  BookmarkScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _bookmarkTitle = TextEditingController();

  // CREATE and EDIT AlertDialog
  void _showCreateOrEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => Form(
            key: _formKey,
            child: AlertDialog(
              title: Text(
                "สร้างบันทึกสูตรอาหารใหม่", // Save or Edit
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.yellow[50],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      size: 40,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  TextFormField(
                    controller: _bookmarkTitle,
                    decoration: InputDecoration(
                      label: Text("ชื่อบันทึก"),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    maxLength: 20,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        return null;
                      }
                      return "กรุณาระบุชื่อบันทึกนี้";
                    },
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            log("ดำเนินการเสร็จสิ้น"); // Debugging
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("ดำเนินการเสร็จสิ้น")),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        child: Text("ยืนยัน"),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.transparent,
                      ),
                      child: Text(
                        "ยกเลิก",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  // DELETE AlertDialog
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              "ยืนยันการลบบันทึก",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    Icons.delete_forever_rounded,
                    size: 40,
                    color: Colors.red,
                  ),
                ),
                Text(
                  "คุณแน่ใจหรือไม่ว่าต้องการลบบันทึกนี้?\nข้อมูลจะถูกลบถาวรและไม่สามารถกู้คืนได้อีก",
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.red[200]),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        log("ดำเนินการลบเสร็จสิ้น"); // Debugging
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("ดำเนินการลบเสร็จสิ้น")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                      child: Text("ยืนยันการลบบันทึก"),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.transparent,
                    ),
                    child: Text(
                      "ยกเลิก",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        // Hide divided line from PresistentFooterButton
        dividerTheme: DividerThemeData(color: Colors.transparent),
      ),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 10, // horizontal padding = main.dart (15) + (10) = 25
          ),
          child: ListView.separated(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {},
                title: Text(
                  bookmarks[index]["title"],
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                subtitle: Text(
                  "จำนวน ${bookmarks[index]["count"].toString()} สูตร",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                trailing: PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(
                          onTap: () => _showCreateOrEditDialog(context),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.edit_rounded),
                              Text("แก้ไขบันทึก"),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () => _showDeleteDialog(context),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.delete_rounded),
                              Text("ลบบันทึก"),
                            ],
                          ),
                        ),
                      ],
                ),
                tileColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 4,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 10);
            },
          ),
        ),
        persistentFooterButtons: <Widget>[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showCreateOrEditDialog(context),
              child: Text("สร้างบันทึกสูตรอาหารใหม่"),
            ),
          ),
        ],
        persistentFooterAlignment: AlignmentDirectional.bottomCenter,
      ),
    );
  }
}

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe/screens/premium_ad_screen.dart';
import 'package:my_recipe/services/bookmark_service.dart';
import 'package:my_recipe/services/user_service.dart';

class BookmarkScreen extends StatelessWidget {
  BookmarkScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _bookmarkTitle = TextEditingController();

  final User user = FirebaseAuth.instance.currentUser!;
  final UserService _userService = UserService();
  final BookmarkService _bookmarkService = BookmarkService();

  // CREATE and EDIT AlertDialog
  void _showCreateOrEditDialog(
    BuildContext context,
    bool isUpdate,
    [String? bookmarkId]
  ) {
    if (isUpdate == false) {_bookmarkTitle.clear();}
    showDialog(
      context: context,
      builder:
          (context) => Form(
            key: _formKey,
            child: AlertDialog(
              title: Text(
                isUpdate ? "แก้ไขบันทึกสูตรอาหาร" : "สร้างบันทึกสูตรอาหารใหม่",
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
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            log("ดำเนินการเสร็จสิ้น"); // Debugging
                            isUpdate
                                ? await _bookmarkService.updateBookmark(
                                  bookmarkId!,
                                  _bookmarkTitle.text,
                                )
                                : await _bookmarkService.createBookmark(
                                  userId: user.uid,
                                  name: _bookmarkTitle.text,
                                );
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
          child: StreamBuilder<QuerySnapshot>(
            stream: _bookmarkService.getBookmarks(user.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text('No data'),
                ); // TODO: Styling this message
              } else {
                final bookmarks =
                    snapshot.data!.docs
                        .map((bookmark) => bookmark.data())
                        .toList();
                return ListView.separated(
                  itemCount: bookmarks.length,
                  itemBuilder: (context, index) {
                    final bookmark = bookmarks[index] as Map<String, dynamic>;
                    return ListTile(
                      onTap: () {},
                      title: Text(
                        bookmark["name"],
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      subtitle: Text(
                        "จำนวน ${bookmark["recipesId"].toList().length.toString()} สูตร",
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
                                onTap:
                                    () => _showCreateOrEditDialog(
                                      context,
                                      true,
                                      bookmark['bookmarkId'],
                                    ),
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
                );
              }
            },
          ),
        ),
        persistentFooterButtons: <Widget>[
          StreamBuilder<bool>(
            stream: _userService.isPremiumUser(user.uid),
            builder: (context, premiumSnapshot) {
              if (premiumSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (premiumSnapshot.hasError) {
                return Center(child: Text('Error: ${premiumSnapshot.error}'));
              } else {
                bool isPremium = premiumSnapshot.data!;

                return StreamBuilder<int>(
                  stream: _bookmarkService.getBookmarkCount(user.uid),
                  builder: (context, bookmarkSnapshot) {
                    if (bookmarkSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (bookmarkSnapshot.hasError) {
                      return Center(
                        child: Text('Error: ${bookmarkSnapshot.error}'),
                      );
                    } else if (!bookmarkSnapshot.hasData) {
                      return Center(child: Text('No bookmark'));
                    } else {
                      int bookmarkCount = bookmarkSnapshot.data!;

                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (isPremium) {
                              _showCreateOrEditDialog(context, false);
                            } else {
                              if (bookmarkCount > 2) {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) => PremiumAdScreen(),
                                    transitionsBuilder: (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      const begin = Offset(0.0, 1.0);
                                      const end = Offset.zero;
                                      const curve = Curves.ease;

                                      var tween = Tween(
                                        begin: begin,
                                        end: end,
                                      ).chain(CurveTween(curve: curve));
                                      var offsetAnimation = animation.drive(
                                        tween,
                                      );

                                      return SlideTransition(
                                        position: offsetAnimation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              } else {
                                _showCreateOrEditDialog(context, false);
                              }
                            }
                          },
                          child: Text("สร้างบันทึกสูตรอาหารใหม่"),
                        ),
                      );
                    }
                  },
                );
              }
            },
          ),
        ],
        persistentFooterAlignment: AlignmentDirectional.bottomCenter,
      ),
    );
  }
}

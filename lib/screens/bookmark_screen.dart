import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe/screens/premium_ad_screen.dart';
import 'package:my_recipe/screens/recipe_grid_screen.dart';
import 'package:my_recipe/services/bookmark_service.dart';
import 'package:my_recipe/services/recipe_service.dart';
import 'package:my_recipe/services/user_service.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _bookmarkTitle = TextEditingController();

  final User user = FirebaseAuth.instance.currentUser!;

  final UserService _userService = UserService();
  final RecipeService _recipeService = RecipeService();
  final BookmarkService _bookmarkService = BookmarkService();

  @override
  void dispose() {
    _bookmarkTitle.dispose();
    super.dispose();
  }

  // CREATE and EDIT AlertDialog
  void _showCreateOrEditDialog(
    BuildContext context,
    bool isUpdate, {
    required Map<String, dynamic>? bookmark,
  }) {
    if (isUpdate == false) {
      _bookmarkTitle.clear();
    } else {
      _bookmarkTitle.text = bookmark?["name"];
    }

    // Using custom route for animation
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black54,
        pageBuilder: (BuildContext context, _, __) {
          return Form(
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
                            isUpdate
                                ? await _bookmarkService.updateBookmark(
                                  bookmark?["bookmarkId"],
                                  _bookmarkTitle.text,
                                )
                                : await _bookmarkService.createBookmark(
                                  userId: user.uid,
                                  name: _bookmarkTitle.text,
                                );
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isUpdate
                                      ? "✅ แก้ไขชื่อบันทึกเสร็จสิ้น"
                                      : "✅ สร้างบันทึกใหม่เสร็จสิ้น",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                backgroundColor:
                                    Theme.of(context).colorScheme.onPrimary,
                              ),
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
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "ยกเลิก",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          // Combined scale and fade transition
          return ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
              reverseCurve: Curves.easeInBack,
            ),
            child: FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
                reverseCurve: Curves.easeIn,
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }

  // DELETE AlertDialog
  void _showDeleteDialog(BuildContext context, {required String bookmarkId}) {
    // Using custom route for animation
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black54,
        pageBuilder: (BuildContext context, _, __) {
          return AlertDialog(
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
                      onPressed: () async {
                        await _bookmarkService.deleteBookmark(bookmarkId);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "✅ ลบบันทึกเสร็จสิ้น",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                          ),
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
          );
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          // Shake and fade animation for delete dialog
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
              reverseCurve: Curves.easeIn,
            ),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -0.1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.elasticOut,
                  reverseCurve: Curves.easeIn,
                ),
              ),
              child: child,
            ),
          );
        },
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
            stream: _bookmarkService.getBookmarksById(user.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'ไม่พบบันทึกสูตรอาหาร\nโปรดสร้างบันทึกใหม่!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                );
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
                      onTap: () {
                        // Cast the List<dynamic> to List<String>
                        final List<String> recipeIds =
                            (bookmark["recipeIds"] as List<dynamic>)
                                .cast<String>()
                                .toList();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => RecipeGridScreen(
                                  title: bookmark["name"],
                                  queryBuilder:
                                      () => _recipeService.getRecipesByIds(
                                        recipeIds,
                                      ),
                                ),
                          ),
                        );
                      },
                      title: Text(
                        bookmark["name"],
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      subtitle: Text(
                        "จำนวน ${bookmark["recipeIds"].toList().length.toString()} สูตร",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      trailing: PopupMenuButton(
                        icon: Icon(
                          Icons.more_vert_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        color: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        itemBuilder:
                            (context) => [
                              PopupMenuItem(
                                onTap:
                                    () => _showCreateOrEditDialog(
                                      context,
                                      true,
                                      bookmark: bookmark,
                                    ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Icon(
                                      Icons.edit_rounded,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                    ),
                                    Text(
                                      "แก้ไขบันทึก",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                      ),
                                    ),
                                    SizedBox(),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                onTap:
                                    () => _showDeleteDialog(
                                      context,
                                      bookmarkId: bookmark["bookmarkId"],
                                    ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Icon(
                                      Icons.delete_rounded,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                    ),
                                    Text(
                                      "ลบบันทึก",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                      ),
                                    ),
                                    SizedBox(),
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
                              _showCreateOrEditDialog(
                                context,
                                false,
                                bookmark: null,
                              );
                            } else {
                              if (bookmarkCount > 2) {
                                PremiumAdScreen.navigateTo(context);
                              } else {
                                _showCreateOrEditDialog(
                                  context,
                                  false,
                                  bookmark: null,
                                );
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

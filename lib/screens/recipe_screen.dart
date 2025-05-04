import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe/screens/post_screen.dart';
import 'package:my_recipe/services/bookmark_service.dart';
import 'package:my_recipe/services/recipe_service.dart';
import 'package:my_recipe/widgets/navigation_bar/top_navbar.dart';
import 'package:my_recipe/widgets/recipe/details.dart';
import 'package:my_recipe/widgets/recipe/details_bar.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key, required this.recipe});

  final Map<String, dynamic> recipe;
  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final RecipeService _recipeService = RecipeService();
  final BookmarkService _bookmarkService = BookmarkService();

  late bool isLikedByUser;

  // Update the recipe views when the user views the recipe
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _recipeService.updateRecipeViews(
      widget.recipe['recipeId'],
      widget.recipe['views'],
    );
  }

  @override
  void initState() {
    super.initState();
    isLikedByUser = widget.recipe['likes']?.contains(user?.uid) ?? false;
  }

  // Show the bookmark dialog
  void _showBookmarksDialog(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black54,
        pageBuilder: (BuildContext context, _, __) {
          return StreamBuilder<QuerySnapshot>(
            stream: _bookmarkService.getBookmarksById(user!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'ไม่มีบันทึกสูตรอาหารใดๆ\nโปรดสร้างบันทึกใหม่!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              } else {
                return AlertDialog(
                  title: Text(
                    "บันทึกสูตรอาหารทั้งหมด",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children:
                          snapshot.data!.docs.map((doc) {
                            return CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(
                                doc['name'],
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              value: doc['recipeIds'].contains(
                                widget.recipe['recipeId'],
                              ),
                              onChanged: (bool? value) {
                                setState(() {
                                  // If the recipe is already in the bookmark, remove it
                                  if (doc['recipeIds'].contains(
                                    widget.recipe['recipeId'],
                                  )) {
                                    doc.reference.update({
                                      'recipeIds': FieldValue.arrayRemove([
                                        widget.recipe['recipeId'],
                                      ]),
                                    });
                                  }
                                  // Otherwise, add it to the bookmark
                                  else {
                                    doc.reference.update({
                                      'recipeIds': FieldValue.arrayUnion([
                                        widget.recipe['recipeId'],
                                      ]),
                                    });
                                  }
                                });
                              },
                            );
                          }).toList(),
                    ),
                  ),
                  actionsAlignment: MainAxisAlignment.center,
                  actions: <Widget>[
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "✅ ดำเนินการเปลี่ยนแปลงเสร็จสิ้น",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                    ),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                            child: Text("ยืนยันการเปลี่ยนแปลง"),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "ยกเลิก",
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
            },
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

  // show delete dialog
  void _showDeleteDialog(BuildContext context) {
    // Using custom route for animation
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black54,
        pageBuilder: (BuildContext context, _, __) {
          return AlertDialog(
            title: Text(
              "ยืนยันการลบสูตรอาหาร",
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
                  "คุณแน่ใจหรือไม่ว่าต้องการลบสูตรอาหารนี้?\nข้อมูลจะถูกลบถาวรและไม่สามารถกู้คืนได้อีก",
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
                        await _recipeService.deleteRecipe(
                          widget.recipe["recipeId"],
                          "images/${widget.recipe["recipeId"]}",
                          "videos/${widget.recipe["recipeId"]}",
                        );
                        Navigator.pop(context);
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
    return Scaffold(
      appBar: TopNavBar(
        title: "",
        action: [
          if (user?.uid == widget.recipe["userId"])
            IconButton(
              icon: Icon(Icons.edit_rounded),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            PostScreen(recipeId: widget.recipe["recipeId"]),
                  ),
                );
              },
            ),
          if (user?.uid == widget.recipe["userId"])
            IconButton(
              onPressed: () => _showDeleteDialog(context),
              icon: Icon(Icons.delete_forever_rounded),
            ),
          if (user?.uid != widget.recipe["userId"])
            IconButton(
              onPressed: () => _showBookmarksDialog(context),
              icon: Icon(Icons.bookmark_add_rounded),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                widget.recipe["imageUrl"].toString().isEmpty
                    ? Container(
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 230,
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          "ไม่พบรูปภาพ",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    )
                    : SizedBox(
                      height: 230,
                      width: double.infinity,
                      child: Image.network(
                        widget.recipe["imageUrl"],
                        fit: BoxFit.cover,
                      ),
                    ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 160,
                    left: MediaQuery.of(context).size.width * 0.1,
                    right: MediaQuery.of(context).size.width * 0.1,
                    bottom: 12,
                  ),
                  child: Column(
                    children: [
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 2,
                        shadowColor: Theme.of(context).colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 20,
                          ),
                          width: 350,
                          color: Theme.of(context).colorScheme.onPrimary,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              children: [
                                Text(
                                  widget.recipe["name"],
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "[${DateTime.fromMillisecondsSinceEpoch(widget.recipe["createdAt"].millisecondsSinceEpoch).toLocal().toString().split('.')[0]}]",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildIconText(
                                      context,
                                      icon: Icons.dining,
                                      text: widget.recipe["difficulty"],
                                    ),
                                    _buildIconText(
                                      context,
                                      icon: Icons.remove_red_eye,
                                      text: widget.recipe["views"].toString(),
                                    ),
                                    _buildIconText(
                                      context,
                                      icon: Icons.favorite,
                                      text:
                                          widget.recipe["likes"].length
                                              .toString(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            DetailsBar(),
            SizedBox(height: 10),
            Detail(recipe: widget.recipe),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final updatedLikes = widget.recipe['likes'];

          if (isLikedByUser) {
            updatedLikes.remove(user!.uid);
          } else {
            updatedLikes.add(user!.uid);
          }

          setState(() {
            isLikedByUser = !isLikedByUser;
          });

          await _recipeService.updateRecipeLike(
            widget.recipe['recipeId'],
            updatedLikes,
          );
        },
        shape: CircleBorder(),
        backgroundColor:
            isLikedByUser
                ? Colors.redAccent
                : Theme.of(context).colorScheme.primary,
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Icon(
            isLikedByUser ? Icons.favorite : Icons.favorite_border,
            key: ValueKey<bool>(isLikedByUser),
            size: 30,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildIconText(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    Map<String, dynamic> difColors = {
      'ง่าย': Colors.green,
      'ปานกลาง': Colors.orange,
      'ยาก': Colors.red,
    };

    final Color difTextColor;

    if (difColors.containsKey(text)) {
      difTextColor = difColors[text];
    } else {
      difTextColor = Theme.of(context).colorScheme.onSurface;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(fontSize: 16, color: difTextColor)),
      ],
    );
  }
}

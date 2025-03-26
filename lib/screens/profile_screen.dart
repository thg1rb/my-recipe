import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe/providers/bottom_navbar_provider.dart';
import 'package:my_recipe/providers/theme_provider.dart';
import 'package:my_recipe/screens/premium_ad_screen.dart';
import 'package:my_recipe/screens/recipe_grid_screen.dart';
import 'package:my_recipe/services/auth_service.dart';
import 'package:my_recipe/services/recipe_service.dart';
import 'package:my_recipe/services/user_service.dart';

final Size buttonFixedSize = Size.fromWidth(190);

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final AuthServices _authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 70),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Consumer(
            builder: (context, ref, child) {
              return Column(
                children: <Widget>[
                  _ProfileHeader(),
                  SizedBox(height: 20),
                  _ProfileServices(),
                  SizedBox(height: 10),
                  _ProfileSetting(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(fixedSize: buttonFixedSize),
                    onPressed: () async {
                      // Sign Out and Navigate to Login Screen
                      final String? errorMessage =
                          await _authServices.signOut();
                      ScaffoldMessenger.of(context).clearSnackBars();
                      if (errorMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              errorMessage,
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                          ),
                        );
                        return;
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "👋 ออกจากระบบสำเร็จ",
                              style: TextStyle(color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor: Colors.white,
                          ),
                        );
                        // Reset the Bottom Navbar Index to the Home Screen
                        ref.read(bottomNavbarIndexProvider.notifier).state = 0;
                        // Remove all the previous routes from the stack
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Icon(
                          Icons.logout_rounded,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        Text("ออกจากระบบ"),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// Profile Header
class _ProfileHeader extends StatelessWidget {
  _ProfileHeader();

  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String userId = user?.uid ?? '';
    final String email = user?.email ?? 'No Email';

    return StreamBuilder<DocumentSnapshot?>(
      stream: _userService.getUserById(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return Text('User not found');
        } else {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final String username = userData['username'] ?? 'No Username';
          final String profileUrl = userData['profileUrl'] ?? '';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipOval(
                child:
                    profileUrl.isNotEmpty
                        ? Image.network(
                          profileUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                        : Image.asset(
                          "assets/images/default-profile.jpg",
                          width: 100,
                          fit: BoxFit.cover,
                        ),
              ),
              Text(username, style: Theme.of(context).textTheme.headlineLarge),
              Text(email, style: Theme.of(context).textTheme.bodySmall),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(fixedSize: buttonFixedSize),
                child: Text("แก้ไขข้อมูล"),
              ),
              StreamBuilder<bool>(
                stream: _userService.isPremiumUser(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final bool isPremiumUser = snapshot.data ?? false;
                    return isPremiumUser
                        ? SizedBox()
                        : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: buttonFixedSize,
                            backgroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PremiumAdScreen(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(Icons.stars_rounded),
                              Text("สมัครพรีเมียม"),
                            ],
                          ),
                        );
                  }
                },
              ),
            ],
          );
        }
      },
    );
  }
}

// Profile Services
class _ProfileServices extends StatelessWidget {
  _ProfileServices();

  final User _user = FirebaseAuth.instance.currentUser!;
  final RecipeService _recipeService = RecipeService();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("รายการเพิ่มเติม", style: Theme.of(context).textTheme.bodyLarge),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.collections_bookmark_rounded),
                title: Text("สูตรอาหารของฉัน"),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => RecipeGridScreen(
                              title: "สูตรอาหารของฉัน",
                              queryBuilder:
                                  () => _recipeService.getRecipesByUserId(
                                    _user.uid,
                                  ),
                            ),
                      ),
                    );
                  },
                  icon: Icon(Icons.navigate_next_rounded),
                ),
              ),
              Divider(height: 1, indent: 16, endIndent: 16),
              ListTile(
                leading: Icon(Icons.support_agent_rounded),
                title: Text("บริการ & ความช่วยเหลือ"),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/contact-us");
                  },
                  icon: Icon(Icons.navigate_next_rounded),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Profile Setting
class _ProfileSetting extends StatefulWidget {
  const _ProfileSetting();

  @override
  State<_ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<_ProfileSetting> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("การตั้งค่าทั่วไป", style: Theme.of(context).textTheme.bodyLarge),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Consumer(
            builder: (context, ref, child) {
              final currentTheme = Theme.of(context).brightness;
              return Column(
                children: <Widget>[
                  SwitchListTile.adaptive(
                    secondary: Icon(Icons.nights_stay_rounded),
                    activeColor: Theme.of(context).colorScheme.onPrimary,
                    title: Text("โหมดกลางคืน"),
                    value: ref.watch(isDarkTheme),
                    onChanged: (value) {
                      if (currentTheme == Brightness.light) {
                        ref.read(isDarkTheme.notifier).state = true;
                      } else {
                        ref.read(isDarkTheme.notifier).state = false;
                      }
                    },
                  ),
                  Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile.adaptive(
                    secondary: Icon(Icons.notifications_active_rounded),
                    activeColor: Theme.of(context).colorScheme.onPrimary,
                    title: Text("การแจ้งเตือน"),
                    value: false,
                    onChanged: (value) {},
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

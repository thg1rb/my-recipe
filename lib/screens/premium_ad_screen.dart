import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe/providers/bottom_navbar_provider.dart';
import 'package:my_recipe/services/user_service.dart';

class PremiumAdScreen extends StatelessWidget {
  PremiumAdScreen({super.key});

  // Get the current user and user service
  final User user = FirebaseAuth.instance.currentUser!;

  // Create an instance of the user service
  final UserService _userService = UserService();

  // Static method to navigate to this screen with a center popup animation
  static void navigateTo(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => PremiumAdScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Combined scale and fade transition to create a center popup effect
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
        transitionDuration: const Duration(milliseconds: 450),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: StreamBuilder<bool>(
          stream: _userService.isPremiumUser(user.uid),
          builder: (context, premiumSnapshot) {
            if (premiumSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (premiumSnapshot.hasError) {
              return Center(child: Text('Error: ${premiumSnapshot.error}'));
            } else if (!premiumSnapshot.hasData) {
              return const Center(child: Text('No data available'));
            } else {
              bool isPremium = premiumSnapshot.data!;
              return isPremium
                  ? PremiumScreen()
                  : Column(
                    children: [
                      _PremiumAdHeader(),
                      _PremiumAdDetails(),
                      _PremiumAdFooter(),
                    ],
                  );
            }
          },
        ),
      ),
    );
  }
}

class _PremiumAdHeader extends StatelessWidget {
  const _PremiumAdHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "เข้าถึงและรับชม",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 48,
          ),
        ),
        Text(
          "สูตรอาหาร",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 48,
          ),
        ),
        Text(
          "ได้มากขึ้น",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 48,
          ),
        ),
      ],
    );
  }
}

class _PremiumAdDetails extends StatelessWidget {
  const _PremiumAdDetails();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 15),
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Wrap(
        runSpacing: 10,
        children: <Widget>[
          _PremiumAdDetailsCard(
            titleIcon: Icons.sick_rounded,
            title: "ผู้ใช้งานทั่วไป",
            desc:
                "• มีโฆษณาระหว่างการใช้งาน\n• สร้างบันทึกอาหารได้สูงสุด 3 บันทึก\n• ไม่สามารถรับชมและอัปโหลดวิดิโอ",
            color: Theme.of(context).colorScheme.error,
          ),
          _PremiumAdDetailsCard(
            titleIcon: Icons.sick_rounded,
            title: "ผู้ใช้งานพรีเมียม",
            desc:
                "• ไม่มีโฆษณาระหว่างการใช้งาน\n• สร้างบันทึกสูตรอาหารได้ไม่จำกัด\n• สามารถรับชมและอัปโหลดวิดีโอได้",
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _PremiumAdDetailsCard extends StatelessWidget {
  const _PremiumAdDetailsCard({
    required IconData titleIcon,
    required String title,
    required String desc,
    required Color color,
  }) : _titleIcon = titleIcon,
       _title = title,
       _desc = desc,
       _color = color;

  final IconData _titleIcon;
  final String _title;
  final String _desc;
  final Color _color;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      runSpacing: 10,
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(width: 15),
            Icon(_titleIcon, color: _color),
            Text(
              _title,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(color: _color),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: BoxDecoration(
            color: _color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _desc,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              height: 2,
            ),
          ),
        ),
      ],
    );
  }
}

class _PremiumAdFooter extends ConsumerWidget {
  final User _user = FirebaseAuth.instance.currentUser!;
  final UserService _userService = UserService();

  void showConfirmDialog(BuildContext context, WidgetRef ref) {
    // Using custom route for animation - matching the bookmark_screen.dart animation
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black54,
        pageBuilder: (BuildContext context, _, __) {
          return AlertDialog(
            title: Text(
              "ยืนยันการสมัครพรีเมียม",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.yellow[50],
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    Icons.stars_rounded,
                    size: 40,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      ref.read(bottomNavbarIndexProvider.notifier).state = 0;

                      // Update the user's premium expiry date
                      await _userService.updateUserPremiumExpiryDate(_user.uid);
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/home');
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '⭐️ ยินดีต้อนรับสู่การเป็นผู้ใช้งานพรีเมียม ⭐️',
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
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: Text('ยืนยันการชำระเงิน 39฿'),
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
            actionsAlignment: MainAxisAlignment.center,
          );
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          // Combined scale and fade transition (same as in bookmark_screen.dart)
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      direction: Axis.vertical,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            showConfirmDialog(context, ref);
          },
          child: Text("สมัครพรีเมียม"),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            "กดที่นี่เพื่อปิดหน้าต่าง",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.error,
              decoration: TextDecoration.underline,
              decorationColor: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      ],
    );
  }
}

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('คุณได้สมัครสมาชิกไปแล้ว'),
          Text('มีความสุขกับการทำอาหารของคุณ 🍳'),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text('กลับไปยังหน้าโปรไฟล์'),
          ),
        ],
      ),
    );
  }
}

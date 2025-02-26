import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe/providers/theme_provider.dart';

final Size buttonFixedSize = Size.fromWidth(190);
final OutlinedBorder buttonShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(10),
);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 70),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _ProfileHeader(username: "kkerdsiri_", email: "kerdsirija@gmail.com"),
          _ProfileServices(),
          _ProfileSetting(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: buttonFixedSize,
              shape: buttonShape,
            ),
            onPressed: () {},
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
      ),
    );
  }
}

// Profile Header
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required String username, required String email})
    : _username = username,
      _email = email;

  final String _username;
  final String _email;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // Image.network(src)
        ClipOval(
          child: Image.asset(
            "assets/images/default-profile.jpg",
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
        Text(_username, style: Theme.of(context).textTheme.headlineLarge),
        Text(_email, style: Theme.of(context).textTheme.bodySmall),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            fixedSize: buttonFixedSize,
            shape: buttonShape,
          ),
          child: Text("แก้ไขข้อมูล"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: buttonFixedSize,
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            foregroundColor: Theme.of(context).colorScheme.primary,
            shape: buttonShape,
          ),
          onPressed: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.stars_rounded),
              Text("สมัครพรีเมียม"),
            ],
          ),
        ),
      ],
    );
  }
}

// Profile Services
class _ProfileServices extends StatelessWidget {
  const _ProfileServices();

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
                  onPressed: () {},
                  icon: Icon(Icons.navigate_next_rounded),
                ),
              ),
              Divider(height: 1, indent: 16, endIndent: 16),
              ListTile(
                leading: Icon(Icons.support_agent_rounded),
                title: Text("บริการ & ความช่วยเหลือ"),
                trailing: IconButton(
                  onPressed: () {},
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
                  SwitchListTile(
                    secondary: Icon(Icons.nights_stay_rounded),
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
                  SwitchListTile(
                    secondary: Icon(Icons.notifications_active_rounded),
                    title: Text("การแจ้งเตือน"),
                    value: false,
                    onChanged: (value) {},
                  ),
                ],
              );
            }
          ),
        ),
      ],
    );
  }
}

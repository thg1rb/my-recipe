import 'package:flutter/material.dart';
import 'package:my_recipe/widgets/navigation_bar/top_navbar.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(title: "ติดต่อเรา", action: []),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Wrap(
          runSpacing: 20,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                'เบอร์โทรและอีเมล',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: 371,
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Theme.of(context).colorScheme.onPrimary,
                boxShadow: [BoxShadow()],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Wrap(
                  runSpacing: 10,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.phone, size: 30),
                        SizedBox(width: 10),
                        GestureDetector(
                          child: Text(
                            '082-712-5665',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.mail, size: 30),
                        SizedBox(width: 10),
                        GestureDetector(
                          child: Text(
                            'kerdsiri.s@ku.th',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.mail, size: 30),
                        SizedBox(width: 10),
                        GestureDetector(
                          child: Text(
                            'bowornrat.t@ku.th',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                'โซเชียลมีเดีย',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            SocialMediaCard(
              icon: Icons.discord_rounded,
              title: 'tonnamlek',
              url: 'https://www.google.com/',
            ),
            SocialMediaCard(
              icon: Icons.discord_rounded,
              title: 'brightess',
              url: 'http://discordapp.com/users/630783537309810700',
            ),
          ],
        ),
      ),
    );
  }
}

class SocialMediaCard extends StatelessWidget {
  const SocialMediaCard({
    super.key,
    required this.icon,
    required this.title,
    required this.url,
  });
  final IconData icon;
  final String title;
  final String url;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ไม่สามารถเปิดลิงก์นี้ได้: $url')),
          );
        }
      },
      child: Container(
        width: 371,
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Theme.of(context).colorScheme.onPrimary,
          boxShadow: [BoxShadow()],
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48),
              Text(
                title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

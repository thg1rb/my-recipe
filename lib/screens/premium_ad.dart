import 'package:flutter/material.dart';

class PremiumAdScreen extends StatelessWidget {
  const PremiumAdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: <Widget>[
            _PremiumAdHeader(),
            _PremiumAdDetails(),
            _PremiumAdFooter(),
          ],
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
          _PremiumAdDetialsCard(
            titleIcon: Icons.sick_rounded,
            title: "ผู้ใช้งานทั่วไป",
            desc:
                "• มีโฆษณา\n• บุ๊คมาร์คได้สูงสุด 3 หมวดหมู่\n• ไม่สามารถรับชมและอัปโหลดวิดิโอ",
            color: Theme.of(context).colorScheme.error,
          ),
          _PremiumAdDetialsCard(
            titleIcon: Icons.sick_rounded,
            title: "ผู้ใช้งานพรีเมียม",
            desc:
                "• ไม่มีโฆษณา\n• เพิ่มบุ๊คมาร์คได้ไม่จำกัด\n• สามารถรับชมและอัปโหลดวิดีโอได้",
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _PremiumAdDetialsCard extends StatelessWidget {
  const _PremiumAdDetialsCard({
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
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(width: 15,),
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
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
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

class _PremiumAdFooter extends StatelessWidget {
  const _PremiumAdFooter();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton(onPressed: () {}, child: Text("สมัครพรีเมียม")),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
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

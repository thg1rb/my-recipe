import 'package:flutter/material.dart';

class UploadButton extends StatefulWidget {
  const UploadButton({
    super.key,
    required this.btnSize,
    required this.text,
    required this.icon,
    required this.iconSize,
    required this.isRow,
  });

  final Size btnSize;
  final String text;
  final IconData icon;
  final double iconSize;
  final bool isRow;
  @override
  State<UploadButton> createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      Icon(widget.icon, color: Colors.white, size: widget.iconSize),
      Text(
        widget.text,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
      ),
    ];

    if (widget.isRow) widgets.insert(1, const SizedBox(width: 20,));

    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        fixedSize: widget.btnSize,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child:
          widget.isRow
              ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widgets,
              )
              : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widgets,
              ),
    );
  }
}

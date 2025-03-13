import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class UploadButton extends StatefulWidget {
  const UploadButton({
    super.key,
    required this.btnSize,
    required this.text,
    required this.icon,
    required this.iconSize,
    required this.isRow,
    required this.isVideo,
    required this.onFileSelected, // Callback function
  });

  final Size btnSize;
  final String text;
  final IconData icon;
  final double iconSize;
  final bool isRow;
  final bool isVideo;
  final Function(File?) onFileSelected; // Callback to pass file

  @override
  State<UploadButton> createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  File? file;

  Future<void> pickFile() async {
    try {
      final picker = ImagePicker();
      final pickedFile = widget.isVideo
          ? await picker.pickVideo(source: ImageSource.gallery)
          : await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) return;

      final selectedFile = File(pickedFile.path);
      setState(() {
        file = selectedFile;
      });

      widget.onFileSelected(selectedFile); // Call callback
    } on PlatformException catch (e) {
      print('Failed to pick file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      Icon(widget.icon, color: Theme.of(context).colorScheme.onPrimary, size: widget.iconSize),
      Text(
        widget.text,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal, color: Theme.of(context).colorScheme.onPrimary),
      ),
    ];

    if (widget.isRow) widgets.insert(1, const SizedBox(width: 20));

    return GestureDetector(
      onTap: pickFile, // Use single method for both image and video
      child: Container(
        width: widget.btnSize.width,
        height: widget.btnSize.height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          image: file != null ? DecorationImage(image: FileImage(file!), fit: BoxFit.cover) : null,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: widget.isRow
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widgets,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widgets,
              ),
      ),
    );
  }
}

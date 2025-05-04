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
    this.selectedImageUrl, // Add Selected image URL
    this.selectedVideoFilename, // Add Selected video filename
  });

  final Size btnSize;
  final String text;
  final IconData icon;
  final double iconSize;
  final bool isRow;
  final bool isVideo;
  final Function(File?) onFileSelected; // Callback to pass file
  final String? selectedImageUrl; // Selected image URL from Supabase
  final String? selectedVideoFilename; // Selected video filename

  @override
  State<UploadButton> createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  File? file;
  Future<void> pickFile() async {
    try {
      final picker = ImagePicker();
      final pickedFile =
          widget.isVideo
              ? await picker.pickVideo(source: ImageSource.gallery)
              : await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) return;

      final selectedFile = File(pickedFile.path);
      
      if (mounted) {
        setState(() {
          file = selectedFile;
        });
      }

      widget.onFileSelected(selectedFile); // Call callback
    } on PlatformException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('อัปโหลดไฟล์ล้มเหลว')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      Icon(
        widget.icon,
        color: Theme.of(context).colorScheme.onPrimary,
        size: widget.iconSize,
      ),
      Text(
        widget.isVideo && file != null ? 'อัปโหลดวิดีโอแล้ว' : widget.text,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.normal,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    ];

    if (widget.isRow) widgets.insert(1, const SizedBox(width: 20));

    // Display the previous image or video filename if available
    if (widget.selectedImageUrl != null && !widget.isVideo) {
      widgets = [
        Image.network(
          widget.selectedImageUrl!,
          width: widget.btnSize.width,
          height: widget.btnSize.height,
          fit: BoxFit.cover,
        ),
      ];
    } else if (widget.selectedVideoFilename != null && widget.isVideo) {
      // Add the video filename to the existing widgets
      widgets = [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            widget.selectedVideoFilename!.split('/').last,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ];
    }

    return GestureDetector(
      onTap: pickFile, // Use single method for both image and video
      child: Container(
        width: widget.btnSize.width,
        height: widget.btnSize.height,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          image:
              file != null && !widget.isVideo
                  ? DecorationImage(image: FileImage(file!), fit: BoxFit.cover)
                  : null,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child:
            widget.isRow
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      widgets.length > 1
                          ? widgets
                          : widgets
                              .map((widgets) => Expanded(child: widgets))
                              .toList(),
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widgets,
                ),
      ),
    );
  }
}

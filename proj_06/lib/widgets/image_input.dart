import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onSelectImage});

  final void Function(File image) onSelectImage;

  @override
  State<ImageInput> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;

  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickerImg =
        // await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);
        await imagePicker.pickImage(source: ImageSource.gallery, maxWidth: 600);
    if (pickerImg == null) {
      return;
    }

    setState(() {
      _selectedImage = File(pickerImg.path);
    });

    widget.onSelectImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _selectedImage == null
        ? TextButton.icon(
            onPressed: _takePicture,
            icon: const Icon(Icons.camera),
            label: const Text('Take picture'))
        : GestureDetector(
            onTap: _takePicture,
            child: Image.file(
              _selectedImage!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          );

    return Container(
      height: 250,
      width: double.infinity,
      //center the child both in vertical and horizontal
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: content,
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserimagePicker extends StatefulWidget {
  final void Function(File image) onImagePick;
  const UserimagePicker({required this.onImagePick, super.key});

  @override
  State<UserimagePicker> createState() => _UserimagePickerState();
}

class _UserimagePickerState extends State<UserimagePicker> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });

      widget.onImagePick(_image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _image != null ? FileImage(_image!) : null,
        ),
        TextButton(
            onPressed: _pickImage,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('Adicionar Imagem')
              ],
            ))
      ],
    );
  }
}

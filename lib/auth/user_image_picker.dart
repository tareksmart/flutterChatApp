import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({Key? key}) : super(key: key);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('late.............');
  }

  late File _pickedImage = new File('path');

  final ImagePicker _picker = ImagePicker();
  void _pickImage(ImageSource src) async {
    final pickedImageFile = await _picker.getImage(source: src);
    if (pickedImageFile != null) {
      setState(() {
        _pickedImage = File(pickedImageFile.path);
      });
    } else
      print('no image picked');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 100,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage) : null,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: Icon(Icons.photo_camera_outlined),
              tooltip: 'take photo',
            ),
            IconButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: Icon(Icons.browse_gallery),
              tooltip: 'browse photo',
            ),
          ],
        )
      ],
    );
  }
}

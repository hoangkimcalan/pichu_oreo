import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      backgroundColor: Color.fromARGB(255, 207, 118, 148),
    ),
  );
}

Future<List<File>> pickImages() async {
  List<File> images = [];

  try {
    var files = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (files != null && files.files.isNotEmpty) {
      for (var i = 0; i < files.files.length; i++) {
        images.add(File(files.files[i].path!));
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }

  return images;
}

Future<List<File>> takeImage(ImageSource source) async {
  List<File> images = [];

  final ImagePicker imagePicker = ImagePicker();

  try {
    XFile? file = await imagePicker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 800,
      maxHeight: 600,
    );

    if (file != null) {
      images.add(File(file.path));
    }
  } catch (e) {
    debugPrint(e.toString());
  }

  return images;
}

String getFormattedTime(String time) {
  DateTime isoDate = DateTime.parse(time);
  String formattedDate = DateFormat('MMM d, y').format(isoDate);
  return formattedDate;
}

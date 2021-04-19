import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;

class Utils {
  static String getUserName(String email) {
    return "live:${email.split('@')[0]}";
  }

  static String getInitials(String name) {
    List<String> nameSplit = name.split(" ");
    String firstNameInitial = nameSplit[0][0];
    String lastNameInitials = nameSplit[1][0];

    return firstNameInitial + lastNameInitials;
  }

  static Future<File> pickImage({@required ImageSource source}) async {
    PickedFile selectedImage = await ImagePicker().getImage(
        source: source, maxHeight: 500, maxWidth: 500, imageQuality: 85);
    return File(selectedImage.path);
  }

  // static Future<PickedFile> conpressImage(PickedFile imageToCompress) async {
  //   final tempDir = await getTemporaryDirectory();

  //   final path = tempDir.path;

  //   int random = Random().nextInt(1000);

  //   Im.Image image = Im.decodeImage(imageToCompress.readAsBytes());
  //   Im.copyResize(image, width: 500, height: 500);
  //   return new PickedFile('$path/img_$random.jpg')
  // }
}

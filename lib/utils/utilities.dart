import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:skype_clone/enum/user_state.dart';

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

  static int stateToNum(UserState userState) {
    switch (userState) {
      case UserState.Offline:
        return 0;

      case UserState.Online:
        return 1;

      default:
        return 2;
    }
  }

  static UserState numToState(int number) {
    switch (number) {
      case 0:
        return UserState.Offline;

      case 1:
        return UserState.Online;

      default:
        return UserState.Waiting;
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:skype_clone/enum/view_state.dart';
import 'package:skype_clone/models/user.dart';
import 'package:skype_clone/resources/firebaseRepository.dart';

class UserProvider with ChangeNotifier {
  NormalUser _user;

  FirebaseRepository firebaseRepository = FirebaseRepository();

  NormalUser get getUser => _user;

  void refreshUser() async {
    NormalUser user = await firebaseRepository.getUserDetails();
    _user = user;
    notifyListeners();
  }
}

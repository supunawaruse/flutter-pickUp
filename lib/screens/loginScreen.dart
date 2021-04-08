import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/resources/firebaseRepository.dart';
import 'package:skype_clone/screens/homeScreen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseRepository _repository = FirebaseRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loginButton(),
    );
  }

  Widget loginButton() {
    return TextButton(
      onPressed: () => performLogin(),
      child: Text(
        'Login',
        style: TextStyle(fontSize: 35),
      ),
    );
  }

  void performLogin() {
    _repository.signIn().then((UserCredential userCredential) => {
          if (userCredential.user != null)
            {authenticateUser(userCredential.user)}
          else
            {print("There was an error")}
        });
  }

  void authenticateUser(User user) {
    _repository.authenticateUser(user).then((isNewUser) => {
          if (isNewUser)
            {
              _repository.addDataToDatabase(user).then((value) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return HomeScreen();
                }));
              })
            }
          else
            {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return HomeScreen();
              }))
            }
        });
  }
}

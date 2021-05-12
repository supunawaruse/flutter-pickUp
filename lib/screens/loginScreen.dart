import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skype_clone/resources/firebaseMethods.dart';
import 'package:skype_clone/resources/firebaseRepository.dart';
import 'package:skype_clone/screens/homeScreen.dart';
import 'package:skype_clone/utils/universal_variables.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseRepository _repository = FirebaseRepository();

  bool isLoginPressed = false;

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: UniversalVariables.blackColor,
  //     body: Stack(
  //       children: [
  //         Center(
  //           child: loginButton(),
  //         ),
  //         isLoginPressed
  //             ? Center(
  //                 child: CircularProgressIndicator(),
  //               )
  //             : Container()
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Container(
                height: (MediaQuery.of(context).size.height),
                width: (MediaQuery.of(context).size.width),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Column(
                      children: [
                        Text(
                          'PickUp',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xff36454f),
                              fontSize: 48,
                              fontFamily: 'Pacifico'),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height:
                              (MediaQuery.of(context).size.height) * 40 / 100,
                          width: (MediaQuery.of(context).size.width) - 20,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: ExactAssetImage(
                                      'assets/img/loginImage.png'),
                                  fit: BoxFit.cover)),
                        ),
                        SizedBox(height: 20),
                        loginButton()
                      ],
                    ),
                  ),
                ))));
  }

  Widget loginButton() {
    return Shimmer.fromColors(
      baseColor: Color(0xFF9f2b5c),
      highlightColor: Colors.white,
      child: TextButton(
        onPressed: () => performLogin(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Let\'s go',
              style: TextStyle(fontSize: 22),
            ),
            Icon(Icons.arrow_forward)
          ],
        ),
      ),
    );
  }

  void performLogin() {
    setState(() {
      isLoginPressed = true;
    });

    _repository.signIn().then((UserCredential userCredential) => {
          if (userCredential.user != null)
            {authenticateUser(userCredential.user)}
          else
            {print("There was an error")}
        });
  }

  Future<void> saveTokenToDatabase(String token) async {
    // Assume user is logged in for this example
    String userId = FirebaseAuth.instance.currentUser.uid;

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'tokens': FieldValue.arrayUnion([token]),
    });
  }

  Future<void> addToken() async {
    String token = await FirebaseMessaging.instance.getToken();

    // Save the initial token to the database
    await saveTokenToDatabase(token);

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  void authenticateUser(User user) {
    _repository.authenticateUser(user).then((isNewUser) {
      setState(() {
        isLoginPressed = false;
      });
      if (isNewUser) {
        addToken();
        _repository.addDataToDatabase(user).then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));
        });
      } else {
        addToken();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      }
    });
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:skype_clone/resources/firebaseRepository.dart';
import 'package:skype_clone/screens/homeScreen.dart';
import 'package:skype_clone/screens/loginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skype_clone/screens/searchScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    FirebaseRepository _repository = FirebaseRepository();

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        theme: ThemeData(brightness: Brightness.dark),
        routes: {
          '/search_screen': (context) => SearchScreen(),
        },
        title: "Skype",
        home: FutureBuilder(
            future: _repository.getCurrentUser(),
            builder: (context, AsyncSnapshot<User> snapshot) {
              if (snapshot.hasData) {
                print('hoto hoe');
                return HomeScreen();
              } else {
                print('supua');
                return LoginScreen();
              }
            }));
  }
}

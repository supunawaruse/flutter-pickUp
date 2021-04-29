import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/provider/image_upload_provider.dart';
import 'package:skype_clone/provider/user_provider.dart';
import 'package:skype_clone/resources/firebaseRepository.dart';
import 'package:skype_clone/screens/homeScreen.dart';
import 'package:skype_clone/screens/loginScreen.dart';
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
  FirebaseRepository _repository = FirebaseRepository();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider())
      ],
      child: MaterialApp(
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
                  return HomeScreen();
                } else {
                  return LoginScreen();
                }
              })),
    );
  }
}

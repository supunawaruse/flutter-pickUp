import 'package:firebase_auth/firebase_auth.dart';
import 'package:skype_clone/resources/firebaseMethods.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  Future<User> getCurrentUser() => _firebaseMethods.getCurrentUser();

  Future<UserCredential> signIn() => _firebaseMethods.signIn();

  Future<bool> authenticateUser(User user) =>
      _firebaseMethods.authenticateUser(user);

  Future<void> addDataToDatabase(User user) =>
      _firebaseMethods.addDataToDatabase(user);

  Future<void> signOut() => _firebaseMethods.signOut();
}

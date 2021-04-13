import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skype_clone/models/user.dart';
import 'package:skype_clone/utils/utilities.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  NormalUser normalUser = NormalUser();

// Get current firebase Authenticated user
  Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = await _auth.currentUser;
    return currentUser;
  }

// SignIn function
  Future<UserCredential> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: _signInAuthentication.accessToken,
        idToken: _signInAuthentication.idToken);

    UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    return userCredential;
  }

// Chekck whether there is an user with giving user details
  Future<bool> authenticateUser(User user) async {
    QuerySnapshot result = await firestore
        .collection('users')
        .where("email", isEqualTo: user.email)
        .get();

    final List<DocumentSnapshot> docs = result.docs;
    return docs.length == 0 ? true : false;
  }

// If user is not an existing user then add user data to firestore
  Future<void> addDataToDatabase(User currentUser) async {
    String username = Utils.getUserName(currentUser.email);

    normalUser = NormalUser(
      uid: currentUser.uid,
      email: currentUser.email,
      name: currentUser.displayName,
      profilePhoto: currentUser.photoURL,
      username: username,
    );

    firestore
        .collection('users')
        .doc(currentUser.uid)
        .set(normalUser.toMap(normalUser));
  }

  // SignOut from the application
  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();

    await _auth.signOut();
  }

  //get all firebase users
  Future<List<NormalUser>> fetchAllUsers(User currentUser) async {
    List<NormalUser> userList = [];
    QuerySnapshot querySnapshot = await firestore.collection('users').get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != currentUser.uid) {
        userList.add(NormalUser.fromMap(querySnapshot.docs[i].data()));
      }
    }

    return userList;
  }
}

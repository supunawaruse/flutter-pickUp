import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skype_clone/enum/user_state.dart';
import 'package:skype_clone/models/contact.dart';
import 'package:skype_clone/models/message.dart';
import 'package:skype_clone/models/user.dart';
import 'package:skype_clone/provider/image_upload_provider.dart';
import 'package:skype_clone/utils/utilities.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  NormalUser normalUser = NormalUser();

  Reference _storageReference;

// Get current firebase Authenticated user
  Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = await _auth.currentUser;
    return currentUser;
  }

  Future<NormalUser> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot =
          await firestore.collection('users').doc(id).get();
      return NormalUser.fromMap(documentSnapshot.data());
    } catch (e) {
      print(e);
      return null;
    }
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
  Future<bool> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      return true;
    } catch (e) {
      return false;
    }
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

  //add message to database
  //
  Future<void> addMessageToDb(
      Message message, NormalUser sender, NormalUser receiver) async {
    var map = message.toMap();

    await firestore
        .collection('messages')
        .doc(message.senderId)
        .collection(message.receiverId)
        .add(map);

    addToContacts(senderId: message.senderId, receiverId: message.receiverId);

    await firestore
        .collection('messages')
        .doc(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  DocumentReference getContactsDocument({String of, String forContact}) =>
      firestore
          .collection('users')
          .doc(of)
          .collection('contacts')
          .doc(forContact);

  addToContacts({String senderId, String receiverId}) async {
    Timestamp currentTime = Timestamp.now();

    await addToSenderContacts(senderId, receiverId, currentTime);
    await addToReceiverContacts(senderId, receiverId, currentTime);
  }

  Future<void> addToSenderContacts(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot senderSnapshot =
        await getContactsDocument(of: senderId, forContact: receiverId).get();

    if (!senderSnapshot.exists) {
      //does not exists
      Contact receiverContact = Contact(
        uid: receiverId,
        addedOn: currentTime,
      );

      var receiverMap = receiverContact.toMap(receiverContact);

      await getContactsDocument(of: senderId, forContact: receiverId)
          .set(receiverMap);
    }
  }

  Future<void> addToReceiverContacts(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot receiverSnapshot =
        await getContactsDocument(of: receiverId, forContact: senderId).get();

    if (!receiverSnapshot.exists) {
      //does not exists
      Contact senderContact = Contact(
        uid: senderId,
        addedOn: currentTime,
      );

      var senderMap = senderContact.toMap(senderContact);

      await getContactsDocument(of: receiverId, forContact: senderId)
          .set(senderMap);
    }
  }

  Stream<QuerySnapshot> fetchContacts({String userId}) => firestore
      .collection('users')
      .doc(userId)
      .collection('contacts')
      .snapshots();

  Stream<QuerySnapshot> fetchLastMessageBetween({
    @required String senderId,
    @required String receiverId,
  }) =>
      firestore
          .collection('messages')
          .doc(senderId)
          .collection(receiverId)
          .orderBy("timestamp")
          .snapshots();

  void uploadImage(File image, String receiverId, String senderId,
      ImageUploadProvider imageUploadProvider) async {
    imageUploadProvider.setToLoading();
    String url = await uploadImageToStorage(image);
    print(url);
    imageUploadProvider.setToIdle();
    setImageMsg(url, receiverId, senderId);
  }

  Future<String> uploadImageToStorage(File image) async {
    _storageReference = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');

    UploadTask _uploadTask = _storageReference.putFile(image);
    String url;
    await _uploadTask.whenComplete(() async {
      url = await _uploadTask.snapshot.ref.getDownloadURL();
    });

    return url;
  }

  void setImageMsg(String url, String receiverId, String senderId) async {
    Message _message;

    _message = Message.imageMessage(
        message: "Image",
        receiverId: receiverId,
        senderId: senderId,
        photoUrl: url,
        type: "image",
        timestamp: Timestamp.now());

    var map = _message.toImageMap();

    await firestore
        .collection('messages')
        .doc(_message.senderId)
        .collection(_message.receiverId)
        .add(map);

    await firestore
        .collection('messages')
        .doc(_message.receiverId)
        .collection(_message.senderId)
        .add(map);
  }

  Future<NormalUser> getUserDetails() async {
    User currentUser = await getCurrentUser();
    DocumentSnapshot documentSnapshot =
        await firestore.collection('users').doc(currentUser.uid).get();

    return NormalUser.fromMap(documentSnapshot.data());
  }

  void setUserState({@required String userId, @required UserState userState}) {
    int stateNum = Utils.stateToNum(userState);

    firestore.collection('users').doc(userId).update({
      "state": stateNum,
    });
  }

  Stream<DocumentSnapshot> getUserStream({@required String uid}) =>
      firestore.collection('users').doc(uid).snapshots();
}

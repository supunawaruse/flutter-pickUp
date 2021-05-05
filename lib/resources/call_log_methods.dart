import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skype_clone/models/flog.dart';

class LogMethods {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // find the relevant document

  DocumentReference getLogDocument({String of}) =>
      firestore.collection('users').doc(of).collection('logs').doc();

// add To Log

  addToLogs({String callerId, String receiverId, String callStatus}) async {
    Timestamp currentTime = Timestamp.now();

    await addToCallerLog(callerId, receiverId, callStatus, currentTime);
    // await addToReceiverLog(callerId, receiverId, callStatus, currentTime);
  }

  Future<void> addToCallerLog(
    String callerId,
    String receiverId,
    String callStatus,
    currentTime,
  ) async {
    FLog receiverLog =
        FLog(uid: receiverId, addedOn: currentTime, callStatus: callStatus);

    var receiverMap = receiverLog.toMap(receiverLog);

    await getLogDocument(of: callerId).set(receiverMap);
  }

  Future<void> addToReceiverLog(
    String callerId,
    String receiverId,
    String callStatus,
    currentTime,
  ) async {
    FLog callerLog =
        FLog(uid: receiverId, addedOn: currentTime, callStatus: callStatus);

    var receiverMap = callerLog.toMap(callerLog);

    await getLogDocument(of: receiverId).set(receiverMap);
  }

  // fetch all logs

  Stream<QuerySnapshot> fetchLog({String userId}) =>
      firestore.collection('users').doc(userId).collection('logs').snapshots();

  // delete log from database

  Future<void> deleteLogFromUser({String of, String doc}) async {
    await firestore
        .collection('users')
        .doc(of)
        .collection('logs')
        .doc(doc)
        .delete();
  }

  Future<void> deleteAllLogs({String of}) async {
    firestore
        .collection('users')
        .doc(of)
        .collection('logs')
        .get()
        .then((snapshot) => {
              for (DocumentSnapshot ds in snapshot.docs) {ds.reference.delete()}
            });
  }
}

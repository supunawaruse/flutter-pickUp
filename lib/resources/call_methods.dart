import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:skype_clone/models/call.dart';

class CallMethods {
  final CollectionReference callCollection =
      FirebaseFirestore.instance.collection('call');

  Stream<DocumentSnapshot> callStream({String uid}) =>
      callCollection.doc(uid).snapshots();

  Future<bool> makeCall({Call call}) async {
    try {
      call.hasDialled = true;
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      call.hasDialled = false;
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      await callCollection.doc(call.callerId).set(hasDialledMap);
      await callCollection.doc(call.receiverId).set(hasNotDialledMap);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Map<String, dynamic>> makeCloudCall({Call call}) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('createCallsWithTokens');
      dynamic resp = await callable.call({
        "callerId": call.callerId,
        "callerName": call.callerName,
        "callerPic": call.callerPic,
        "receiverId": call.receiverId,
        "receiverName": call.receiverName,
        "receiverPic": call.receiverPic,
      });

      Map<String, dynamic> res = {
        'token': resp.data['data']['token'],
        'channelId': resp.data['data']['channelId']
      };
      return res;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> endCall({Call call}) async {
    try {
      await callCollection.doc(call.callerId).delete();
      await callCollection.doc(call.receiverId).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

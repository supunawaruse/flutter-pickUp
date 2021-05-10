import 'package:cloud_firestore/cloud_firestore.dart';

class FLog {
  String uid;
  Timestamp addedOn;
  String callStatus;

  FLog({this.uid, this.addedOn, this.callStatus});

  // to map
  Map<String, dynamic> toMap(FLog flog) {
    Map<String, dynamic> logMap = Map();
    logMap["logId"] = flog.uid;
    logMap["addedOn"] = flog.addedOn;
    logMap["callStatus"] = flog.callStatus;

    return logMap;
  }

  FLog.fromMap(Map logMap) {
    this.uid = logMap["logId"];
    this.addedOn = logMap["addedOn"];
    this.callStatus = logMap["callStatus"];
  }
}

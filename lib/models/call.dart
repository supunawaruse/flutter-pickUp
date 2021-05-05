class Call {
  String callerId;
  String callerName;
  String callerPic;
  String receiverId;
  String receiverName;
  String receiverPic;
  String channelId;
  bool hasDialed;
  String type;
  String token;

  Call(
      {this.callerId,
      this.callerName,
      this.callerPic,
      this.receiverId,
      this.receiverName,
      this.receiverPic,
      this.channelId,
      this.hasDialed,
      this.type,
      this.token});

  // to map
  Map<String, dynamic> toMap(Call call) {
    Map<String, dynamic> callMap = Map();
    callMap["callerId"] = call.callerId;
    callMap["callerName"] = call.callerName;
    callMap["callerPic"] = call.callerPic;
    callMap["receiverId"] = call.receiverId;
    callMap["receiverName"] = call.receiverName;
    callMap["receiverPic"] = call.receiverPic;
    callMap["channelId"] = call.channelId;
    callMap["hasDialed"] = call.hasDialed;
    callMap["type"] = call.type;
    callMap["token"] = call.token;
    return callMap;
  }

  Call.fromMap(Map callMap) {
    this.callerId = callMap["callerId"];
    this.callerName = callMap["callerName"];
    this.callerPic = callMap["callerPic"];
    this.receiverId = callMap["receiverId"];
    this.receiverName = callMap["receiverName"];
    this.receiverPic = callMap["receiverPic"];
    this.channelId = callMap["channelId"];
    this.hasDialed = callMap["hasDialed"];
    this.token = callMap["token"];
    this.type = callMap["type"];
  }
}

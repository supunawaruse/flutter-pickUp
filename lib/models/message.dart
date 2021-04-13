import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderId;
  String receiverId;
  String type;
  String message;
  Timestamp timestamp;
  String photoUrl;

  Message(
      {this.message,
      this.receiverId,
      this.senderId,
      this.timestamp,
      this.type});

  Message.imageMessage(
      {this.senderId,
      this.receiverId,
      this.type,
      this.timestamp,
      this.message,
      this.photoUrl});

  Map toMap() {
    var map = Map<String, dynamic>();
    map['senderId'] = this.senderId;
    map['receiverId'] = this.receiverId;
    map['message'] = this.message;
    map['type'] = this.type;
    map['timestamp'] = this.timestamp;

    return map;
  }

  Message.fromMap(Map<String, dynamic> map) {
    this.senderId = map['senderId'];
    this.receiverId = map['receiverId'];
    this.message = map['message'];
    this.type = map['type'];
    this.timestamp = map['timestamp'];
  }
}

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/models/call.dart';
import 'package:skype_clone/models/flog.dart';
import 'package:skype_clone/models/log.dart';
import 'package:skype_clone/models/user.dart';
import 'package:skype_clone/resources/call_log_methods.dart';
import 'package:skype_clone/resources/call_methods.dart';
import 'package:skype_clone/resources/local_db/repository/log_repository.dart';
import 'package:skype_clone/screens/callScreens/call_screen.dart';
import 'package:skype_clone/screens/callScreens/voiceCall_screen.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();
  static final LogMethods logMethods = LogMethods();

  static dial({NormalUser from, NormalUser to, context}) async {
    Call call = Call(
        callerId: from.uid,
        callerName: from.name,
        callerPic: from.profilePhoto,
        receiverId: to.uid,
        receiverName: to.name,
        hasDialed: true,
        token: '',
        receiverPic: to.profilePhoto,
        channelId: '',
        type: "video");

    Log log = Log(
      callerName: from.name,
      callerPic: from.profilePhoto,
      callStatus: 'dialed',
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      timestamp: DateTime.now().toString(),
    );

    Map<String, dynamic> result = await callMethods.makeCloudCall(call: call);

    // call.hasDialed = true;

    Call callWithToken = Call(
        callerId: from.uid,
        callerName: from.name,
        callerPic: from.profilePhoto,
        receiverId: to.uid,
        receiverName: to.name,
        receiverPic: to.profilePhoto,
        channelId: result['channelId'],
        hasDialed: true,
        type: "video",
        token: result['token']);

    if (result['token'] != '') {
      LogRepository.addLogs(log);
      logMethods.addToLogs(
          callerId: from.uid, receiverId: to.uid, callStatus: 'dialed');
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(call: callWithToken),
          ));
    }
  }

  static voiceDial({NormalUser from, NormalUser to, context}) async {
    Call call = Call(
        callerId: from.uid,
        callerName: from.name,
        callerPic: from.profilePhoto,
        receiverId: to.uid,
        receiverName: to.name,
        hasDialed: true,
        token: '',
        receiverPic: to.profilePhoto,
        channelId: '',
        type: "voice");

    Log log = Log(
      callerName: from.name,
      callerPic: from.profilePhoto,
      callStatus: 'dialed',
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      timestamp: DateTime.now().toString(),
    );

    Map<String, dynamic> result = await callMethods.makeCloudCall(call: call);

    Call callWithToken = Call(
        callerId: from.uid,
        callerName: from.name,
        callerPic: from.profilePhoto,
        receiverId: to.uid,
        receiverName: to.name,
        receiverPic: to.profilePhoto,
        channelId: result['channelId'],
        hasDialed: true,
        type: "voice",
        token: result['token']);

    if (result['token'] != '') {
      LogRepository.addLogs(log);
      logMethods.addToLogs(
          callerId: from.uid, receiverId: to.uid, callStatus: 'dialed');
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VoiceCallScreen(call: callWithToken),
          ));
    }

    // if (callMade) {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => VoiceCallScreen(call: call),
    //       ));
    // }
  }
}

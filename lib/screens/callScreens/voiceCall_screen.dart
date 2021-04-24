import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/configs/agora_configs.dart';
import 'package:skype_clone/models/call.dart';
import 'package:skype_clone/provider/user_provider.dart';
import 'package:skype_clone/resources/call_methods.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceCallScreen extends StatefulWidget {
  final Call call;
  // final ClientRole role;

  VoiceCallScreen({@required this.call});

  @override
  _VoiceCallScreenState createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<VoiceCallScreen> {
  final CallMethods callMethods = CallMethods();

  UserProvider userProvider;
  StreamSubscription callStreamSubscription;

  bool _joined = false;
  int _remoteUid = null;
  bool _switch = false;

  @override
  void dispose() {
    super.dispose();
    callStreamSubscription.cancel();
  }

  @override
  void initState() {
    super.initState();
    addPostFrameCallback();
    initPlatformState();
  }

  // Initialize the app
  Future<void> initPlatformState() async {
    // Create RTC client instance
    RtcEngineConfig config = RtcEngineConfig(APP_ID);
    var engine = await RtcEngine.createWithConfig(config);
    // Define event handler
    engine.setEventHandler(RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
      print('joinChannelSuccess ${channel} ${uid}');
      setState(() {
        _joined = true;
      });
    }, userJoined: (int uid, int elapsed) {
      print('userJoined ${uid}');
      setState(() {
        _remoteUid = uid;
      });
    }, userOffline: (int uid, UserOfflineReason reason) {
      callMethods.endCall(call: widget.call);
      print('userOffline ${uid}');
      setState(() {
        _remoteUid = null;
      });
    }));
    // Join channel 123
    await engine.joinChannel(
        '00664b69ba11ab340679b6bcd0a3cb3823eIACqYw82rWKrYuXcI+ltAwf2ow8nLHIMVFDAZan+U1J9zwx+f9gAAAAAEACHBVD5diGEYAEAAQB2IYRg',
        'test',
        null,
        0);
  }

  addPostFrameCallback() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      userProvider = Provider.of<UserProvider>(context, listen: false);

      callStreamSubscription = callMethods
          .callStream(uid: userProvider.getUser.uid)
          .listen((DocumentSnapshot ds) {
        // defining the logic
        switch (ds.data()) {
          case null:
            // snapshot is null which means that call is hanged and documents are deleted
            Navigator.pop(context);
            break;

          default:
            break;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[Text("Calling screen")],
        ),
      ),
    );
  }
}

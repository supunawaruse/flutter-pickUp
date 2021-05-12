import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/models/call.dart';
import 'package:skype_clone/models/log.dart';
import 'package:skype_clone/provider/user_provider.dart';
import 'package:skype_clone/resources/call_log_methods.dart';
import 'package:skype_clone/resources/call_methods.dart';
import 'package:skype_clone/resources/local_db/repository/log_repository.dart';
import 'package:skype_clone/screens/cachedImage.dart';
import 'package:skype_clone/screens/callScreens/voiceCall_screen.dart';

class VoicePickupScreen extends StatefulWidget {
  final Call call;

  VoicePickupScreen({
    @required this.call,
  });

  @override
  _VoicePickupScreenState createState() => _VoicePickupScreenState();
}

class _VoicePickupScreenState extends State<VoicePickupScreen> {
  final CallMethods callMethods = CallMethods();
  final LogMethods logMethods = LogMethods();

  bool isCallMissed = true;

  addToLocalStorage({@required String callStatus}) {
    Log log = Log(
      callerName: widget.call.callerName,
      callerPic: widget.call.callerPic,
      receiverName: widget.call.receiverName,
      receiverPic: widget.call.receiverPic,
      timestamp: DateTime.now().toString(),
      callStatus: callStatus,
    );

    LogRepository.addLogs(log);
    logMethods.addToLogs(
        callerId: widget.call.callerId,
        receiverId: widget.call.receiverId,
        callStatus: callStatus);
  }

  Future<bool> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterRingtonePlayer.playRingtone();
  }

  @override
  void dispose() {
    if (isCallMissed) {
      addToLocalStorage(callStatus: 'missed');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xff36454f),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Voice Call Incoming...",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(
              widget.call.callerName,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white),
            ),
            SizedBox(height: 5),
            Container(
              width: 150.0,
              height: 150.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      widget.call.callerId == userProvider.getUser.uid
                          ? widget.call.receiverPic
                          : widget.call.callerPic,
                    )),
                borderRadius: BorderRadius.all(Radius.circular(75.0)),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.call_end),
                  color: Colors.redAccent,
                  onPressed: () async {
                    isCallMissed = false;
                    addToLocalStorage(callStatus: 'received');
                    await callMethods.endCall(call: widget.call);
                    FlutterRingtonePlayer.stop();
                  },
                ),
                SizedBox(width: 25),
                IconButton(
                    icon: Icon(Icons.call),
                    color: Colors.green,
                    onPressed: () async => {
                          isCallMissed = false,
                          addToLocalStorage(callStatus: 'received'),
                          await FlutterRingtonePlayer.stop(),
                          (await _handleCameraAndMic(Permission.camera) &&
                                  await _handleCameraAndMic(
                                      Permission.microphone))
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        VoiceCallScreen(call: widget.call),
                                  ),
                                )
                              : {}
                        }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

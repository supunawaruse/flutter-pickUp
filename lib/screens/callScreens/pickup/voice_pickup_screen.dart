import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skype_clone/models/call.dart';
import 'package:skype_clone/resources/call_methods.dart';
import 'package:skype_clone/screens/cachedImage.dart';
import 'package:skype_clone/screens/callScreens/voiceCall_screen.dart';
import 'package:skype_clone/utils/permissions.dart';

class VoicePickupScreen extends StatelessWidget {
  final Call call;
  final CallMethods callMethods = CallMethods();

  VoicePickupScreen({
    @required this.call,
  });

  Future<bool> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Voice Call Incoming...",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(height: 10),
            CachedImage(call.callerPic, isRound: true, radius: 180),
            SizedBox(height: 15),
            Text(
              call.callerName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 75),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.call_end),
                  color: Colors.redAccent,
                  onPressed: () async {
                    await callMethods.endCall(call: call);
                  },
                ),
                SizedBox(width: 25),
                IconButton(
                    icon: Icon(Icons.call),
                    color: Colors.green,
                    onPressed: () async => {
                          (await _handleCameraAndMic(Permission.camera) &&
                                  await _handleCameraAndMic(
                                      Permission.microphone))
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        VoiceCallScreen(call: call),
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

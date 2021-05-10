import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/models/flog.dart';
import 'package:skype_clone/models/user.dart';
import 'package:skype_clone/provider/user_provider.dart';
import 'package:skype_clone/resources/call_log_methods.dart';
import 'package:skype_clone/resources/firebaseMethods.dart';
import 'package:skype_clone/screens/cachedImage.dart';
import 'package:skype_clone/utils/utilities.dart';
import 'package:skype_clone/widgets/customTile.dart';

class FLogListContainer extends StatefulWidget {
  final FLog fLog;
  final String docId;

  FLogListContainer({this.fLog, this.docId});

  @override
  _FLogListContainerState createState() => _FLogListContainerState();
}

class _FLogListContainerState extends State<FLogListContainer> {
  final FirebaseMethods firebaseMethods = FirebaseMethods();
  final LogMethods logMethods = LogMethods();

  getIcon(String callStatus) {
    Icon _icon;
    double _iconSize = 15;

    switch (callStatus) {
      case 'dialed':
        _icon = Icon(
          Icons.call_made,
          size: _iconSize,
          color: Colors.green,
        );
        break;

      case 'missed':
        _icon = Icon(
          Icons.call_missed,
          color: Colors.red,
          size: _iconSize,
        );
        break;

      default:
        _icon = Icon(
          Icons.call_received,
          size: _iconSize,
          color: Colors.grey,
        );
        break;
    }

    return Container(
      margin: EdgeInsets.only(right: 5),
      child: _icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return FutureBuilder(
      future: firebaseMethods.getUserDetailsById(widget.fLog.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          NormalUser user = snapshot.data;
          bool hasDialled = widget.fLog.callStatus == 'dialed';
          return CustomTile(
            leading: CachedImage(
              // hasDialled ? user.profilePhoto : user.profilePhoto,
              user.profilePhoto,
              isRound: true,
              radius: 45,
            ),
            mini: false,
            onLongPress: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Delete this Log?"),
                content: Text("Are you sure you wish to delete this log?"),
                actions: [
                  FlatButton(
                    child: Text("YES"),
                    onPressed: () async {
                      logMethods.deleteLogFromUser(
                          of: userProvider.getUser.uid, doc: widget.docId);
                      Navigator.maybePop(context);
                    },
                  ),
                  FlatButton(
                    child: Text("NO"),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                ],
              ),
            ),
            title: Text(
              hasDialled ? user.username : userProvider.getUser.username,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            icon: getIcon(widget.fLog.callStatus),
            subtitle: Text(
              widget.fLog.addedOn.toDate().toString(),
              style: TextStyle(
                fontSize: 13,
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

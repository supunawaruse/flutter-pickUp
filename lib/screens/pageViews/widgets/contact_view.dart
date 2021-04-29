import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/models/contact.dart';
import 'package:skype_clone/models/user.dart';
import 'package:skype_clone/provider/user_provider.dart';
import 'package:skype_clone/resources/firebaseMethods.dart';
import 'package:skype_clone/screens/cachedImage.dart';
import 'package:skype_clone/screens/chatScreen.dart';
import 'package:skype_clone/screens/pageViews/widgets/last_message_container.dart';
import 'package:skype_clone/screens/pageViews/widgets/online_dot_indicator.dart';
import 'package:skype_clone/utils/universal_variables.dart';
import 'package:skype_clone/widgets/customTile.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final FirebaseMethods firebaseMethods = FirebaseMethods();

  ContactView({this.contact});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebaseMethods.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          NormalUser user = snapshot.data;

          return ViewLayout(
            contact: user,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final NormalUser contact;
  final FirebaseMethods firebaseMethods = FirebaseMethods();

  ViewLayout({this.contact});

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return CustomTile(
      mini: false,
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              reciever: contact,
            ),
          )),
      title: Text(
        (contact != null ? contact.name : null) != null
            ? contact.name.substring(0, 10)
            : "..",
        style:
            TextStyle(color: Colors.white, fontFamily: "Arial", fontSize: 19),
      ),
      subtitle: LastMessageContainer(
        stream: firebaseMethods.fetchLastMessageBetween(
          senderId: userProvider.getUser.uid,
          receiverId: contact.uid,
        ),
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            CachedImage(
              contact.profilePhoto,
              radius: 80,
              isRound: true,
            ),
            OnlineDotIndicator(uid: contact.uid)
          ],
        ),
      ),
    );
  }
}

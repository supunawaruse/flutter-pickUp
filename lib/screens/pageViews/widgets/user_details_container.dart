import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/enum/user_state.dart';
import 'package:skype_clone/models/user.dart';
import 'package:skype_clone/provider/user_provider.dart';
import 'package:skype_clone/resources/firebaseMethods.dart';
import 'package:skype_clone/screens/cachedImage.dart';
import 'package:skype_clone/screens/loginScreen.dart';
import 'package:skype_clone/widgets/appbar.dart';

class UserDetailsContainer extends StatelessWidget {
  final FirebaseMethods firebaseMethods = FirebaseMethods();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: Color(0xff36454f),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: CustomAppBar(
              centerTitle: true,
              title: Text("User Details"),
            ),
          ),
          UserDetailsBody(),
        ],
      ),
    );
  }
}

class UserDetailsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final NormalUser user = userProvider.getUser;
    final FirebaseMethods firebaseMethods = FirebaseMethods();

    signOut() async {
      final bool isLoggedOut =
          await firebaseMethods.signOut(userProvider.getUser.uid);
      if (isLoggedOut) {
        // set userState to offline as the user logs out'
        firebaseMethods.setUserState(
          userId: userProvider.getUser.uid,
          userState: UserState.Offline,
        );

        // move the user to login screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
        );
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150.0,
                height: 150.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(user.profilePhoto)),
                  borderRadius: BorderRadius.all(Radius.circular(75.0)),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            user.name,
            style: TextStyle(fontSize: 22, color: Colors.black),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            user.email,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () => signOut(),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
              child: Text('Logout',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              decoration: BoxDecoration(
                  color: Color(0xff36454f),
                  borderRadius: BorderRadius.circular(20)),
            ),
          )
        ],
      ),
    );
  }
}

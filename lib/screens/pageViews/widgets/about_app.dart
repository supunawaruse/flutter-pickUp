import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/models/user.dart';
import 'package:skype_clone/provider/user_provider.dart';
import 'package:skype_clone/utils/universal_variables.dart';
import 'package:skype_clone/widgets/appbar.dart';

import '../../cachedImage.dart';

class AboutAppContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 25),
          child: CustomAppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.maybePop(context),
            ),
            centerTitle: true,
            title: Text("About App"),
          ),
        ),
        SizedBox(height: 30),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "About this app",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "This is an online application that users can login to the system and search for other users and then chat with them. As the extra features of this app, users can make voice and video calls as well",
            style: TextStyle(fontSize: 18, color: UniversalVariables.greyColor),
          ),
        ),
        SizedBox(height: 20),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Contact Owner",
            style: TextStyle(fontSize: 20),
          ),
        ),
        SizedBox(height: 20),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 10),
                  Text(
                    "Supuna Warusawithana",
                    style: TextStyle(
                        fontSize: 18, color: UniversalVariables.greyColor),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.email),
                  SizedBox(width: 10),
                  Text(
                    "supunawa@gmail.com",
                    style: TextStyle(
                        fontSize: 18, color: UniversalVariables.greyColor),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.phone),
                  SizedBox(width: 10),
                  Text(
                    "+94 76 324 1609",
                    style: TextStyle(
                        fontSize: 18, color: UniversalVariables.greyColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

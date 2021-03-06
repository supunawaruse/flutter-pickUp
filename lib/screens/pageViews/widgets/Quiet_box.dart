import 'package:flutter/material.dart';
import 'package:skype_clone/screens/searchScreen.dart';
import 'package:skype_clone/utils/universal_variables.dart';

class QuietBox extends StatelessWidget {
  final String heading;
  final String subtitle;
  final bool searchToggle;

  const QuietBox({this.heading, this.subtitle, this.searchToggle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xff36454f),
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15), bottom: Radius.circular(10))),
          padding: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                heading,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 25),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 25),
              searchToggle
                  ? (FlatButton(
                      color: UniversalVariables.darkPurple,
                      child: Text(
                        "START SEARCHING",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchScreen(),
                        ),
                      ),
                    ))
                  : (Container())
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:skype_clone/models/message.dart';
import 'package:skype_clone/widgets/appbar.dart';

class SinglePhoto extends StatelessWidget {
  final String photoUrl;
  final Message message;
  final String name;

  SinglePhoto(
      {@required this.photoUrl, @required this.message, @required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffedeeef),
      appBar: CustomAppBar(
        leading: GestureDetector(
            onTap: () => {Navigator.pop(context)},
            child: Icon(Icons.arrow_back)),
        title: Text('Image'),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 16, bottom: 16, right: 16, left: 16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: NetworkImage(photoUrl), fit: BoxFit.cover)),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  name != null
                      ? Text(
                          'sent by ' + name,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                      : Container(),
                  SizedBox(height: 5),
                  message != null
                      ? Text(
                          'at ' +
                              message.timestamp
                                  .toDate()
                                  .toString()
                                  .substring(11, 16),
                          style: TextStyle(color: Colors.white, fontSize: 18))
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

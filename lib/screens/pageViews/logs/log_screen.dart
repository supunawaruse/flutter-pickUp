import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/models/flog.dart';
import 'package:skype_clone/provider/user_provider.dart';
import 'package:skype_clone/resources/call_log_methods.dart';
import 'package:skype_clone/resources/local_db/repository/log_repository.dart';
import 'package:skype_clone/screens/callscreens/pickup/pickup_layout.dart';
import 'package:skype_clone/screens/pageViews/logs/widgets/floating_column.dart';
import 'package:skype_clone/screens/pageViews/logs/widgets/flog_list_container.dart';
import 'package:skype_clone/screens/pageViews/widgets/Quiet_box.dart';
import 'package:skype_clone/utils/universal_variables.dart';
import 'package:skype_clone/widgets/skype_appbar.dart';

import 'widgets/log_list_container.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: SkypeAppBar(
          title: "Calls",
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              // onPressed: () => Navigator.pushNamed(context, "/search_screen"),
              onPressed: () =>
                  LogMethods().deleteAllLogs(of: userProvider.getUser.uid),
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pushNamed(context, "/search_screen"),
            ),
          ],
        ),
        // floatingActionButton: FloatingColumn(),
        body: Padding(
          padding: EdgeInsets.only(left: 15),
          child: ChatListContainer(),
        ),
      ),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  final LogMethods logMethods = LogMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return StreamBuilder<QuerySnapshot>(
        stream: logMethods.fetchLog(userId: userProvider.getUser.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var docList = snapshot.data.docs;

            if (docList.isEmpty) {
              return QuietBox(
                searchToggle: false,
                heading: 'Your call log is empty',
                subtitle: 'Here you can see your all call logs',
              );
            }
            return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  FLog flog = FLog.fromMap(docList[index].data());
                  return FLogListContainer(
                      fLog: flog, docId: docList[index].id);
                });
          }

          return Container(child: Center(child: CircularProgressIndicator()));
        });
  }
}

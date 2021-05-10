import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/models/contact.dart';
import 'package:skype_clone/provider/user_provider.dart';
import 'package:skype_clone/resources/firebaseMethods.dart';
import 'package:skype_clone/screens/pageViews/widgets/Quiet_box.dart';
import 'package:skype_clone/screens/pageViews/widgets/about_app.dart';
import 'package:skype_clone/screens/pageViews/widgets/contact_view.dart';
import 'package:skype_clone/screens/pageViews/widgets/new_chat_button.dart';
import 'package:skype_clone/screens/pageViews/widgets/user_circle.dart';
import 'package:skype_clone/screens/pageViews/widgets/user_details_container.dart';
import 'package:skype_clone/utils/universal_variables.dart';
import 'package:skype_clone/widgets/skype_appbar.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SkypeAppBar(
        title: UserCircle(),
        actions: [
          IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, "/search_screen");
              }),
          PopupMenuButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) {
              return List.generate(1, (index) {
                return PopupMenuItem(
                  value: index,
                  child: Text('About App'),
                );
              });
            },
            onSelected: (value) => {
              showModalBottomSheet(
                  context: context,
                  backgroundColor: UniversalVariables.blackColor,
                  builder: (context) => AboutAppContainer(),
                  isScrollControlled: true)
            },
          ),
        ],
      ),
      // floatingActionButton: NewChatButton(),
      body: ChatListContainer(),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  final FirebaseMethods firebaseMethods = FirebaseMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return StreamBuilder<QuerySnapshot>(
        stream: firebaseMethods.fetchContacts(userId: userProvider.getUser.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var docList = snapshot.data.docs;

            if (docList.isEmpty) {
              return QuietBox(
                searchToggle: true,
                heading: 'This is where all the contacts are listed',
                subtitle:
                    'Search for your friends and family to start calling or chatting with them',
              );
            }
            return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  Contact contact = Contact.fromMap(docList[index].data());
                  return ContactView(contact: contact);
                });
          }

          return Container(child: Center(child: CircularProgressIndicator()));
        });
  }
}

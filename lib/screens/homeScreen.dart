import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/resources/firebaseRepository.dart';
import 'package:skype_clone/screens/pageViews/chatListScreen.dart';
import 'package:skype_clone/utils/universal_variables.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseRepository _repository = FirebaseRepository();

  PageController pageController;

  int _page = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Container(
            child: ChatListScreen(),
          ),
          Center(
              child:
                  Text('second page', style: TextStyle(color: Colors.white))),
          Center(
              child: Text('third page', style: TextStyle(color: Colors.white))),
        ],
        controller: pageController,
        onPageChanged: onPageChange,
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: CupertinoTabBar(
            backgroundColor: UniversalVariables.blackColor,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat,
                    color: (_page == 0)
                        ? UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor,
                  ),
                  title: Text("Chats",
                      style: TextStyle(
                          fontSize: 10,
                          color: (_page == 0
                              ? UniversalVariables.lightBlueColor
                              : UniversalVariables.greyColor)))),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.call,
                    color: (_page == 1)
                        ? UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor,
                  ),
                  title: Text("Calls",
                      style: TextStyle(
                          fontSize: 10,
                          color: (_page == 1
                              ? UniversalVariables.lightBlueColor
                              : UniversalVariables.greyColor)))),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.contact_phone,
                    color: (_page == 2)
                        ? UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor,
                  ),
                  title: Text("Contacts",
                      style: TextStyle(
                          fontSize: 10,
                          color: (_page == 2
                              ? UniversalVariables.lightBlueColor
                              : UniversalVariables.greyColor)))),
            ],
            onTap: navigateTapped,
            currentIndex: _page,
          ),
        ),
      ),
    );
  }

  void onPageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigateTapped(int page) {
    pageController.jumpToPage(page);
  }
}

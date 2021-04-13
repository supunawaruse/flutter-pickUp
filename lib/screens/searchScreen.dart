import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/models/user.dart';
import 'package:skype_clone/resources/firebaseRepository.dart';
import 'package:skype_clone/screens/chatScreen.dart';
import 'package:skype_clone/utils/universal_variables.dart';
import 'package:skype_clone/widgets/customTile.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  FirebaseRepository _repository = FirebaseRepository();

  List<NormalUser> userList;
  String query = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _repository.getCurrentUser().then((User user) {
      _repository.fetchAllUsers(user).then((List<NormalUser> list) {
        setState(() {
          userList = list;
        });
      });
    });
  }

  searchAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchController,
            onChanged: (val) {
              setState(() {
                query = val;
              });
            },
            cursorColor: UniversalVariables.blackColor,
            autofocus: true,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => searchController.clear());
                  },
                ),
                border: InputBorder.none,
                hintText: "Search",
                hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Color(0x88ffffff))),
          ),
        ),
      ),
    );
  }

  buildSuggestions(String query) {
    final List<NormalUser> suggestionList = query.isEmpty
        ? []
        : userList
            .where((NormalUser user) =>
                (user.username.toLowerCase().contains(query.toLowerCase())) ||
                (user.name.contains(query.toLowerCase())))
            .toList();

    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: ((context, index) {
          NormalUser searchUser = NormalUser(
              uid: suggestionList[index].uid,
              profilePhoto: suggestionList[index].profilePhoto,
              name: suggestionList[index].name,
              username: suggestionList[index].username);

          return CustomTile(
              mini: false,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChatScreen(reciever: searchUser)));
              },
              leading: CircleAvatar(
                backgroundImage: NetworkImage(searchUser.profilePhoto),
                backgroundColor: Colors.grey,
              ),
              title: Text(
                searchUser.username,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                searchUser.name,
                style: TextStyle(color: UniversalVariables.greyColor),
              ));
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: searchAppBar(context),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: buildSuggestions(query),
        ));
  }
}

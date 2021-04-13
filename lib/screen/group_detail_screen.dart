import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pine_apple/controller/group_detail_screen_controller.dart';
import 'package:pine_apple/import_firebase.dart';
import 'package:pine_apple/model/chat_message_model.dart';
import 'package:pine_apple/model/user_profile_model.dart';
import 'screen.dart';

class GroupDetailsScreen extends StatelessWidget {
  final GroupDetailsScreenController controller;
  final Random random = Random();
  GroupDetailsScreen(this.controller);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.white,
          leading: BackButton(
            onPressed: () => Navigator.pop(context),
            color: Colors.black,
          ),
          title: Text(
            "Group Details",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: FutureBuilder<GroupChatInfo>(
            future: controller.getGroupChatInfo(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Center(child: Text("Loading..."));

              GroupChatInfo groupChatInfo = snapshot.data;
              return Column(
                children: <Widget>[
                  _buildName(groupChatInfo.groupChatName),
                  _buildBio(groupChatInfo),
                  SizedBox(
                    height: 20.0,
                  ),
                  _buildMembersList(context,
                      controller.getUserProfileList(groupChatInfo.membersUid)),
                ],
              );
            },
          ),
        ));
  }

  Widget _buildName(String groupName) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.redAccent, Colors.pinkAccent])),
        child: Container(
          width: double.infinity,
          height: 200.0,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  groupName,
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                )
              ],
            ),
          ),
        ));
  }

  Widget _buildBio(GroupChatInfo groupChatInfo) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Group Description:",
              style: TextStyle(
                  color: Colors.redAccent,
                  fontStyle: FontStyle.normal,
                  fontSize: 28.0),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            "Just chatting!",
            style: TextStyle(
              fontSize: 22.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300,
              color: Colors.black,
              letterSpacing: 2.0,
            ),
          ),
          //_buildCategories();
        ],
      ),
    );
  }

  Widget _buildMembersList(
      BuildContext context, Future<List<UserProfile>> listFuture) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
      child: FutureBuilder(
        future: listFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          List<UserProfile> list = snapshot.data;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Members: ${list.length}",
                style: TextStyle(
                    color: Colors.redAccent,
                    fontStyle: FontStyle.normal,
                    fontSize: 28.0),
              ),
              for (UserProfile up in list)
                ListTile(
                  leading: CircleAvatar(
                      child: Icon(Icons.person),
                      backgroundColor: Color.fromARGB(random.nextInt(255),
                          random.nextInt(255), random.nextInt(255), 255)),
                  title: Text(up.username),
                  onTap: () => Navigator.pushNamed(
                      context, Routes.OTHER_PROFILE_SCREEN,
                      arguments: {Routes.ARG_USER_ID: up.uid}),
                )
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategories(List<String> categories) {

    String catString = '';
    categories.forEach((element) {
      catString = catString + ', '+element;
    });

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "\nCategory:",
            style: TextStyle(
                color: Colors.redAccent,
                fontStyle: FontStyle.normal,
                fontSize: 28.0),
          ),
        ),
        SizedBox(
          height: 6.0,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            catString,
            style: TextStyle(
              fontSize: 22.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300,
              color: Colors.black,
              letterSpacing: 2.0,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildButton() {
    return Container(
      width: 300.00,
      child: RaisedButton(
          onPressed: () {
            //Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
          elevation: 0.0,
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [Colors.redAccent, Colors.pinkAccent]),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Container(
              constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
              alignment: Alignment.center,
              child: Text(
                "Chat now",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26.0,
                    fontWeight: FontWeight.w300),
              ),
            ),
          )),
    );
  }
}



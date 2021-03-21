import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pine_apple/controller.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'model.dart';

class Profile extends StatefulWidget {

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  TextEditingController userNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  UserController _userController = Get.find(tag:"UserController");
  PineAppleUser userProfile;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text("Profile"),
        actions: [
          IconButton(icon:Icon(Icons.done,), onPressed: _confirmProfile)
        ],),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(

            children: [
              CircleAvatar(backgroundImage: NetworkImage("https://cdn.pixabay.com/photo/2015/02/14/18/10/pineapple-636562_1280.jpg"),radius: 50 ,),
              TextButton(onPressed: null, child: Text("Change Your Profile Photo")),
              Divider(color: context.theme.primaryColor),
              Text(_userController.currentUserProfile.username??"Null"),
              Text(_userController.currentUserProfile.description??"Null",maxLines: null,),
              TextFormField(
                maxLines: 1,
                controller: userNameController,
                decoration: InputDecoration(
                  labelText: "Username/Nickname",
                ),),
              TextFormField(
                keyboardType: TextInputType.multiline,
                controller: bioController,
                maxLines: null,
                decoration: InputDecoration(
                    labelText: "Bio"
                ),
              ),
              MaterialButton(onPressed: _confirmProfile, child: Text("Confirm changes"),)
            ]
      ),
        )

        ),
      );

  }

  void _confirmProfile()
  {
    _userController.currentUserProfile.username = userNameController.text;
    _userController.currentUserProfile.description = bioController.text;
    _userController.updateProfile();
  }
}

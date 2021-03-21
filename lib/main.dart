import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pine_apple/controller.dart';
import 'login.dart';
import 'chat.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/login_home_page.dart';
import 'model.dart';
void main()async
{
  WidgetsFlutterBinding.ensureInitialized();
  final _firebaseInit = await Firebase.initializeApp();
  runApp(PineApple());
}
class PineApple extends StatefulWidget {

  @override
  _PineAppleState createState() => _PineAppleState();
}

class _PineAppleState extends State<PineApple> {
  final _database = Get.put(DatabaseController(), tag: "Database");
  final _accountController = Get.put(AccountController(), tag: "AccountController");
  final _userController = Get.put(UserController(), tag: "UserController");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if(!currentFocus.hasPrimaryFocus && currentFocus.focusedChild!=null)currentFocus.focusedChild.unfocus();
      },
      onVerticalDragStart: (_){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if(!currentFocus.hasPrimaryFocus && currentFocus.focusedChild!=null)currentFocus.focusedChild.unfocus();
      },
      child: MaterialApp(
          navigatorKey: Get.key,
          title: "PineApple",
          home:  SafeArea(
                    child: Scaffold(
                      body: LoginPage(),
                    ),
                  )
      ),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pine_apple/StreamChatMessageList.dart';
import 'package:pine_apple/controller/login_page_controller.dart';
import 'package:pine_apple/controller/pineapple_context.dart';
import 'package:pine_apple/controller/register_page_controller.dart';
import 'package:pine_apple/model/ChatMessage.dart';
import 'package:pine_apple/model/UserProfile.dart';
import 'package:pine_apple/model/profiles_repository.dart';
import 'package:pine_apple/model/auth_service.dart';
import 'package:pine_apple/screen/group_detail_screen.dart';
import 'model/event_model.dart';
import 'model/events_repository.dart';
import 'screen/screen.dart' as Screens;
import 'package:get/get.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  final _firebaseInit = await Firebase.initializeApp();
  await PineAppleContext.initialize();


  runApp(GetMaterialApp(
    onGenerateRoute: Screens.Routes.generateRoutes,
    home:  StreamBuilder(
      stream: PineAppleContext.auth.userAuthState,
      builder: (context, snapshot){

        return SafeArea(
          child: Scaffold(
            body: snapshot.hasData ? Screens.MainScreen(Screens.Pages):Screens.LoginScreen(),
        ),
        );
      }
    )));
}

Widget checkIfLoggedIn(AuthService auth)
{
  return auth.currentUser!=null ? Scaffold(body: Screens.MainScreen(Screens.Pages)): Screens.LoginScreen();
}

//GroupDetailsScreen(GroupDetailsScreenController('-MXXo0sxTZ65rkWGXtkW')
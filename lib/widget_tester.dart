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
import 'model/events_repository.dart';
import 'screen/screen.dart' as Screens;
import 'package:get/get.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  final _firebaseInit = await Firebase.initializeApp();
  await PineAppleContext.initialize();

  AuthService auth = PineAppleContext.auth;
  print(auth.currentUser.toString());

  EventsRepository evp = EventsRepository();
  List<EventModel> list = await evp.searchEventsByCategory('concert');
  EventModel event = list[0];

  runApp(GetMaterialApp(
    onGenerateRoute: Screens.Routes.generateRoutes,
    home:  SafeArea(
        child:checkIfLoggedIn(auth),
  )));
}

Widget checkIfLoggedIn(AuthService auth)
{
  return auth.currentUser!=null ? Scaffold(body: Screens.MainScreen()): Screens.LoginScreen();
}

//GroupDetailsScreen(GroupDetailsScreenController('-MXXo0sxTZ65rkWGXtkW')
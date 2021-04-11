import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pine_apple/controller/pineapple_context.dart';
import 'package:pine_apple/model/ChatMessage.dart';
import 'package:pine_apple/model/UserProfile.dart';
import 'package:pine_apple/model/profiles_repository.dart';
import 'package:pine_apple/model/auth_service.dart';
import 'model/chat_repository.dart';
import 'screen/screen.dart' as Screens;
import 'package:get/get.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  final _firebaseInit = await Firebase.initializeApp();
  await PineAppleContext.initialize();

  AuthService auth = PineAppleContext.auth;
  ProfilesRepository profilesRepo = PineAppleContext.profilesRepository;

  UserProfile userProfile = await profilesRepo.getUserProfile("Jack");
  Get.put(userProfile, tag: "UserProfile");
  UserProfileReference upf = Get.put(UserProfileReference("Jack"), tag: "UserProfileReference");

  ChatRepository chatRepository = Get.put(ChatRepository());
  ChatMessagesReference cmr = ChatMessagesReference("basketball");
  ChatGroupReference chatGroupReference = ChatGroupReference("-MXXo0sxTZ65rkWGXtkW");

  GroupChatInfo groupChatInfo = await chatGroupReference.getGroupInfo();
  Screens.ConversationListController clc = Get.put(Screens.ConversationListController(upf));


  Screens.EditCategorySelectionController editCategorySelectionController =
  Screens.EditCategorySelectionController(upf);

  print(auth.currentUser.toString());

  runApp(GetMaterialApp(
    onGenerateRoute: Screens.Routes.generateRoutes,
    home:  SafeArea(
      child: auth.currentUser!=null ? Scaffold(body: Screens.MainScreen()): Screens.LoginScreen(),
    ),
  ));
}


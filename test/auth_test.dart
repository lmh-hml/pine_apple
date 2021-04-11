import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'dart:developer';
import 'package:pine_apple/model/backend.dart';
import 'package:pine_apple/model/UserProfile.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  final _firebaseInit = await Firebase.initializeApp();

  AuthService auth = AuthService();
  log(auth.currentUser.email);
  UserProfileReference profileController = await UserProfileReference(auth.currentUserUid);
  UserProfile profile = await profileController.getUserProfile();
  log(profile.map.toString());

  await auth.signOut();
  log(profile.map.toString());


}
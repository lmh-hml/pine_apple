import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:pine_apple/model.dart';
import 'package:pine_apple/controller.dart';
import 'dart:developer';
import 'package:flutter_test/flutter_test.dart' as Test;

void main()
{
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  UserController controller = UserController();
  UserProfile profile = controller.getUserProfile("vTyqV54S21Uv5HeQgGGTLKXqnaY2");
  log("Waiting for data...");
  //Test.
}


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pine_apple/controller/pineapple_context.dart';
import 'package:pine_apple/import_firebase.dart';
import 'screen/screen.dart' as Screens;
import 'package:get/get.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  final _firebaseInit = await Firebase.initializeApp();
  await PineAppleContext.initialize();


  runApp(GetMaterialApp(
    onGenerateRoute: Screens.Routes.generateRoutes,
    home:  StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot){
        print(snapshot.data);
        return SafeArea(
          child: Scaffold(
            body: snapshot.hasData ? Screens.MainScreen():Screens.LoginScreen(),
        ),
        );
      }
    )));
}



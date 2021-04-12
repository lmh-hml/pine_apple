import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screen.dart'as Screens;

class StartUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          print(snapshot.data);
          return SafeArea(
            child: Scaffold(
              body: snapshot.hasData ? Screens.MainScreen():Screens.LoginScreen(),
            ),
          );
        }
    );
  }
}

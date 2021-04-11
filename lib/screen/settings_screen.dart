import 'package:flutter/material.dart';
import 'package:pine_apple/model/auth_service.dart';
import 'screen.dart';

class SettingsScreen extends StatelessWidget {

  final SettingsController controller;
  SettingsScreen(this.controller);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget> [
          InkWell(
            onTap: () async {
              controller.logout();
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(30, 20, 0, 20),
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey[100],
                ),
              ),
              child: Text(
                'Text Size',
                style: TextStyle(
                  fontFamily: 'one',
                  fontSize: 25.0,
                  color: Colors.black,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),

          InkWell(
            onTap: () => {},
            child: Container(
              padding: EdgeInsets.fromLTRB(30, 20, 0, 20),
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey[100],
                ),
              ),
              child: Text(
                'Language',
                style: TextStyle(
                  fontFamily: 'one',
                  fontSize: 25.0,
                  color: Colors.black,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),

          InkWell(
            onTap: () => {},
            child: Container(
              padding: EdgeInsets.fromLTRB(30, 20, 0, 20),
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey[100],
                ),
              ),
              child: Text(
                'Change Password',
                style: TextStyle(
                  fontFamily: 'one',
                  fontSize: 25.0,
                  color: Colors.black,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),

          InkWell(
          onTap: () async{
            await controller.logout();
            Navigator.pushNamed(context, Routes.LOGIN);
          },
            child: Container(
              padding: EdgeInsets.fromLTRB(30, 20, 0, 20),
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey[100],
                ),
              ),
              child: Text(
                'LOGOUT',
                style: TextStyle(
                  fontFamily: 'one',
                  fontSize: 25.0,
                  color: Colors.red[600],
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsController
{
  AuthService authService;
  SettingsController(this.authService);

  Future<void> logout() async
  {
    return authService.signOut();
  }
}
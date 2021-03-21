
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pine_apple/model.dart';
import 'package:pine_apple/profile.dart';
import 'chat.dart';
import 'controller.dart';
import 'package:get/get.dart';

class PineAppleLogIn extends StatefulWidget {

  @override
  _PineAppleLogInState createState() => _PineAppleLogInState();
}

class _PineAppleLogInState extends State<PineAppleLogIn> {


  AccountController _account = Get.put(AccountController());
  TextEditingController emailTextController = TextEditingController();
  TextEditingController pwdTextController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.network("https://cdn.pixabay.com/photo/2015/02/14/18/10/pineapple-636562_1280.jpg"),
          Column(
            children: [
              logInEntry("Email",isObscure: false, controller: emailTextController),
              logInEntry("Password",isObscure: true, controller: pwdTextController),
              logInButton("Log In", _logInCallback),
              logInButton("Sign Up", _signUpCallback),
              TextButton(onPressed: _forgotPasswordCallback, child: Text("Forgot password?"))

            ],
          ),
        ],
      ),


    );
  }

  Widget logInEntry(String hint, {bool isObscure=true, @required TextEditingController controller})
  {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: hint,
        ),
        obscureText: isObscure,
      ),
    );

  }

  Widget logInButton(String text, Function onPressed)
  {
    return Container(
      margin: new EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(text, style: new TextStyle(fontSize: 18),),
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30))
          ),
        ),
      ),
    );
  }

  void _signUpCallback() async
  {
    log("Register with ${emailTextController.text}, pwd: ${pwdTextController.text}");

    User user = await _account.register(email: emailTextController.text , password: pwdTextController.text);
    if(user!=null) _enterApp(user);
    else
    {
      log("Register failed!");
    }

  }

  void _logInCallback() async
  {
    log("Sign up with ${emailTextController.text}, pwd: ${pwdTextController.text}");

    User user = await _account.signIn(email: emailTextController.text , password: pwdTextController.text);
    if(user!=null) {
      _enterApp(user);
    }
    else
      {
        log("Log in failed!");
      }
  }
  
  void _enterApp(User user) async
  {
    User u = Get.put(user,tag: "CurrentUser");
    UserProfile profile = await Get.find<UserController>(tag:"UserController").getUserProfile(u.uid);
    log("Current user is ${u.email}, ${u.uid}");
    Get.to( () => PineAppleChat() );
  }

  void _forgotPasswordCallback()
  {
  }
}

import 'dart:developer';

import 'package:pine_apple/import_firebase.dart';
import 'package:pine_apple/model/auth_service.dart';
import 'package:get/get.dart';
import 'package:pine_apple/screen/screen.dart';
import 'package:rxdart/rxdart.dart';

class LoginPageController
{
  LoginPageController(AuthService this._auth);
  AuthService _auth;
  final StreamController<String> _errorStream = BehaviorSubject();

  ///Called when login screen's login button is pressed.
  Future<void> onLogIn(String email, String password) async {
    log("Sign up with $email, pwd: $password");
    try {
      User user = await _auth.signIn(email: email,
          password: password);

      if(user!=null)Get.offNamed(Routes.MAIN_SCREEN);
      print(user.uid);

    }on FirebaseAuthException catch(e)
    {
      print(e.code);
      if(email == '' || password == '')_errorStream.add('Please enter a username and password.');
      switch(e.code)
      {
        case 'invalid-email':_errorStream.add('Entered email is invalid or misspelled.');break;
        case 'wrong-password':_errorStream.add('Wrong Password entered.');break;
        case 'user-not-found':_errorStream.add('No account registered with the email');break;
      }
    }
  }

  ///Called when login screen's register button is pressed.
  void onRegister()
  {
    Get.toNamed(Routes.REGISTER);
  }

  Stream<String> get errorStream => _errorStream.stream;
}

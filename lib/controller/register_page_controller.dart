import 'dart:developer';

import 'package:pine_apple/model/backend.dart';
import 'package:pine_apple/import_firebase.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

///Class that handles the business logic for the Register screen,
///TODO(COnvert this to a controller for registration page)
class RegisterController {
  static const String NONE = "";
  final String pwdInvalidText = "Password must be 8 chars with alphanumerics and special characters.";
  final String userNameInvalidText = "Username should be more than 5 chars with at least one alphabet";
  final String emailUsedText = "Email is already in use";
  final String emailInvalidText = "Email is not valid";
  String lastErrorCode = "";

  AuthService _auth;
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  final GlobalKey<FormFieldState> _emailFieldKey = GlobalKey<FormFieldState>();
  final StreamController<String> _errorStream = BehaviorSubject();


  RegisterController(AuthService authService) {
    _auth = authService;
  }

  ///Tries to create a user using the email, username and password given
  ///If successful, returns a future with a non-null user
  ///If unsuccessful, returns null.
  Future<User> _register(String email, String username, String password) async {

      User user = await _auth.register(email,
                                      password,
                                      username);
      return user;
  }

  ///A strong password must at least 8 characters with
  ///a lower case alphabet, upper case alphabet, digit and special character.
  bool isPasswordStrong(String input) {
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]){8,}')
        .hasMatch(input);
  }

  ///Validator to be used by a password textfield.
  String validatePassword(value) {
    if(_pwdController.text.isBlank)
    {
      return 'Password is Blank';
    }
    else return !isPasswordStrong(value)
        ? pwdInvalidText
        : null;
  }

  ///A Username must be more than 5 characters and have at least one alphabet.
  bool isUsernameValid(String input) {
    return RegExp(r'^(?!\s)(?!.*\s)(?=.*[a-zA-Z]).{5,}(?!\s)$').hasMatch(input);
  }

  ///Validator to be be used by a username textfield .
  String validateUsername(String value) {
    if(value.isBlank){
      return 'Username is blank';
    }
    else return !isUsernameValid(value)
        ? userNameInvalidText
        : null;
  }

  String getEmailErrorText(String errorCode)
  {
    if(_emailController.text.isBlank)return 'Email is blank.';
    String errorText;
    switch(errorCode)
    {
      case 'email-already-in-use':
        errorText = "Email is already in use";
        break;
      case 'invalid-email':
        _emailFieldKey.currentState.validate();
        errorText = "Email is not valid";
        break;
    }
    return errorText;
  }

  Future<User> onSignUpPressed() async {

    _errorStream.add('');
    try{
      User user = await _register(
        _emailController.text,
        _userNameController.text,
        _pwdController.text,
      );

      return user;
    }on FirebaseAuthException catch (e) {
      lastErrorCode = e.code;
      log(lastErrorCode);
      _errorStream.add(_processErrors());

      return null;
    }


  }


  ///Checks the textcontrollers if they are filled and returns error text describing the first controller to be empty.
  ///The username is checked first, followed by email, then password.
  ///If all fields are filled, returns null.
  String _processErrors()
  {
    String usernameError = validateUsername(_userNameController.text);
    String pwdError = validatePassword(_pwdController.text);
    String emailError = getEmailErrorText(lastErrorCode);
    if(usernameError!=null)return usernameError;
    else if(emailError!=null)return emailError;
    else if(pwdError!=null)return pwdError;

    else return '';
  }

  TextEditingController get userNameController => _userNameController;
  GlobalKey<FormFieldState> get emailFieldKey => _emailFieldKey;
  TextEditingController get pwdController => _pwdController;
  TextEditingController get emailController => _emailController;
  Stream<String> get errorStream => _errorStream.stream;
}
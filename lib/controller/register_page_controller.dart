import 'package:pine_apple/model/backend.dart';
import 'package:pine_apple/import_firebase.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

///Class that handles the business logic for the Register screen,
class RegisterController {
  static const String NONE = "";
  static final String pwdInvalidText = "Password must be 8 chars with alphanumerics and special characters.";
  static final String userNameInvalidText = "Username should be more than 5 chars with at least one alphabet";
  static final String emailUsedText = "Email is already in use";
  static final String emailInvalidText = "Email is not valid";
  static final String emailBlankText = 'Email is blank.';
  static final String usernameBlankText = 'Username is blank';
  static final String pwdBlankText = 'Password is blank';
  String lastErrorString = "";

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
  bool _isPasswordStrong(String input) {
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]){8,}')
        .hasMatch(input);
  }

  ///Validator to be used by a password textfield.
  String validatePassword(String value) {
    if(value.isBlank)
    {
      return pwdBlankText;
    }
    else return !_isPasswordStrong(value)
        ? pwdInvalidText
        : null;
  }

  ///A Username must be more than 5 characters and have at least one alphabet.
  bool _isUsernameValid(String input) {
    return RegExp(r'^(?!\s)(?!.*\s)(?=.*[a-zA-Z]).{5,}(?!\s)$').hasMatch(input);
  }

  ///Validator to be be used by a username textfield .
  String validateUsername(String value) {
    if(value.isBlank){
      return usernameBlankText;
    }
    else return !_isUsernameValid(value)
        ? userNameInvalidText
        : null;
  }

  ///Gets the error string related to the error code from FirebaseAuthException
  ///This method should be used when catching that exception.
  String _getFirebaseEmailErrorText(String errorCode)
  {
    if(_emailController.text.isBlank)return emailBlankText;
    String errorText;
    switch(errorCode)
    {
      case 'email-already-in-use':
        errorText = emailUsedText;
        break;
      case 'invalid-email':
        _emailFieldKey.currentState.validate();
        errorText =emailInvalidText;
        break;
    }
    return errorText;
  }

  ///Internal string to update this controller's error stream and string
  void _setErrorString(String s)
  {
    _errorStream.add(s);
    lastErrorString = s;
  }

  ///Method called by register screen when the sign up button is pressed.
  Future<User> onSignUpPressed({String username, String email, String password}) async {
    _errorStream.add('');

    String userNameInput = username??_userNameController.text;
    String emailInput = email??_emailController.text;
    String passwordInput =  password??_pwdController.text;


    String usernameError = validateUsername(userNameInput);
    if(usernameError!=null)
      {
        _setErrorString(usernameError);
        return null;
      }

    if(emailInput==null || emailInput.isBlank)
    {
      _setErrorString(emailBlankText);
      return null;
    }

    String passwordError = validatePassword(passwordInput);
    if(passwordError!=null)
      {
        _setErrorString(passwordError);
        return null;
      }


    try{
      User user = await _register(
        emailInput,
        userNameInput,
        passwordInput,
      );
      _errorStream.add('');
      return user;
    }on FirebaseAuthException catch (e) {
      String emailError = _getFirebaseEmailErrorText(e.code);
      if(emailError!=null)_setErrorString(emailError);
      return null;
    }
  }


  TextEditingController get userNameController => _userNameController;
  GlobalKey<FormFieldState> get emailFieldKey => _emailFieldKey;
  TextEditingController get pwdController => _pwdController;
  TextEditingController get emailController => _emailController;
  Stream<String> get errorStream => _errorStream.stream;
}
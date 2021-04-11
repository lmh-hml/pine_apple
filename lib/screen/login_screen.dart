import 'package:flutter/material.dart';
import 'package:pine_apple/controller/login_page_controller.dart';
import 'package:pine_apple/controller/pineapple_context.dart';
import 'package:pine_apple/import_firebase.dart';
import 'package:rxdart/rxdart.dart';



class LoginScreen extends StatefulWidget {

  final LoginPageController controller = LoginPageController(PineAppleContext.auth);

  LoginScreen();
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:
//Background
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/login_background.png'),
              fit: BoxFit.cover
            ),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [

//Input Email function
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 50.0, top: 150.0, right: 50.0, bottom: 0.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: "Email"
                  ),
                ),
              ),

// Input Password function
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 50.0, top: 0.0, right: 50.0,bottom: 0.0),
                child: TextField(
                  controller: _pwdController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                ),
              ),

// NAVIGATOR TO REGISTER PAGE
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                child: GestureDetector(
                  onTap: registerButtonCallback,
                  child: Text(
                    "Don't Have an Account? Sign up",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),

          StreamBuilder(
              stream: widget.controller.errorStream,
              builder: (context, snapshot){
                if(snapshot.hasData)
                  {
                    return Text(snapshot.data, style: TextStyle(
                      color: Colors.red,
                    ),);
                  }
                else{
                  return Text("");
                }
              }),
//Login button
              Container(
                margin: EdgeInsets.only(left: 150.0, top: 140.0, right: 50.0, bottom: 0.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 200, height: 50),
                  child: ElevatedButton(
                    onPressed: logInButtonCallback,
                    child: Text(
                      "LOGIN",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontFamily: 'One',
                        letterSpacing: 2.0,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255,192,80,70),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(80.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }

  //UI FUNCTIONS
  void logInButtonCallback()
  {
    //Navigator.push(context, MaterialPageRoute(builder: (context) => Root() ));
    widget.controller.onLogIn(_emailController.text, _pwdController.text);
  }

  void registerButtonCallback()
  {
    //Navigator.push(context, MaterialPageRoute(builder: (context) => Register() ));
    widget.controller.onRegister();
  }

}



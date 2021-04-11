import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_apple/controller/pineapple_context.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pine_apple/controller/register_page_controller.dart';
import 'package:pine_apple/screen/screen.dart';


class RegisterScreen extends StatefulWidget {

  final RegisterController controller = RegisterController(PineAppleContext.auth);
  RegisterScreen();

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isObscure = true;
  RegisterController _registerController;
  final GlobalKey<FormFieldState> _emailFieldKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    _registerController = widget.controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;

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
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Container(
                margin: EdgeInsets.fromLTRB(30.0, 240.0, 30.0, 0),
                child:Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "REGISTER",
                    style: TextStyle(
                      fontFamily: 'One',
                      color: Colors.green,
                      fontSize: 30.0,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ),

//Input Username function
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 50),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _registerController.userNameController,
                  decoration: InputDecoration(labelText: "Username"),
              )
              ),

//Input Email function
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 50),
                child: TextFormField(
                  key: _registerController.emailFieldKey,
                  controller: _registerController.emailController,
                  decoration: InputDecoration(labelText: "Email"),
                ),
              ),

//Input password function
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 50),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _registerController.pwdController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                ),
              ),

              Container(
                alignment: Alignment.center,
                width: 300,
                child: StreamBuilder(
                    stream: _registerController.errorStream,
                    builder: (context, snapshot){
                      if(snapshot.hasData)
                      {
                        return Text(
                          snapshot.data,
                          style: TextStyle(
                          color: Colors.red,
                        ),
                        );
                      }
                      else{
                        return Text("");
                      }
                    }),
              ),

//Signup Button
              Container(
                margin: EdgeInsets.only(left: 150.0, top: 120.0, right: 50.0, bottom: 50.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 200, height: 50),
                  child: ElevatedButton(
                  onPressed: ()async{
                    User user = await _registerController.onSignUpPressed();
                    if(user!=null)
                      Get.offNamed(Routes.NEW_USER_EDIT_PROFILE);
                  },
                    child: Text(
                      "SIGN UP",
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
              )
            ],
          ),
        ),
    );
  }
}
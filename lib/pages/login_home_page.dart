import 'package:flutter/material.dart';
import 'register_page.dart';
import 'root.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [

//Input Email function
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 50.0, top: 150.0, right: 50.0, bottom: 0.0),
                child: TextField(
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
                  onTap: () => {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage() ))
                  },
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

//Login button
              Container(
                margin: EdgeInsets.only(left: 150.0, top: 140.0, right: 50.0, bottom: 0.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 200, height: 50),
                  child: ElevatedButton(
                  onPressed: () => {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Root() ))
                  },
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
}



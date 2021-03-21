import 'package:flutter/material.dart';
import 'select_interests.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Username"
                  ),
                ),
              ),

//Input Email function
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  decoration: InputDecoration(
                      labelText: "Email"
                  ),
                ),
              ),

//Input password function
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 50),
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

//Signup Button
              Container(
                margin: EdgeInsets.only(left: 150.0, top: 120.0, right: 50.0, bottom: 50.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 200, height: 50),
                  child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SelectInterests() ));
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
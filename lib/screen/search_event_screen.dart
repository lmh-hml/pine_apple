import 'package:flutter/material.dart';

class SearchEvent extends StatefulWidget {
  @override
  _SearchEventState createState() => _SearchEventState();
}

class _SearchEventState extends State<SearchEvent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }
  Widget getBody(){
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget> [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Container(
                width: size.width - 30,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Color.fromARGB(150,211,211,211),
                ),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      hintText: 'Search for Event (Name, Keyword ,etc..)',
                  ),
                  style: TextStyle(
                      color: Colors.black,
                  ),
                  cursorColor: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

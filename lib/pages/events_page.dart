import 'package:flutter/material.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  Widget getBody(){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            alignment: Alignment(-0.8, 1.0),
            height: 40.0,
            child: Text(
              'Selected Events',
              style: TextStyle(
                fontSize: 25.0,
                color: Colors.deepPurple,
                fontFamily: 'One',
              ),
            ),
          ),

//List of Selected Events
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  height: 80.0,
                  color: Color.fromARGB(255,192,80,70),
                  child: Text(
                    'Event 1',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.black,
                      fontFamily: 'One',
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 80.0,
                  color: Color.fromARGB(255,255,192,0),
                  child: Text(
                    'Event 2',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.black,
                      fontFamily: 'One',
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            alignment: Alignment(-0.8, 1.0),
            height: 40.0,
            //color: Colors.blue,
            child: Text(
              'Recommended Events',
              style: TextStyle(
                fontSize: 25.0,
                color: Colors.deepPurple,
                fontFamily: 'One',
              ),
            ),
          ),

// List of Recommended Events
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  height: 80.0,
                  color: Color.fromARGB(255,192,80,70),
                  child: Text(
                    'Event 1',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.black,
                      fontFamily: 'One',
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 80.0,
                  color: Color.fromARGB(255,255,192,0),
                  child: Text(
                    'Event 2',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.black,
                      fontFamily: 'One',
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 80.0,
                  color: Color.fromARGB(255,192,80,70),
                  child: Text(
                    'Event 3',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.black,
                      fontFamily: 'One',
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 80.0,
                  color: Color.fromARGB(255,255,192,0),
                  child: Text(
                    'Event 4',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.black,
                      fontFamily: 'One',
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 80.0,
                  color: Color.fromARGB(255,192,80,70),
                  child: Text(
                    'Event 5',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.black,
                      fontFamily: 'One',
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 80.0,
                  color: Color.fromARGB(255,255,192,0),
                  child: Text(
                    'Event 6',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.black,
                      fontFamily: 'One',
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 80.0,
                  color: Color.fromARGB(255,192,80,70),
                  child: Text(
                    'Event 7',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.black,
                      fontFamily: 'One',
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 80.0,
                  color: Color.fromARGB(255,255,192,0),
                  child: Text(
                    'Event 8',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.black,
                      fontFamily: 'One',
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 80.0,
                  color: Color.fromARGB(255,192,80,70),
                  child: Text(
                    'Event 9',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.black,
                      fontFamily: 'One',
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 80.0,
                  color: Color.fromARGB(255,255,192,0),
                  child: Text(
                    'Event 10',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.black,
                      fontFamily: 'One',
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 80.0,
                  color: Color.fromARGB(255,192,80,70),
                  child: Text(
                    'Event 11',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.black,
                      fontFamily: 'One',
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 80.0,
                  color: Color.fromARGB(255,255,192,0),
                  child: Text(
                    'Event 12',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.black,
                      fontFamily: 'One',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

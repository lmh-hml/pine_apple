import 'package:flutter/material.dart';
import 'package:pine_apple/model/events_repository.dart';

class EventDetailsScreen extends StatelessWidget {

  final EventModel event;
  EventDetailsScreen(this.event);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[

                    Container(
                      child: Image.network(event.imageURL+'?',fit: BoxFit.fill,),
                    ),

                    Container(
                      padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          event.title,
                          style: TextStyle(
                            fontSize: 30.0,
                            fontFamily: 'One',
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          event.description,
                          style: TextStyle(
                            fontSize: 15.0,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "Venue Name:  ",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontFamily: 'One',
                                  letterSpacing: 1.0,
                                ),
                              ),
                              TextSpan(
                                text: event.venue,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "Date:  ",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontFamily: 'One',
                                  letterSpacing: 1.0,
                                ),
                              ),
                              TextSpan(
                                text: '${event.startDate} to ${event.endDate}',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "Time:  ",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontFamily: 'One',
                                  letterSpacing: 1.0,
                                ),
                              ),
                              TextSpan(
                                text: "9.00am - 9.00pm",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                      width: 150.0,
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: () => {
                          // Navigate.push to group chat
                        },
                        child: Text(
                          "JOIN",
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

                  ],
                ),
              ),
            ),
          ),
    );
  }
}

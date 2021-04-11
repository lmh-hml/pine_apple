import 'package:flutter/material.dart';
import 'event_detail_screen.dart';
import 'screen.dart';
import 'package:pine_apple/data/events_json.dart';

class ViewAllEvents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: getBody(),
    );
  }

  Widget getAppBar(){
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      leading: BackButton(
        color: Colors.black,
      ),
      title: Padding(
        padding: EdgeInsets.only(left: 70.0),
        child: Text(
          'ALL EVENTS',
          style: TextStyle(
            color: Color.fromARGB(255,192,80,70),
            fontFamily: 'One',
            fontSize: 30.0,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  Widget getBody(){
    return SingleChildScrollView(
      child: Column(
        children: List.generate(events.length, (index){
          return AllEvents(
            image: events[index]['image'],
            title: events[index]['title'],
            description: events[index]['description'],
            startDate: events[index]['startDate'],
            endDate: events[index]['endDate'],
          );
        }),
      ),
    );
  }
}

class AllEvents extends StatelessWidget {
  final String title;
  final String image;
  final String description;
  final String startDate;
  final String endDate;

  const AllEvents({
    Key key, this.title, this.image, this.description, this.startDate, this.endDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget> [
        InkWell(
          onTap: () => {
            //Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailsScreen() ))
          }, // Handle your callback
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                ),
              ),
            ),
            child: Column(
              children: <Widget> [
                Container(
                  height: 250.0,
                  child: Image(
                    image: NetworkImage(image),
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
                            text: "Name:  ",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              fontFamily: 'One',
                            ),
                          ),
                          TextSpan(
                            text: title,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
                            text: "Description:  ",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              fontFamily: 'One',
                            ),
                          ),
                          TextSpan(
                            text: description,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Date:  ",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              fontFamily: 'One',
                            ),
                          ),
                          TextSpan(
                            text: startDate,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: " - ",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: endDate,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

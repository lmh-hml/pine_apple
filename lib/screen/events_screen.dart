import 'package:flutter/material.dart';
import 'screen.dart';
import 'package:pine_apple/data/events_json.dart';

///Screen showing the list of new events and events joined, and a search bar that users can use to search
///for specific events.
class Events extends StatefulWidget {
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  Widget getBody(){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 0, 10.0),
            child: InkWell(
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SearchEvent() ))
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/search_bar.png',),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),

          Container(
            alignment: Alignment(-0.8, 1.0),
            height: 40.0,
            child: Text(
              'Selected Events',
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.deepPurple,
                fontFamily: 'One',
              ),
            ),
          ),

//List of Selected Events
          Column(
            children: List.generate(events.length, (index){
              return SelectedEvents(
                title: events[index]['title'],
                startDate: events[index]['startDate'],
                endDate: events[index]['endDate'],
              );
            }),
          ),

          Divider(
            height: 30,
            thickness: 5,
            indent: 15,
            endIndent: 15,
          ),

          Container(
            alignment: Alignment(-0.8, 1.0),
            height: 30.0,
            child: Text(
              'Recommended Events',
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.deepPurple,
                fontFamily: 'One',
              ),
            ),
          ),

// List of Recommended Events
          Column(
            children: List.generate(events.length, (index){
              return RecommendedEvents(
                image: events[index]['image'],
                title: events[index]['title'],
                description: events[index]['description'],
                startDate: events[index]['startDate'],
                endDate: events[index]['endDate'],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class SelectedEvents extends StatelessWidget {
  final String title;
  final String startDate;
  final String endDate;

  const SelectedEvents({
    Key key, this.title, this.startDate, this.endDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget> [
        InkWell(
          onTap: () {
            //Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailsScreen() ));
          }, // Handle your callback
          child: Container(
            height: 70.0,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                ),
                bottom: BorderSide(
                  color: Colors.grey,
                ),
              ),
            ),
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget> [
                      Container(
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
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

class RecommendedEvents extends StatelessWidget {
  final String title;
  final String image;
  final String description;
  final String startDate;
  final String endDate;

  const RecommendedEvents({
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
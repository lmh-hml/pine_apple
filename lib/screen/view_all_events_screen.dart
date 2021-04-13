import 'package:flutter/material.dart';
import 'package:pine_apple/model/event_model.dart';
import 'package:pine_apple/model/events_repository.dart';
import 'event_detail_screen.dart';
import 'widgets/event_list_widget.dart';
import 'screen.dart';

class ViewAllEvents extends StatelessWidget {

  final EventsRepository eventsRepository = EventsRepository();


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
      child: FutureBuilder(
        future: eventsRepository.getAllRecentEvents() ,
        builder:(context, snapshot){
          List<EventModel> events;
          if(!snapshot.hasData) events = [];
          else events = snapshot.data;
          return Column(
            children: [
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
              EventListWidget(events, onItemTap: (event){
                Navigator.pushNamed(context, Routes.EVENT_DETAIL_SCREEN_WITH_JOIN, arguments: {Routes.ARG_EVENT_MODEL:event});
              },),
            ],
          );
        }
        ,
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

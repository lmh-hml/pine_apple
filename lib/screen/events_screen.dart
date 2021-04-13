import 'package:flutter/material.dart';
import 'package:pine_apple/controller/events_screen_controller.dart';
import 'package:pine_apple/import_firebase.dart';
import 'package:pine_apple/model/backend.dart';
import 'package:pine_apple/model/event_model.dart';
import 'file:///D:/AndroidProjects/pine_apple/lib/screen/widgets/event_list_widget.dart';
import 'file:///D:/AndroidProjects/pine_apple/lib/screen/widgets/event_selected_widget.dart';
import 'screen.dart';

///Screen showing the list of new events and events joined, and a search bar that users can use to search
///for specific events.
class EventsScreen extends StatefulWidget {
  final EventsScreenController controller = EventsScreenController();

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final EventsRepository eventsRepository = EventsRepository();

  @override
  void initState() {
    widget.controller.refreshRecommendations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  Widget getBody() {
    return SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 0, 10.0),
            child: InkWell(
              onTap: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchEvent()))
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/search_bar.png',
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),

          StreamBuilder(
              stream: widget.controller.joinedEventStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return EventSelectedListWidget(snapshot.data);
                }
                return Center(child: Text("Join an event !"));
              }),

          Divider(
            height: 30,
            thickness: 5,
            indent: 15,
            endIndent: 15,
          ),
//RECOMMENDED LIST WIDGET
          _buildRecommendedEventList(),
        ]));
  }

  Widget _buildRecommendedEventList() {
    //RECOMMENDED EVENT LIST
    return StreamBuilder(
      stream: widget.controller.recommendedEventStream,
      builder: (context, snapshot) {
        List<EventModel> events;
        if (!snapshot.hasData)
          events = [];
        else
          events = snapshot.data;

        return Column(
          children: [
            _buildRecommendedHeader(),
            EventListWidget(events, onItemTap: (event) {
              Navigator.pushNamed(context, Routes.EVENT_DETAIL_SCREEN_WITH_JOIN,
                  arguments: {Routes.ARG_EVENT_MODEL: event});
            })
          ],
        );
      },
    );
  }
  
  Widget _buildRecommendedHeader()
  {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment(-0.8, 1.0),
      child: Row(
        children: [
          Text(
            'Recommended Events',
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.deepPurple,
              fontFamily: 'One',
            ),
          ),
          Expanded(child: SizedBox()),
          Obx( () {
            return widget.controller.searching.value ?
            Center(
              child: CircularProgressIndicator(),
            )
                : IconButton(
              icon: Icon(Icons.refresh),
              iconSize: 40,
              onPressed: () =>
                  widget.controller.refreshRecommendations(),
            );
          }
          )
      ],
    ));
  }
  
}



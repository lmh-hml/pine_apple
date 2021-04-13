import 'package:flutter/material.dart';
import 'package:pine_apple/controller/pineapple_context.dart';
import 'package:pine_apple/import_firebase.dart';
import 'package:pine_apple/model/chat_message_model.dart';
import 'package:pine_apple/model/backend.dart';
import 'package:pine_apple/model/event_model.dart';
import 'package:pine_apple/screen/event_list_widget.dart';
import 'package:pine_apple/screen/event_selected_widget.dart';
import 'package:rxdart/rxdart.dart';
import 'screen.dart';
import 'package:pine_apple/data/events_json.dart';

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
            return widget.controller._searching.value ?
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

class EventsScreenController {
  EventsRepository _eventsRepository = EventsRepository();
  UserProfileReference userProfileReference;
  StreamController<List<GroupChatInfo>> _stream = BehaviorSubject();
  StreamController<List<EventModel>> _eventStream = BehaviorSubject();
  var _searching = false.obs;

  ///Constructor of EventScreenController
  ///Subscribes to the user's joined groups list to update the list of event groups that the user in a member of.
  EventsScreenController() {
    PineAppleContext.currentUser.getJoinedGroupsStream.listen((event) async {
      if (event.isEmpty) {
        _stream.add([]);
        return;
      }
      List<GroupChatInfo> list = await getUserJoinedEventGroups();
      if (list != null) _stream.add(list);
    });
  }

  ///Get all recommended events for the user according to their categories. If they do have any category selected,
  ///a general search for all current events is performed instead.
  Future<List<EventModel>> getRecommendedEvents() async {
    if (PineAppleContext.currentUid == null)
      return await _eventsRepository.getAllRecentEvents();
    else {
      String search = '';
      for (String category
          in PineAppleContext.currentUser.currentUserProfile.categories) {
        search += ',$category';
      }
      if (search.isBlank) return await _eventsRepository.getAllRecentEvents();
      return await _eventsRepository.searchEventWithKeyword(search);
    }
  }

  Future<void> refreshRecommendations() async {
    _searching.value = true;
    List<EventModel> results = await getRecommendedEvents();
    _eventStream.add(results);
    _searching.value = false;
  }

  ///Gets a snapshot of event groups that the user has joined.
  Future<List<GroupChatInfo>> getUserJoinedEventGroups() async {
    List<GroupChatInfo> groupChatInfo;
    List<String> ids =
        await PineAppleContext.currentUser.getJoinedEventGroups();
    if (ids.isEmpty) return groupChatInfo;
    groupChatInfo =
        await PineAppleContext.chatRepository.getMultipleChatGroupInfo(ids);
    return groupChatInfo;
  }

  ///Stream that fires whenever a the user joins a new event group
  Stream<List<GroupChatInfo>> get joinedEventStream => _stream.stream;
  Stream<List<EventModel>> get recommendedEventStream => _eventStream.stream;
}

import 'package:flutter/material.dart';
import 'package:pine_apple/import_firebase.dart';
import 'package:pine_apple/model/backend.dart';
import'package:pine_apple/model/event_model.dart';
import 'package:pine_apple/screen/screen.dart';
import 'package:rxdart/rxdart.dart';

import 'event_list_widget.dart';
import 'event_selected_widget.dart';

class SearchEvent extends StatefulWidget {
  @override
  _SearchEventState createState() => _SearchEventState();
}

class _SearchEventState extends State<SearchEvent> {

  TextEditingController _searchBarController = TextEditingController();
  SearchEventScreenController controller = SearchEventScreenController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.black,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: TextField(
          controller: _searchBarController,
          onSubmitted: (text)=>controller.doQuery(text),
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            hintText: 'Enter a keyword here...',
          ),
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
          cursorColor: Colors.black,
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 30),
            child: Obx(() {
              return controller.searching.value ?
              Center(child:CircularProgressIndicator()):
              Icon(Icons.check, color: Colors.black,);
            }),
          ),
        ],

      ),
      body: getBody(),
    );
  }
  Widget getBody(){
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget> [
          StreamBuilder(
              stream: controller.resultsStream,
              builder: (context, snapshot){
                List<EventModel> events;
                if(!snapshot.hasData) events = [];
                else events = snapshot.data;
                return _buildRecommendedEventList(events);
              }),
        ],

      ),
    );
  }

  Widget _buildRecommendedEventList(List<EventModel> events)
  {
    //RECOMMENDED EVENT LIST
    return Column(
      children: [
        Container(
          alignment: Alignment(-0.8, 1.0),
          height: 30.0,
        ),
        EventListWidget(events, onItemTap: (event){
          Navigator.pushNamed(context, Routes.EVENT_DETAIL_SCREEN_WITH_JOIN, arguments: {Routes.ARG_EVENT_MODEL:event});
        },),
      ],
    );
  }
}

class SearchEventScreenController
{
  EventsRepository _eventsRepository = EventsRepository();
  StreamController<List<EventModel>> _resultsStream = BehaviorSubject();
  var searching = false.obs;

  ///Perform a query based on the indicated keywords
  Future<void> doQuery(String keyword) async
  {
    searching.value = true;
    List<EventModel> results =  await _eventsRepository.searchEventWithKeyword(keyword);
    _resultsStream.add(results);
    searching.value = false;
  }

  ///Stream that updates whenever results from doQuery() is available.
  Stream<List<EventModel>> get resultsStream=>_resultsStream.stream;
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pine_apple/model/event_model.dart';

///Takes a list of EventModel objects and displays them in a column widget.
class EventListWidget extends StatefulWidget {
  final List<EventModel> events;
  final Function(EventModel) onItemTap;
  EventListWidget(this.events,{this.onItemTap});

  @override
  _EventListWidgetState createState() => _EventListWidgetState();
}

class _EventListWidgetState extends State<EventListWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.events.isEmpty
        ? Container(
            margin: EdgeInsets.all(20),
            child: Center(child: Text('No events available')))
        : Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              for (EventModel event in widget.events) EventListItem(event,onTap: widget.onItemTap ,)
            ],
          );
  }
}

class EventListItem extends StatelessWidget {
  final EventModel event;
  final Function(EventModel) onTap;
  EventListItem(this.event, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            InkWell(
              onTap: ()=>onTap.call(event)??null, // Handle your callback
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: CachedNetworkImage(
                        imageUrl: event.imageURL,
                        fit: BoxFit.fitWidth,
                      )
                      ),

                    Container(
                      padding:
                          EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
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
                                text: event.title,
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
                      padding:
                          EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "Categories:  ",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontFamily: 'One',
                                ),
                              ),
                              TextSpan(
                                text: event.keywordString,
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
                      padding: EdgeInsets.only(
                          left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
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
                                text: event.startDate,
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
                                text: event.endDate,
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
        ),
      ),
    );
  }
}

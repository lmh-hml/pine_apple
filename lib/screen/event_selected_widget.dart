import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pine_apple/model/ChatMessage.dart';
import 'package:pine_apple/model/backend.dart';
import 'package:pine_apple/model/event_model.dart';
import 'package:pine_apple/screen/screen.dart';

class EventSelectedListWidget extends StatelessWidget {
  final List<GroupChatInfo> list;
  EventSelectedListWidget(this.list);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        Column(children: _buildList(context, list)),
      ],
    );
  }
  List<Widget> _buildList(BuildContext context, List<GroupChatInfo> list)
  {
    List<Widget> widgets = [];
    for (GroupChatInfo info in list)
    {
      if(info.type == ChatType.EVENT && info.detail!=null)
        {
          EventModel event = EventModel.fromMap(info.detail);
          widgets.add(EventSelectedItem(
              title: event.title,
              startDate: event.startDate,
              endDate: event.endDate,
              onTap: () => Navigator.pushNamed(context, Routes.CHAT_SCREEN,
              arguments: {Routes.ARG_GROUP_CHAT_INFO: info})));
        }
    }
    return widgets;
  }

}

class EventSelectedItem extends StatelessWidget {
  final String title;
  final String startDate, endDate;
  final Function onTap;

  const EventSelectedItem(
      {Key key, this.title, this.startDate, this.endDate, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: onTap,
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
                    children: <Widget>[
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
                            text: '$startDate - $endDate',
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

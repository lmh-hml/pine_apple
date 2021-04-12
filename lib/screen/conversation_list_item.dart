import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pine_apple/model/ChatMessage.dart';
import 'package:pine_apple/model/backend.dart';
import 'chat_screen.dart';
import 'package:get/get.dart';

class ConversationListItem extends StatefulWidget {
  final GroupChatInfo groupInfo;
  final Function(GroupChatInfo) onTap;

  ConversationListItem(
      {@required this.groupInfo,
      @required this.onTap,
  });
  @override
  _ConversationListItemState createState() => _ConversationListItemState();
}

class _ConversationListItemState extends State<ConversationListItem> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap.call(widget.groupInfo);
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    //backgroundImage: NetworkImage(widget.imageUrl),
                    maxRadius: 30,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,size: 40,),
                    backgroundColor: Colors.redAccent,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.groupInfo.groupChatName,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          if(widget.groupInfo.latestMessage!=null)
                            Text(
                            widget.groupInfo.latestMessage.text,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if(widget.groupInfo.latestMessage!=null)Text(
              DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(widget.groupInfo.latestMessage.timestamp)),
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }


}

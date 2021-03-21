import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pine_apple/controller.dart';
import 'model.dart';



class StreamChatMessageList extends StatefulWidget {

  final Stream<List<ChatMessage>> stream;
  User currentUser = Get.find<AccountController>().currentUser;

  StreamChatMessageList({@required this.stream,});

  @override
  _StreamChatMessageListState createState() => _StreamChatMessageListState();
}

class _StreamChatMessageListState extends State<StreamChatMessageList> {
  final  _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: this.widget.stream,
      builder: (context,streamData)
        {
          if(streamData.hasData)
            {
              return  ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  itemCount: streamData.data.length,
                  reverse: true,


                  itemBuilder: (context, index){
                    int reversedIndex = streamData.data.length - index -1;
                    if(streamData.data[reversedIndex]==null)return null;
                    return ChatBubble(streamData.data[reversedIndex], userId: widget.currentUser.uid,);
                  }
              );
            }
          else {
            return
              Center(child: CircularProgressIndicator());
          }
        }
    );
  }
}

class ChatBubble extends StatefulWidget {
  ChatMessage _cm;
  String userId;
  ChatBubble(ChatMessage message, {@required this.userId})
  {
    _cm = message;
  }

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {

    bool isUser =  (widget.userId == widget._cm.sender);
    return Align(
        alignment: widget.userId == widget._cm.sender ? Alignment.centerRight : Alignment
            .centerLeft,
        child: Container(
          margin: EdgeInsets.fromLTRB(
              isUser? 100:10,
              10,
              isUser?10:30,
              10),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: context.theme.primaryColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: isUser ? CrossAxisAlignment
                .end : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              !isUser ? Text(widget._cm.username,
                style: TextStyle(fontWeight: FontWeight.bold),):SizedBox(),
              Row(
                children: [
                  Flexible(child: Text(widget._cm.text, style: TextStyle(fontSize: 18),softWrap: true,)),
                  SizedBox(width: 20),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                          children: [
                            Text( DateFormat(DateFormat.HOUR_MINUTE).format(DateTime.fromMillisecondsSinceEpoch(widget._cm.timestamp).toLocal())),
                            Icon(Icons.mark_chat_read, size: 15,)
                          ]))
                ],
                mainAxisSize: MainAxisSize.min,
              )
            ],
          ),
        )
    );
  }
}





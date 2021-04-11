import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pine_apple/model/UserProfile.dart';
import 'package:pine_apple/model/backend.dart';
import 'model/ChatMessage.dart';



class StreamChatMessageList extends StatefulWidget {

  final Stream<List<ChatMessage>> stream;
  UserProfile currentUserProfile;
  StreamChatMessageList({@required this.stream, @required this.currentUserProfile});
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
                    return ChatBubble(streamData.data[reversedIndex], userId: widget.currentUserProfile.uid,);
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

    bool isUser =  (widget.userId == widget._cm.senderUid);
    return Align(
        alignment: widget.userId == widget._cm.senderUid ? Alignment.centerRight : Alignment
            .centerLeft,
        child: Container(
          //constraints: BoxConstraints(maxWidth: 200),
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
            crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              !isUser ? Text(widget._cm.senderName,
                style: TextStyle(fontWeight: FontWeight.bold),):SizedBox(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget._cm.text, style: TextStyle(fontSize: 18),softWrap: true,),
                  SizedBox(width: 20),
                ],
              ),

            ],
          ),
        )
    );
  }
}





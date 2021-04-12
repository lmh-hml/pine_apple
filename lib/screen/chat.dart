import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:pine_apple/model/ChatMessage.dart';
import 'package:pine_apple/model/backend.dart';
import 'package:pine_apple/StreamChatMessageList.dart';
import 'package:pine_apple/screen/message_entry_bar.dart';

class PineAppleChat extends StatefulWidget {

  String chatId;
  String userId;

  PineAppleChat(this.chatId, this.userId) {
    log("Calling chat constructor!");
    log("Using chat as: $userId");
  }

  @override
  _PineAppleChatState createState() => _PineAppleChatState();
}

class _PineAppleChatState extends State<PineAppleChat> {
  TextEditingController messageTextController = new TextEditingController();
  ChatMessagesReference chatController;
  ProfilesRepository _userController;


  @override
  void initState() {
    chatController = ChatMessagesReference(widget.chatId);
    _userController = Get.find();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: ChatAppBar(context),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: StreamChatMessageList(
                stream: chatController.stream,
              ),
            ),
            //MESSAGE ENTRY WIDGET
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: context.theme.cardColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          offset: Offset(0, -2),
                          blurRadius: 10)
                    ]),

                //MESSAGE ENTRY WIDGET
                child: MessageEntryBar(
                  onSend: createAndUploadMessage
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ChatAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        child: Row(
          children: [
            IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: (){
                  Get.find<AuthService>(tag: "AccountController").signOut();
                  Get.back();
                },
                color: ThemeData.light().buttonColor),
            CircleAvatar(
              maxRadius: 20,
              backgroundImage: NetworkImage(
                  "https://cdn.pixabay.com/photo/2015/02/14/18/10/pineapple-636562_1280.jpg"),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.chatId,
                  style: new TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Text("Hello",
                    style: new TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                    ))
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.info), onPressed: _onChatInfoButton),
        _chatOptionsButton(),
      ],
    );
  }

  Widget _chatOptionsButton() {
    return PopupMenuButton(
      //item builder: make a list of options to populate the popup menu.
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text("Group Info"),
          value: _onGroupinfoOption,
        ),
      ],
      onSelected: (Function value) {
        value.call();
      },
    );
  }

  void _onGroupinfoOption() {
    log("Show Group Info!!!!");
  }

  void _onChatInfoButton() {
    log("Show Group Info!!!!");
  }

  void onMessageAvailable(ChatMessage cm) {
    messageTextController.clear();
    log("MessageAvialble!");
  }

  void createAndUploadMessage(chatMessage) {
    ChatMessage cm = ChatMessage(
        senderUid: widget.userId,
        text: chatMessage,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        senderName:Get.find<UserProfileReference>(tag: "UserProfileController").currentUserProfile.username);
    log("Sending this data: "+cm.map.toString());
    messageTextController.clear();
    chatController.addMessage(cm);
  }
}

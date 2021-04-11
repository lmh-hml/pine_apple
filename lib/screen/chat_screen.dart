import 'package:flutter/material.dart';
import 'package:pine_apple/StreamChatMessageList.dart';
import 'package:pine_apple/controller/pineapple_context.dart';
import 'package:pine_apple/model/ChatMessage.dart';
import 'package:pine_apple/model/UserProfile.dart';
import 'package:pine_apple/model/backend.dart';
import 'package:pine_apple/screen/screen.dart';
import 'group_detail_screen.dart';
import 'message_entry_bar.dart';


class ChatScreen extends StatefulWidget {
  final ChatController controller;

  ChatScreen(this.controller);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  UserProfile profile;
  @override
  void initState() {
    profile = widget.controller.userProfile;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.GROUP_DETAIL_SCREEN, arguments: {Routes.ARG_GROUP_CHAT_INFO:widget.controller.groupChatInfo});
                    },
                    icon: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://cdn.dribbble.com/users/673318/screenshots/13978817/media/726e5ff73caaef10c1a8a7f473547638.png?compress=1&resize=400x300"),
                      maxRadius: 20,
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.controller.groupName,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert),
                    color: Colors.black54,
                    onPressed: ()async {
                      await PineAppleContext.chatRepository.removeMemberFromGroup(PineAppleContext.currentUid, widget.controller.groupChatInfo.groupChatUid);
                      Navigator.pushReplacementNamed(context, Routes.CONVERSATION_LIST);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: StreamChatMessageList(
                stream: widget.controller.messageStream,
                currentUserProfile: widget.controller.userProfile,
              ),
            ),
            Align(
                alignment: Alignment.bottomLeft,
                child: MessageEntryBar(
                  onSend: (t) {
                    widget.controller.uploadMessage(t);
                  },
                )),
          ],
        ));
  }

}

class ChatController {

  final ChatMessagesReference messagesReference;
  final ChatGroupReference chatGroupReference;
  final UserProfile userProfile;
  final GroupChatInfo groupChatInfo;

  ChatController(
      {this.userProfile,
      this.groupChatInfo}):
      messagesReference = ChatMessagesReference(groupChatInfo.groupChatUid),
      chatGroupReference = ChatGroupReference(groupChatInfo.groupChatUid);

  String get groupName =>  groupChatInfo.groupChatName;
  Stream<List<ChatMessage>> get messageStream => messagesReference.stream;
  Future<void> uploadMessage(String text) async
  {
    return await messagesReference.addMessage(
        ChatMessage(
            senderName: userProfile.username,
            senderUid: userProfile.uid,
            timestamp: DateTime.now().millisecondsSinceEpoch,
            text: text
        )
    );
  }



}

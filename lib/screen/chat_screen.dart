import 'package:flutter/material.dart';
import 'package:pine_apple/StreamChatMessageList.dart';
import 'package:pine_apple/controller/pineapple_context.dart';
import 'package:pine_apple/import_firebase.dart';
import 'package:pine_apple/model/chat_message_model.dart';
import 'package:pine_apple/model/user_profile_model.dart';
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
                    icon: Icon(Icons.info, color:Colors.grey, size: 35,),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Text(
                      widget.controller.groupName,
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.fade,
                      softWrap: true,
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  IconButton(
                    icon: Icon(Icons.cancel,color: Colors.redAccent, size: 30,),
                    color: Colors.black54,
                    onPressed: ()async {
                      await PineAppleContext.chatRepository.removeMemberFromGroup(PineAppleContext.currentUid, widget.controller.groupChatInfo.groupChatUid);
                      Navigator.pop(context);
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

  ///Gets the name of the current group.
  String get groupName =>  groupChatInfo.groupChatName;
  ///Gets the stream that fires whenever a new message is uploaded.
  Stream<List<ChatMessage>> get messageStream => messagesReference.stream;
  ///Controller function to upload message to the database
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
  Future<void> onRemoveUser() async
  {
    await PineAppleContext.chatRepository.removeMemberFromGroup(PineAppleContext.currentUid, groupChatInfo.groupChatUid);
  }



}

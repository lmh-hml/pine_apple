import 'package:intl/intl.dart';
import 'package:pine_apple/import_firebase.dart';
import 'package:pine_apple/model/ChatMessage.dart';
import 'package:pine_apple/model/UserProfile.dart';
import 'package:pine_apple/model/backend.dart';
import 'package:pine_apple/screen/screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';


class ConversationListScreen extends StatefulWidget {

  final ConversationListController controller;
  ConversationListScreen(this.controller);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ConversationListScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(
                    Icons.search, color: Colors.grey.shade600, size: 20,),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey.shade100
                      )
                  ),
                ),
              ),
            ),
            StreamBuilder<List<GroupChatInfo>>(
                stream: widget.controller.joinedGroups,
                builder: (context, snapshot) {

                  if (!snapshot.hasData)
                    return Center(child:Text("Join a group to chat and more !"),);

                  List<GroupChatInfo> data = snapshot.data;

                  return ListView.builder(
                      itemCount: data.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 16),
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        GroupChatInfo gci = data[index];
                        return ConversationListItem(
                          groupInfo: gci,
                          onTap: (GroupChatInfo gci)
                          {
                            Get.toNamed(Routes.CHAT_SCREEN, arguments: {Routes.ARG_GROUP_CHAT_INFO:gci});
                          },
                        );
                      },
                    );
                }
            ),
          ],
        ),
      ),
    );
  }
}
class ConversationListController
{
  final ChatRepository _repository = ChatRepository();
  final UserProfileReference userProfileReference;
  StreamController<List<GroupChatInfo>> _stream = BehaviorSubject();
  List<GroupChatInfo> _chatList = [];


  ConversationListController( this.userProfileReference)
  {
    userProfileReference.getJoinedGroupsStream.listen((event) async {
        _chatList = await _repository.getMultipleChatGroupInfo(event);
        _stream.add(_chatList);
    });
  }

  ///Gets a snapshot of the groups that this user is a member of.
  Future<List<GroupChatInfo>> getGroupList() async
  {
    List<String> l = await userProfileReference.getJoinedGroups();
    List<GroupChatInfo> results = await _repository.getMultipleChatGroupInfo(l);
    return results;
  }

  ///Gets the stream that publishes user's chat list and updates whenever the user join/leaves a group
  Stream<List<GroupChatInfo>> get joinedGroups => _stream.stream;
}

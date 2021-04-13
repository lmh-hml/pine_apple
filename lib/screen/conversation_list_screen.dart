import 'package:intl/intl.dart';
import 'package:pine_apple/import_firebase.dart';
import 'package:pine_apple/model/chat_message_model.dart';
import 'package:pine_apple/model/user_profile_model.dart';
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

  TextEditingController searchController = TextEditingController();


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
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onSubmitted: (text)=>widget.controller.onQuery(text),
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
                  IconButton(icon: Icon(Icons.cancel), onPressed: (){
                    searchController.clear();
                    widget.controller.onClear();
                  })
                ],
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
  bool searching = false;


  ConversationListController( this.userProfileReference)
  {
    userProfileReference.getJoinedGroupsStream.listen((event) async {
        _chatList = await _repository.getMultipleChatGroupInfo(event);
        if(!searching)_stream.add(_chatList);
    });
  }

  ///Gets a snapshot of the groups that this user is a member of.
  Future<List<GroupChatInfo>> getGroupList() async
  {
    List<String> l = await userProfileReference.getJoinedGroups();
    List<GroupChatInfo> results = await _repository.getMultipleChatGroupInfo(l);
    return results;
  }

  Future<void> onQuery(String string)
  {
    searching = true;
    List<GroupChatInfo> results = [];
    for(GroupChatInfo info in _chatList)
      {
        if(info.groupChatName.contains(string))
          {
            results.add(info);
          }
      }
    _stream.add(results);
  }

  void onClear()
  {
    searching = false;
    _stream.add(_chatList);
  }

  ///Gets the stream that publishes user's chat list and updates whenever the user join/leaves a group
  Stream<List<GroupChatInfo>> get joinedGroups => _stream.stream;
}

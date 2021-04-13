import 'dart:async';
import 'package:pine_apple/model/chat_message_model.dart';
import 'package:pine_apple/model/chat_repository.dart';
import 'package:pine_apple/model/profiles_repository.dart';
import 'package:rxdart/rxdart.dart';

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

  ///Performs a query using the keyword provided.
  ///This will cause the stream to be updated with a list of chats whose title contains the keyword.
  ///THe stream can be updated with an empty list if no such chat exists.
  Future<void> onQuery(String keyword) async
  {
    searching = true;
    List<GroupChatInfo> results = [];
    for(GroupChatInfo info in _chatList)
    {
      if(info.groupChatName.contains(keyword))
      {
        results.add(info);
      }
    }
    _stream.add(results);
    return;
  }

  ///Method for the view to call upon an clearing action.
  ///This will cause the stream to be updated with the unsorted list of chats before any query is performed.
  void onClear()
  {
    searching = false;
    _stream.add(_chatList);
  }

  ///Gets the stream that publishes user's chat list and updates whenever the user join/leaves a group
  Stream<List<GroupChatInfo>> get joinedGroups => _stream.stream;
}
import 'package:pine_apple/controller/pineapple_context.dart';
import 'package:pine_apple/model/chat_message_model.dart';
import 'package:pine_apple/model/chat_repository.dart';
import 'package:pine_apple/model/user_profile_model.dart';

class GroupDetailsScreenController {
  ChatGroupReference _chatGroupReference;

  ///CONSTRUCTOR
  GroupDetailsScreenController(String uid)
      : _chatGroupReference = ChatGroupReference(uid);

  ///Gets a snapshot of the group's information
  Future<GroupChatInfo> getGroupChatInfo() async {
    return await _chatGroupReference.getGroupInfo();
  }

  ///Gets a list of user profiles with ids in the indicated list.
  Future<List<UserProfile>> getUserProfileList(List<String> uids) async {
    return await PineAppleContext.profilesRepository.getMultipleProfiles(uids);
  }
}
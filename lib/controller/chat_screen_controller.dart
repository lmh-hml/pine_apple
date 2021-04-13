import 'package:pine_apple/controller/pineapple_context.dart';
import 'package:pine_apple/model/chat_message_model.dart';
import 'package:pine_apple/model/chat_repository.dart';
import 'package:pine_apple/model/user_profile_model.dart';

class ChatController {

  final ChatMessagesReference _messagesReference;
  final ChatGroupReference _chatGroupReference;
  final UserProfile userProfile;
  final GroupChatInfo groupChatInfo;

  ChatController(
      {this.userProfile,
        this.groupChatInfo}):
        _messagesReference = ChatMessagesReference(groupChatInfo.groupChatUid),
        _chatGroupReference = ChatGroupReference(groupChatInfo.groupChatUid);

  ///Gets the name of the current group.
  String get groupName =>  groupChatInfo.groupChatName;
  ///Gets the stream that fires whenever a new message is uploaded.
  Stream<List<ChatMessage>> get messageStream => _messagesReference.stream;
  ///Controller function to upload message to the database
  Future<void> uploadMessage(String text) async
  {
    return await _messagesReference.addMessage(
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

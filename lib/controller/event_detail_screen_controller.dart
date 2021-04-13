import 'package:pine_apple/controller/pineapple_context.dart';
import 'package:pine_apple/model/chat_message_model.dart';
import 'package:pine_apple/model/chat_repository.dart';
import 'package:pine_apple/model/event_model.dart';
import 'package:pine_apple/screen/screen.dart';

import '../import_firebase.dart';

class EventDetailScreenController
{
  ///Method to call when a view's join button is tapped
  ///Attempts to move tothe chat page of the group. If the chat page does not exist for the
  ///group, a new one is created, then the user is moved to the chat page.
  Future<void> onJoinTapped(BuildContext context, EventModel event) async
  {
    ChatRepository _chatRepository = PineAppleContext.chatRepository;

    GroupChatInfo info = await _chatRepository.getEventGroupChatInfo(event.id);
    if(info==null)
    {
      info = await _chatRepository.createEventGroupChatInfo(event, [PineAppleContext.currentUid]);
    }
    else{
      await _chatRepository.addMemberToGroup(PineAppleContext.currentUid, info.groupChatUid, type: ChatType.EVENT);
    }
    Navigator.pushNamed(context, Routes.CHAT_SCREEN, arguments: { Routes.ARG_GROUP_CHAT_INFO:info});
  }

}
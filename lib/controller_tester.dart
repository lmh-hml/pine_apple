import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pine_apple/controller/pineapple_context.dart';
import 'package:pine_apple/model/chat_message_model.dart';
import 'package:pine_apple/model/backend.dart';
import 'package:pine_apple/model/event_model.dart';
// import 'package:pine_apple/controller/pineapple_context.dart';
// import 'package:pine_apple/model/chat_message_model.dart';
// import 'package:pine_apple/model/backend.dart';
// import 'package:pine_apple/model/chat_repository.dart';
import 'package:pine_apple/model/events_repository.dart';
import 'package:pine_apple/screen/chat.dart';
import 'package:pine_apple/screen/events_screen.dart';


void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  final _firebaseInit = await Firebase.initializeApp();
  EventsRepository evp = EventsRepository();
  PineAppleContext.initialize();

  UserProfileReference reference = UserProfileReference('vcRvpBgZ0GR2zl4NgmuMXmRaazy1');
  EventsScreenController evx = EventsScreenController();
  List<String> list = await reference.getJoinedEventGroups();
  List<GroupChatInfo> info = await evx.getUserJoinedEventGroups();

  EventModel event = EventModel(title: 'Hello',startDateTIme: DateTime.now(), endDateTime: DateTime.now(),id: 999.toString());
  ChatRepository chatRepository  = ChatRepository();
  await chatRepository.createEventGroupChatInfo(event, ['vcRvpBgZ0GR2zl4NgmuMXmRaazy1']);
  GroupChatInfo groupInfo = await chatRepository.getEventGroupChatInfo(event.id);

}
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:pine_apple/controller/pineapple_context.dart';
// import 'package:pine_apple/model/ChatMessage.dart';
// import 'package:pine_apple/model/backend.dart';
// import 'package:pine_apple/model/chat_repository.dart';
import 'package:pine_apple/model/events_repository.dart';


void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  final _firebaseInit = await Firebase.initializeApp();
  EventsRepository evp = EventsRepository();
  List<EventModel> list = await evp.searchEventsByCategory('concert');
  for(var item in list)
    {
      print('${item.title}:${item.keywords}');
    }

}
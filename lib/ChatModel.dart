import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_list.dart';
import 'package:flutter/cupertino.dart';
import 'model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatModel extends ChangeNotifier {
  List<ChatMessage> _chatMessages = [];

  UnmodifiableListView<ChatMessage> get chatMessages =>
      UnmodifiableListView(_chatMessages);
  void addMessage(ChatMessage cm) {
    _chatMessages.add(cm);
    notifyListeners();
  }
}

class ChatFirebaseModel {
  final DatabaseReference _firebaseRTB =
      FirebaseDatabase.instance.reference().child("chat");
  FirebaseList fbl;
  List<ChatMessage> messageList = List();
  StreamController<List<ChatMessage>> stream;

  ChatFirebaseModel({@required this.stream}) {

    fbl = FirebaseList(
        query: _firebaseRTB.child("basketball").orderByChild("timestamp"),
        onChildMoved: (i,j,d){},
        onValue: (_){},
        onChildAdded: (i, d) {
          log("${i}, ${d.value}");
          messageList.add(ChatMessage(
              d.value["text"],
              d.value["sender"],
              d.value["timestamp"]));
          stream.add(messageList);
        }
        );
  }

  void addMessage(ChatMessage cm) {
    _firebaseRTB.child("1").child("new").set({"hey": "you"});
  }

  Stream getGroupChatStream(String groupName) {
    return _firebaseRTB.child(groupName).orderByChild("timestamp").onValue;
  }

  DatabaseReference getGroupChatReference(String groupName) {
    return _firebaseRTB.child(groupName).reference();
  }
}



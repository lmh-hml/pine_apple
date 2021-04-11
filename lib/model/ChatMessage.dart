import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../import_firebase.dart';

///Class representing a Chat Message
class ChatMessage {

  static const String SENDER = "sender";
  static const String TEXT = "text";
  static const String TIMESTAMP = "timestamp";
  static const String USERNAME = "username";

  String senderUid = ""; //The uid of the user who sent the message
  String text = ""; //The text of the message
  int timestamp = 0; //The timestamp of the message, in terms of milliseconds since epoch time.
  String senderName = ""; //Username of the sender.

  String get timeStampString => timestamp.toString();

  ChatMessage({this.senderUid, this.text,this.senderName, this.timestamp})
  {
    timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;
  }

  ChatMessage.fromMap(Map map)
  {
    senderUid = map[SENDER]??"";
    text = map[TEXT]??"";
    timestamp = map[TIMESTAMP]??"";
    senderName = map[USERNAME] ?? "";
  }

  ///Returns a map representation of this object.
  Map get map {
    return {
      "sender": senderUid,
      "text": text,
      "timestamp":timestamp,
      "username": senderName
    };
  }

  @override
  String toString() {
    return this.map.toString();
  }

}


class GroupChatInfo
{
  static const String UID = "groupChatUid";
  static const String GROUP_NAME = "groupChatName";
  static const String CHAT_ICON = "groupChatIcon";
  static const String LATEST_MSG = "latestMessage";
  static const String MEMBERS = "members";
  static const String ADMINS = "adminsUid";
  static const String LATEST = "latest";
  static const String CHAT_TYPE = "type";
  static const CHAT_TYPE_GENERAL = "general";
  static const CHAT_TYPE_ONE_TO_ONE = 'oneToOne';

  String _groupChatUid;
  String get groupChatUid => _groupChatUid;
  String _groupChatName;
  String _groupChatIcon;
  ChatMessage _latestMessage;
  Map _membersUid;
  Map _adminsUid;
  String _type;


  GroupChatInfo(String groupChatUid, String groupChatName,{List<dynamic> membersId, List<dynamic>adminsUid, String type})
  {
    _groupChatUid = groupChatUid;
    _groupChatName = groupChatName;
    _membersUid = {};
    _adminsUid = {};
    _type = type ?? CHAT_TYPE_GENERAL;
    if(membersId!=null)
      {
        for(var item in membersId)
        {
          _membersUid[item.toString()] = 1;
        }
      }

    if(adminsUid!=null)
      {
        for(var item in adminsUid)
        {
          _adminsUid[item.toString()] = 2;
        }
      }

  }

  GroupChatInfo.fromMap(Map map)
  {
    _groupChatUid = map[UID]??"";
    _groupChatName = map[GROUP_NAME]??"";
    _groupChatIcon = map[CHAT_ICON]??"";
    _membersUid = map[MEMBERS]??{};
    _adminsUid = map[ADMINS]??{};
    _latestMessage = map[LATEST]!=null ? ChatMessage.fromMap(map[LATEST]):null;
    _type = map[CHAT_TYPE] ?? CHAT_TYPE_GENERAL;
  }

  Map toMap() {
    return {
      UID:_groupChatUid,
      GROUP_NAME: _groupChatName,
      CHAT_ICON: _groupChatIcon,
      MEMBERS: _membersUid,
      ADMINS: _adminsUid,
      LATEST : _latestMessage?.map,
      CHAT_TYPE:_type
    };
  }

  String get groupChatName => _groupChatName;
  String get groupChatIcon => _groupChatIcon;
  ChatMessage get latestMessage => _latestMessage;
  List<String> get membersUid => List<String>.from(_membersUid.keys.toList(growable: false));
  List get adminsUid => _adminsUid.keys.toList(growable:  false);
  String get type => _type;

}
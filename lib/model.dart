import 'dart:collection';

import 'package:flutter/cupertino.dart';

///A class that models data of an interest group.
class InterestGroup {
  String _name; //Name of group to be displayed in the app.
  List<String> _interests; //List of interests associated with this group
  List<String> _members; //List of member's uid of this group
  String _uid; //The uid of this group, used to identify it in a database.

  String get name => _name;

  UnmodifiableListView<String> get interests => _interests;

  UnmodifiableListView<String> get members => _members;

  String get uid => _uid;

  InterestGroup(this._name, this._interests, this._members, this._uid);
}

///Class representing a group chat session.
class GroupChat {
  String _uid;
  List<ChatMessage> _messages;
  List<String> _messageUid;

  String get uid => _uid;
  List<ChatMessage> get messages => _messages;

  GroupChat(this._uid, this._messages, this._messageUid);
}

///Class representing a Chat Message
class ChatMessage {
  String _sender = ""; //The uid of the user who sent the message
  String _text = ""; //The text of the message
  int _timestamp =
      0; //The timestamp of the message, in terms of milliseconds since epoch time.
  String username = ""; //Username of the sender.

  String get sender => _sender;
  int get timestamp => _timestamp;
  String get text => _text;
  String get uid => _timestamp.toString();

  ChatMessage(this._sender, this._text, this._timestamp,
      {@required this.username});

  Map get map {
    return {
      "sender": _sender,
      "text": _text,
      "timestamp": _timestamp,
      "username": username
    };
  }
}

///A class that holds user information for authentication and
///the uid of this user for accessing databases.
class PineAppleUser {
  String _uid; //Uid of this user in the databse
  String _email; //Email of this user
  String _userName; //Username of this user
  String _iconURL; //Url to this user's icon

  PineAppleUser(this._uid, this._email, this._userName, this._iconURL);

  String get uid => _uid;

  String get iconURL => _iconURL;

  String get userName => _userName;

  String get email => _email; //Text of this user's profile description.
}

///A class that holds user information not related to authentication
///such as interests, groups joined and profile descriptions.
class UserProfile {
  List<String> interests;
  List<String> joinedGroups;
  String description;
  String username;
  String photoURL;
  String uid;

  UserProfile(
      {this.interests,
      this.joinedGroups,
      this.description,
      this.username,
      this.photoURL,
      this.uid});

  UserProfile.fromMap(Map map)
  {
    description = map["description"]??"Null";
    username = map["userName"]??"Null";
    uid = map["uid"]??"Null";
    photoURL = map["photoURL"]??"Null";
  }

  Map<String, dynamic> get map {
    return {
      "description": description,
      "userName": username,
      "uid": uid,
      "photoURL":photoURL
    };
  }
}

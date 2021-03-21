import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'model.dart';
import 'dart:developer';

///This class serves as the intermediary between a database serve and its api to this app.
///For example:
///DatabaseController dbc = ...;
///dbc.users.get(uid);
class DatabaseController {
  //FIREBASE API
  DatabaseReference _firebaseDatabase = FirebaseDatabase.instance.reference();
  DatabaseReference _users;
  DatabaseReference _groups;
  DatabaseReference _chats;

  DatabaseController() {
    _users = _firebaseDatabase.child("users");
    _groups = _firebaseDatabase.child("groups");
    _chats = _firebaseDatabase.child("chats");
  }

  DatabaseReference get users => _users;
  DatabaseReference get groups => _groups;
  DatabaseReference get chats => _chats;

  void addMessage(GroupChat group, ChatMessage cm) {
    _chats.child(group.uid).set(cm.map);
  }
}

///A class that serves as the controller of a chat session.
///Handles downloading and uploading of chat messages.
class ChatController {
  final DatabaseReference _chatsReference =
      FirebaseDatabase.instance.reference().child("chats");
  DatabaseReference _chatGroupReference;
  FirebaseList _fbl;
  List<ChatMessage> _messageList = List();
  StreamController<List<ChatMessage>> _messageStream =
      StreamController(); //Stream for passing downloaded messages to the rest of the app.
  StreamController<ChatMessage> _messageUploadStream =
      StreamController(); //Stream for uploading messages from the app to the database

  ChatController({@required String groupUid}) {
    _chatGroupReference = _chatsReference.child(groupUid);
    setChatGroup(groupUid);
  }

  void setChatGroup(String groupUid) {
    log("Setting up chat group: " + groupUid);
    _messageList.clear();
    _chatGroupReference = _chatsReference.child(groupUid);
    _fbl = FirebaseList(
      query: _chatGroupReference.orderByChild("timestamp"),
      onChildMoved: (i, j, d) {},
      onValue: (d) {},
      onChildAdded: (i, d) {
        _messageList.add(ChatMessage(
            d.value["sender"], d.value["text"], d.value["timestamp"],
            username: d.value["username"]));
        _messageStream.add(_messageList);
      },
    );
  }

  //TODO: MAKE A REFRESH METHOD THAT TAKES A SNAPSHOT< SORT THE KEYS AND CREATE A NEW LIST FOR THE MESSAGE LIST TO REBUILD ON

  void addMessage(ChatMessage cm) {
    _chatGroupReference.update({cm.timestamp.toString(): cm.map});
  }

  void close() {
    _messageStream.close();
    _messageUploadStream.close();
  }

  Stream<List<ChatMessage>> get stream => _messageStream.stream;
  Stream<ChatMessage> get upload => _messageUploadStream.stream;
}

///Class that handles signing in ,singing out and registering of the app.
class AccountController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User _user;

  ///Sign in using the provided email and password. If successful, return a User object containing the user's information.
  ///If unsuccessful, function returns null.
  Future<User> signIn(
      {@required String email, @required String password}) async {
    try {
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _user = userCred.user;
      return _user;
    } on FirebaseAuthException catch (e) {
      log("Sign In exception: " + e.code);
      return null;
    }
  }

  ///Create an account using the provided email and password. If successful, return a User object containing the user's information.
  ///If unsuccessful, function returns null.
  Future<User> register(
      {@required String email, @required String password}) async {
    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseDatabase.instance.reference().child("users").update({
        userCred.user.uid: {
          "uid": userCred.user.uid,
          "email": userCred.user.email,
          "userName": userCred.user.email,
          "iconURL": userCred.user.photoURL,
          "description": "Hi! I'm using pineaple."
        }
      });
      _user = userCred.user;
      return _user;
    } on FirebaseAuthException catch (e) {
      log("Register Exception: " + e.code);
      return null;
    }
  }

  void signOut() {
    _auth.signOut();
    _user = null;
  }

  User get currentUser => _user;
}

///Class that handles user's profile and information,
///such as adding interests and updating profiles.
///This class can be used to view the list of groups by the current user, but
///is not responsible for adding/removing the user to and from groups.
class UserController {
  ///DatabaseReference to the user's profile information. (users/<uid>)
  DatabaseReference _profileReference;
  UserProfile _userProfile;

  UserController()
  {
    _profileReference =
        FirebaseDatabase.instance.reference().child("users");
  }

  Future<UserProfile> getUserProfile(String uid) async {
    DatabaseReference ref =  _profileReference.child(uid);
    DataSnapshot dns = await ref.once();
    _userProfile = UserProfile.fromMap(dns.value);
    return _userProfile;
  }

  UserProfile get currentUserProfile => _userProfile;

  void reset() {
    _profileReference = null;
    _userProfile = null;
  }

  void updateProfile() {
    _profileReference.update({ _userProfile.uid: _userProfile.map});
  }
}

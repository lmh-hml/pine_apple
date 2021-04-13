import 'package:flutter/material.dart';

import '../import_firebase.dart';
import 'user_profile_model.dart';
import 'package:rxdart/rxdart.dart';
import 'chat_repository.dart';

///Model serving as link between the profiles section in database and the app.
class ProfilesRepository {
  ///DatabaseReference to the profiles of users of the app.
  DatabaseReference  _databaseReference = FirebaseDatabase.instance.reference().child("users");

  ProfilesRepository();
  ///Gets a snapshot of the profile of the user with the specified uid.
  Future<UserProfile> getUserProfile(String uid) async {
    DatabaseReference ref = _databaseReference.child(uid);
    DataSnapshot snapshot = await ref.once();
    UserProfile userProfile = UserProfile.fromMap(snapshot.value);
    return userProfile;
  }
  ///Gets a UserProfileReference with the specified uid.
  UserProfileReference getProfileReference(String uid){
    return UserProfileReference(uid);
  }
  Future<List<UserProfile>> getMultipleProfiles(List<String> uids)async{
    List<UserProfile> results = [];
    for(String id in uids)
    {
      await _databaseReference.orderByKey().equalTo(id).once().then((DataSnapshot snapshot){
        if(snapshot.value!=null)
        {
          results.add(UserProfile.fromMap(snapshot.value[id]??{}));
        }
      });
    }
    return results;
  }
  Future<void> updateProfile(UserProfile profile) async {
    _databaseReference.update({profile.uid: profile.map});
  }
  Future<void> deleteProfile(String uid) async{
    return _databaseReference.update({uid: null});
  }
  Stream<Event> queryByUsernameStream(String search)
  {
    return _databaseReference.orderByChild('userName').equalTo(search).onValue;
  }
}

///Model serving as link between a user's profile data in the database and the app.
class UserProfileReference {

  final DatabaseReference _profileReference;
  StreamController<UserProfile> _profileStreamController = BehaviorSubject();
  StreamController<List<String>> _groupListStreamController = BehaviorSubject();
  String _uid;
  UserProfile _userProfile;

  ///Factory method for constructing this class asynchronously.
  UserProfileReference(String uid):
        _uid = uid,
        _profileReference = FirebaseDatabase.instance.reference().child("users").child(uid)
  {
     _init(uid);
  }

  ///Initializes this object asynchrnously.
  Future<void> _init(String uid) async
  {
    _profileReference.onValue.listen((event) {
      if (event.snapshot.value != null)
        {
          _userProfile = UserProfile.fromMap(event.snapshot.value);
          _profileStreamController.add(_userProfile);
        }
    });

    _profileReference.child('groups').onValue.listen((event) {
      var list = <String>[];
      if(event.snapshot.value != null)
        {
          for(var item in event.snapshot.value.keys.toList()){
            list.add(item.toString());
          }
        }
      _groupListStreamController.add(list);
    });

  }

  ///Updates the current user's profile with new profile data.
  Future<void> updateProfile(UserProfile profile) async {
    _profileReference.update(profile.map);
  }

  ///Update this user's profile with the supplied list.
  Future<void> updateCategories(List<String> categories) async
  {
    await _profileReference.update({"categories":categories});
  }

  ///Updates the user's bio.
  Future<void> updateBio(String bio) async
  {
    return await _profileReference.update({"description":bio});
  }

  ///Deletes the current user's profile.
  Future<void> deleteProfile() async {
    _profileReference.update({_uid: null});
  }

  ///Gets a snapshot of a list of groups ids that the user is in.
  Future<List<String>> getJoinedGroups() async
  {
    List<String> list=[];
    await _profileReference.child('groups').once().then((value){
      for(var item in value.value.keys.toList()){
        list.add(item.toString());
      }
    });
    return list;
  }

  ///Returns a list of event group ids that the user has joined.
  Future<List<String>> getJoinedEventGroups() async
  {
    List<String> list=[];
    DataSnapshot snapshot = await _profileReference.child('groups').once();
    Map map = snapshot.value as Map;
    if(map!=null)
      map.forEach((key, value) {
        if(value == ChatType.EVENT.index)list.add(key);
      });
    return list;
  }


  ///Returns a stream of the current user's profile data that notifies listeners whenever
  ///the data of the user profile is updated in the database.
  Stream<UserProfile> get profileStream => _profileStreamController.stream;
  ///Gets a stream of the list of groups ids that the user is a member of.
  Stream<List<String>> get getJoinedGroupsStream => _groupListStreamController.stream;
  ///Get the current user profile;
  UserProfile get currentUserProfile => _userProfile;

  ///Returns the profile data of the current user
  ///at the time when this function called.
  Future<UserProfile> getUserProfile() async {
    UserProfile profile;
    DataSnapshot snapshot = await _profileReference.once();
    if (snapshot.value != null) profile = UserProfile.fromMap(snapshot.value);
    return profile;
  }
}

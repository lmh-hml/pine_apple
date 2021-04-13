
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_apple/model/profiles_repository.dart';
import 'package:pine_apple/model/user_profile_model.dart';
import 'package:pine_apple/screen/edit_profile_screen.dart';

class UserProfileScreenController
{
  UserProfileReference _userProfileRef;
  UserProfile _profile;
  UserProfileScreenController(UserProfileReference ref)
  {
    _userProfileRef = ref;
    _profile = _userProfileRef.currentUserProfile;
  }

  void doEditProfile()
  {
    Get.to(EditProfileScreen(_userProfileRef));
  }

  Stream<UserProfile> getProfileState()
  {
    return _userProfileRef.profileStream;
  }

  UserProfile get currentUserProfile => _userProfileRef.currentUserProfile;
}
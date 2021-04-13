import 'package:pine_apple/model/profiles_repository.dart';
import 'package:pine_apple/model/user_profile_model.dart';

class EditProfileController {
  ///Reference to a user's profile. Referred to as the 'current user'
  ///in documentation of methods in this class.
  final UserProfileReference reference;
  EditProfileController(this.reference);

  ///Updates the current user's bio with the indicated bio text.
  Future<void> saveBio(String bio) async {
    if (bio.length > 0)
      return await reference.updateBio(bio);
    else
      return;
  }

  ///Gets a snapshot of the current user's profile information
  Future<UserProfile> get profileData async => reference.getUserProfile();
}
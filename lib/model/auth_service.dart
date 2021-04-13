import 'dart:developer';
import 'package:pine_apple/model/user_profile_model.dart';
import 'package:pine_apple/model/backend.dart';

import '../import_firebase.dart';

///Class that handles signing in ,signing out and registering of the app.
class AuthService {
  ///Instance of Firebase Authentication service.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ///Reference to database for creating/deleting new user data.
  final DatabaseReference _users =
      FirebaseDatabase.instance.reference().child("users");
  final ProfilesRepository _profilesRepository = ProfilesRepository();

  ///Sign in using the provided email and password. If successful, return a User object containing the user's information.
  ///If unsuccessful, function returns null.
  Future<User> signIn(
      {@required String email, @required String password}) async {
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      return userCred.user;
  }

  ///Create an account using the provided email and password. If successful, return a User object containing the user's information.
  ///If unsuccessful, function returns null.
  Future<User> register(String email, String password,
      [String username]) async {
    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (userCred != null) {
        UserProfile newProfile = UserProfile(
            username: username ?? "Username",
            description: "Hi! I am using PineApple.",
            uid: userCred.user.uid);
        await _profilesRepository.updateProfile(newProfile);
      }
      return userCred.user;
    } on FirebaseAuthException catch (e) {
      log(e.code);
      throw e;
    }
  }

  ///Deletes the account of the current user.
  Future<void> delete() async {
    try {
      if (_auth.currentUser == null)
        throw Exception(
            "Attempted to delete a user when no user is logged in.");
      String uid = currentUserUid;
      _auth.currentUser.delete().then((value) {
        _users.update({currentUserUid: null});
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'The user must be logged in before this operation can be executed.');
      }
    }
  }

  ///Signs out the current user.
  Future<void> signOut() {
    return _auth.signOut();
  }

  ///Returns the User object associated with the current user.
  ///This returns null if no user is logged in.
  User get currentUser => _auth.currentUser;

  ///Returns the uid of the current user, or "Null" if no user is currently logged in.
  String get currentUserUid => _auth.currentUser?.uid ?? "Null";

  ///Returns a stream that notifies listeners about changes to the user's authentication state,
  ///such as being logged in or logging out.
  Stream<User> get userAuthState => _auth.authStateChanges();

  ///Gets the current user, if they are already logged in.
}

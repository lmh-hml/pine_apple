// import 'dart:async';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_list.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:intl/intl.dart';
// import '../old/model.dart';
// import 'dart:developer';
//
// ///A class that serves as the controller of a chat session.
// ///Handles downloading and uploading of chat messages.
// class ChatSession {
//   // final DatabaseReference _chatsReference = FirebaseDatabase.instance
//   //     .reference()
//   //     .child(
//   //         "chats");
//   DatabaseReference
//       _chatGroupReference; //Reference to a specific chat session in the Firebase database
//   DatabaseReference _messagesRef;
//   FirebaseList
//       _fbl; //Firebase list used to sort downloaded messages according to timestamps
//   List<ChatMessage> _messageList = [];
//
//   StreamController<List<ChatMessage>> _messageStream =
//       StreamController(); //Stream for passing downloaded messages to the rest of the app.
//
//   ChatSession(String groupUid) {
//     setChatGroup(groupUid);
//   }
//
//   ///Sets the current chat state according to the chat uid provided.
//   void setChatGroup(String groupUid) {
//     log("Setting up chat group: " + groupUid);
//     _messageList.clear();
//     _chatGroupReference =  FirebaseDatabase.instance.reference().child("chats").child(groupUid);
//     _messagesRef = _chatGroupReference.child("messages");
//     _fbl = FirebaseList(
//       query: _messagesRef.orderByChild("timestamp"),
//       onChildMoved: (i, j, d) {},
//       onValue: (d) {},
//       onChildAdded: (i, d) {
//         _messageList.add(ChatMessage(
//             d.value["sender"], d.value["text"], d.value["timestamp"],
//             username: d.value["username"]));
//         _messageStream.add(_messageList);
//       },
//     );
//   }
//
//   ///Uploads a new chat message to the database.
//   void addMessage(ChatMessage cm) {
//     _messagesRef.update({cm.timestamp.toString(): cm.map});
//   }
//
//   ///Clean up method
//   void dispose() {
//     _messageStream.close();
//   }
//
//   ///Returns a stream whose snapshot contains a list of chat messages sorted by their timestamps.
//   ///This stream is updated whenever a new message is uploaded.
//   Stream<List<ChatMessage>> get stream => _messageStream.stream;
// }
//
// ///Class that handles creation of a chat group.
// class ChatRepository {
//   final DatabaseReference _chatsReference = FirebaseDatabase.instance
//       .reference()
//       .child(
//           "chats"); //Reference to the section of firebase database that contains all chat sessions
//
//   Future<String> createChatGroup(String groupName, User creator, [String description = "Nothing over here :p"]) async {
//     String memberID = (creator != null) ? creator.uid : "NULL";
//     DatabaseReference groupRef = _chatsReference.push();
//     await groupRef.update({
//       "name": groupName,
//       "admin": [memberID],
//       "members": [memberID],
//       "description":description,
//     });
//     return groupRef.key;
//   }
//
// }
//
// ///Class that handles signing in ,singing out and registering of the app.
// class AuthService {
//   FirebaseAuth _auth = FirebaseAuth.instance;
//   DatabaseReference _users =
//       FirebaseDatabase.instance.reference().child("users");
//
//   ///Sign in using the provided email and password. If successful, return a User object containing the user's information.
//   ///If unsuccessful, function returns null.
//   Future<User> signIn(
//       {@required String email, @required String password}) async {
//     try {
//       UserCredential userCred = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       return userCred.user;
//     } on FirebaseAuthException catch (e) {
//       log("Sign In exception: " + e.code);
//       return null;
//     }
//   }
//
//   ///Create an account using the provided email and password. If successful, return a User object containing the user's information.
//   ///If unsuccessful, function returns null.
//   Future<User> register(
//       {@required String email,
//       @required String password,
//       @required String username}) async {
//     try {
//       UserCredential userCred = await _auth.createUserWithEmailAndPassword(
//           email: email, password: password);
//       FirebaseDatabase.instance.reference().child("users").update({
//         userCred.user.uid: {
//           "uid": userCred.user.uid,
//           "email": userCred.user.email,
//           "username": username,
//           "dateCreated": DateFormat('yMd').format(DateTime.now())
//         }
//       });
//       return userCred.user;
//     } on FirebaseAuthException catch (e) {
//       log("Register Exception: " + e.code);
//       throw e;
//     }
//   }
//
//   void delete() {
//     try {
//       if (_auth.currentUser == null)
//         throw Exception(
//             "Attempted to delete a user when no user is logged in.");
//       String uid = _auth.currentUser.uid;
//       _auth.currentUser.delete().then((value) {
//         _users.update({uid: null});
//       });
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'requires-recent-login') {
//         print(
//             'The user must be logged in before this operation can be executed.');
//       }
//     }
//   }
//
//   ///Signs out the current user.
//   Future<void> signOut() {
//     return _auth.signOut();
//   }
//
//   ///Returns the User object associated with the current user.
//   ///This returns null if signIn() or register() is not called or if signing in and registration
//   ///fails.
//   User get currentUser => _auth.currentUser;
//   String get currentUserUid => _auth.currentUser.uid;
//
//   ///Returns a stream that notifies listeners about changes to the user's authentication state,
//   ///such as being logged in or logging out.
//   Stream get userAuthState => _auth.authStateChanges();
// }
//
// // ///Class that handles user's profile and information,
// // ///such as adding interests and updating profiles.
// // ///This class can be used to view the list of groups by the current user, but
// // ///is not responsible for adding/removing the user to and from groups.
// // class ProfilesRepository {
// //   ///DatabaseReference to the user's profile information. (users/<uid>)
// //   DatabaseReference _usersReference;
// //
// //   ProfilesRepository() {
// //     _usersReference = FirebaseDatabase.instance.reference().child("users");
// //   }
// //
// //   Future<UserProfile> getUserProfile(String uid) async {
// //     DatabaseReference ref = _usersReference.child(uid);
// //     DataSnapshot snapshot = await ref.once();
// //     UserProfile userProfile = UserProfile.fromMap(snapshot.value);
// //     return userProfile;
// //   }
// //
// //   void updateProfile(UserProfile profile) {
// //     _usersReference.update({profile.uid: profile.map});
// //   }
// //
// //   Stream get profileStream => _usersReference.onValue;
// // }
// //
// // ///Controller than manages the profile data of a user.
// // class UserProfileReference {
// //   DatabaseReference _profileReference;
// //   StreamController<UserProfile> _profileStream = StreamController();
// //   String _uid;
// //   UserProfile _userProfile;
// //
// //   ///Constructs an instance of this class that will handle profile data for
// //   ///a the user with the specified uid.
// //   UserProfileReference(String uid) {
// //     _uid = uid;
// //     _profileReference =
// //         FirebaseDatabase.instance.reference().child("users").child(uid);
// //     _profileReference.onValue.listen((event) {
// //       if (event.snapshot.value != null)
// //         _userProfile = UserProfile.fromMap(event.snapshot.value);
// //       _profileStream.add(_userProfile);
// //     });
// //   }
// //
// //   ///Updates the current user's profile with new profile data.
// //   Future<void> updateProfile(UserProfile profile) async {
// //     _profileReference.update({_uid: profile.map});
// //   }
// //
// //   ///Deletes the current user's profile.
// //   Future<void> deleteProfile(UserProfile profile) async {
// //     _profileReference.update({_uid: null});
// //   }
// //
// //   ///Returns a stream of the current user's profile data that notifies listeners whenever
// //   ///the data of the user profile is updated in the database.
// //   Stream<UserProfile> get profileStream => _profileStream.stream;
// //   UserProfile get currentUserProfile => _userProfile;
// //
// //   ///Returns the profile data of the current user
// //   ///at the time when this function called.
// //   Future<UserProfile> snapshot() async {
// //     UserProfile profile;
// //     DataSnapshot snapshot = await _profileReference.once();
// //     if (snapshot.value != null) profile = UserProfile.fromMap(snapshot.value);
// //     return profile;
// //   }
// // }
//
// ///Class that handles the business logic for the Register screen,
// ///TODO(COnvert this to a controller for registration page)
// class RegisterService {
//   static const String NONE = "";
//   final String pwdInvalidText =
//       "Password must be more than 8 characters and contains alphabets, numbers and special characters.";
//   final String userNameInvalidText =
//       "Username must contain at least one alphabet";
//   String emailInvalidText = NONE;
//   AuthService _account;
//   String lastErrorCode = "";
//
//   RegisterService(AuthService accountController) {
//     _account = accountController;
//   }
//
//   ///Tries to create a user using the email, username and password given
//   ///If successful, returns a future with a non-null user
//   ///If unsuccessful, returns null.
//   Future<User> register(String email, String username, String password) async {
//     try {
//       User user = await _account.register(
//           email: email, password: password, username: username);
//       return user;
//     } on FirebaseAuthException catch (e) {
//       switch (e.code) {
//         case 'email-already-in-use':
//           emailInvalidText = "Email is already in use";
//           break;
//         case 'invalid-email':
//           emailInvalidText = "Email is not valid";
//           break;
//       }
//       lastErrorCode = e.code;
//       return null;
//     }
//   }
//
//   ///A strong password must at least 8 characters with
//   ///a lower case alphabet, upper case alphabet, digit and special character.
//   bool isPasswordStrong(String input) {
//     return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]){8,}')
//         .hasMatch(input);
//   }
//
//   ///A Username must be more than 5 characters and have at least one alphabet.
//   bool isUsernameValid(String input) {
//     return RegExp(r'^(?!\s)(?!.*\s)(?=.*[a-zA-Z]).{5,}(?!\s)$').hasMatch(input);
//   }
// }

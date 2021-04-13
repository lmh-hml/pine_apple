import 'package:pine_apple/controller/pineapple_context.dart';
import 'package:pine_apple/model/chat_message_model.dart';
import 'package:pine_apple/model/chat_repository.dart';
import 'package:pine_apple/model/profiles_repository.dart';
import 'package:pine_apple/model/user_profile_model.dart';
import 'package:rxdart/rxdart.dart';
import '../import_firebase.dart';

class SearchNewChatScreenController
{
  ProfilesRepository _profilesRepository = ProfilesRepository();
  ChatRepository _chatRepository = ChatRepository();
  TextEditingController searchBarController = TextEditingController();
  StreamController<List<UserProfile>> _resultsStream = BehaviorSubject();
  SearchNewChatScreenController();

  ///Perform a username query using the search text provided.
  void doQuery(String searchText) async
  {
    _profilesRepository.queryByUsernameStream(searchText).listen((event) {
      var list = <UserProfile>[];
      if(!(event.snapshot.value == null))
      {
        for ( Map value in event.snapshot.value.values.toList() )
        {
          list.add(UserProfile.fromMap(value));
        }
      }
      _resultsStream.add(list);
    });
    return;
  }

  ///Attempts to create a one-to-one chat between two users.
  ///If a one-to-one chat already exists between the two users, the preexisitng chat's group info is returned.
  ///Otherwise, a new group is created in the database, and the new group's info is returned.
  Future<GroupChatInfo> createOneToOneChat(String groupName, String user1, String user2) async
  {
    GroupChatInfo groupChatInfo = await PineAppleContext.chatRepository.getOneToOneChatInfo(user1, user2);
    if(groupChatInfo == null) groupChatInfo = await PineAppleContext.chatRepository.createOneToOneChat( groupName , user1, user2);
    return groupChatInfo;

  }

  ///Stream the UI subscribes to receive results from the search.
  Stream<List<UserProfile>> get searchResultsStream => _resultsStream.stream;

}
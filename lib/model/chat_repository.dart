import '../import_firebase.dart';
import 'backend.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pine_apple/model/ChatMessage.dart';

const String _CHATS = "chats";
const String _GROUPS = "groups";
const String _USER_GROUPS = "user_groups";
const String _GROUP_MEMBERS = "members";
const String _ONE_TO_ONE_GROUPS = "one_to_one_groups";

///Repository for chat related data.
class ChatRepository {

  ///Reference to the section of firebase database that contains all chat lists
  final DatabaseReference _chatsReference = FirebaseDatabase.instance.reference().child(_CHATS);
  ///Reference to the section of firebase database that contains all chat groups
  final DatabaseReference _groupsReference = FirebaseDatabase.instance.reference().child(_GROUPS);
  final DatabaseReference _oneToOneReference = FirebaseDatabase.instance.reference().child(_ONE_TO_ONE_GROUPS);
  final DatabaseReference _userGroupsReference = FirebaseDatabase.instance.reference().child(_USER_GROUPS);
  final DatabaseReference  _usersReference = FirebaseDatabase.instance.reference().child("users");

  ///Creates a chat with only two members and returns the group chat information of the created chat group.
  Future<GroupChatInfo> createOneToOneChat(String groupName, String firstMember, String secondMember) async
  {
    GroupChatInfo gc = await createChatGroup(groupName, [firstMember,secondMember], GroupChatInfo.CHAT_TYPE_ONE_TO_ONE);
    await _oneToOneReference.child(firstMember).update({secondMember:gc.groupChatUid});
    await _oneToOneReference.child(secondMember).update({firstMember:gc.groupChatUid});
    return gc;
  }

  ///Gets the group id of the one to one chat populated by the two members provided
  Future<GroupChatInfo> getOneToOneChatInfo(String user1, String user2) async
  {
    GroupChatInfo groupChatInfo;
    DataSnapshot snapshot = await _oneToOneReference.child(user1).child(user2).once();
    print(snapshot.value);
      if( snapshot.value != null )
        {
          groupChatInfo = await getChatGroupInfo(snapshot.value);
          print(groupChatInfo.toMap().toString());
          return groupChatInfo;
        }
    return groupChatInfo;
  }

  ///Creates a general group chat with populated by its admins, and returns the group chat information of the created chat group.
  Future<GroupChatInfo> createChatGroup(String groupName,  [List<String> members, String type]) async
  {
    String uid = await _groupsReference.push().key;
    GroupChatInfo gc = GroupChatInfo(uid, groupName, membersId:  members??[], adminsUid: [], type: type);
    await _groupsReference.update({uid:gc.toMap()});
    for(String id in members)
      {
        await addMemberToGroup(id, uid);
      }
    return gc;
  }

  ///Gets the group chat information of the group with the group id.
  Future<GroupChatInfo> getChatGroupInfo(String uid) async
  {
    GroupChatInfo groupChatInfo;
    await _groupsReference.child(uid).once().then((DataSnapshot snapshot){
      groupChatInfo = GroupChatInfo.fromMap(snapshot.value??{});
      return groupChatInfo;
    });
    return groupChatInfo;
  }

  ///Retrieves a list of GroupChatInfo whose uid is listed inside uids.
  ///If a id listed in uids but does not exist in the database, it will be returned as an empty GroupChatInfo.
  Future<List<GroupChatInfo>> getMultipleChatGroupInfo(List<String> uids) async
  {
    List<GroupChatInfo> results = [];
    for(String id in uids)
      {
        await _groupsReference.orderByKey().equalTo(id).once().then((DataSnapshot snapshot){
          if(snapshot.value!=null)
            {
              results.add(GroupChatInfo.fromMap(snapshot.value[id]));
            }
        });
      }
    return results;
  }

  ///Adds a user to a group using their uids.
  Future<void> addMemberToGroup(String userUid ,String groupId)async
  {
      await _groupsReference.child(groupId).child(_GROUP_MEMBERS).update({userUid:1});
      await _usersReference.child(userUid).child(_GROUPS).update({groupId:1});
  }

  ///Removes a member from a group using their uids.
  Future<void> removeMemberFromGroup(String userUid, String groupId) async
  {
    await _groupsReference.child(groupId).child(_GROUP_MEMBERS).child(userUid).update(null);
    await _usersReference.child(userUid).child(_GROUPS).child(groupId).update(null);
  }

  ///Gets a list of members of the group.
  Future<Map> getMembers(String groupId) async
  {
    Map result;
    await _groupsReference.child(groupId).child(_GROUP_MEMBERS).once().then((value){
      result = value.value;
    });
    return result;
  }

  ///Gets the chat session with the specified uid.
  ChatMessagesReference getChat(String uid)
  {
    return ChatMessagesReference(uid);
  }

}

///Model serving as a link between the storage for messages of a group chat and the app.
///This model is ONLY responsible for downloading and uploading chat messages. It does not handle
///the chat group's data.
class ChatMessagesReference{

  ///Reference to a specific chat session in the Firebase database
  DatabaseReference _chatGroupReference; ///Reference to a specific chat session in the Firebase database
  ///Reference to the list of messages of this group chat.
  DatabaseReference _messagesRef;
  ///Firebase list used to sort downloaded messages according to timestamps
  FirebaseList _fbl;
  ///Stores the downloaded messages from the cloud.
  List<ChatMessage> _messageList = [];

  ///Stream that fires whenever new messages are downloaded into the app for this group chat
  StreamController<List<ChatMessage>> _messageStream =
  BehaviorSubject();

  ChatMessagesReference(String groupUid) {
    _init(groupUid);
  }

  ///Initialises the group chat.
  void _init(String groupUid) {
    _messageList.clear();
    _chatGroupReference =  FirebaseDatabase.instance.reference().child(_GROUPS).child(groupUid);
    _messagesRef = FirebaseDatabase.instance.reference().child(_CHATS).child(groupUid);

    _fbl = FirebaseList(
      query: _messagesRef.orderByChild("timestamp"),
      onChildMoved: (i, j, d) {},
      onValue: (d) {},
      onChildAdded: (i, d) {
        _messageList.add(ChatMessage.fromMap(d.value));
        _messageStream.add(_messageList);
      },
    );
  }

  ///Uploads a new chat message to the database.
  void addMessage(ChatMessage cm) async {
    await _messagesRef.update({cm.timestamp.toString(): cm.map});
    await _chatGroupReference.update({"latest":cm.map});
  }

  ///Clean up method
  void dispose() {
    _messageStream.close();

  }

  ///Returns a stream whose snapshot contains a list of chat messages sorted by their timestamps.
  ///This stream is updated whenever a new message is uploaded.
  Stream<List<ChatMessage>> get stream => _messageStream.stream;
}

///Model serving as a database reference for a chat group to access chat group data from.
class ChatGroupReference
{
  ChatRepository _repository = ChatRepository();
  DatabaseReference _groupReference;
  final DatabaseReference _userGroupsReference = FirebaseDatabase.instance.reference().child(_USER_GROUPS);
  final String uid;

  ChatGroupReference(this.uid)
  {
    _groupReference = FirebaseDatabase.instance.reference().child(_GROUPS).child(uid);
  }

  Future<GroupChatInfo> getGroupInfo() async
  {
    return await _repository.getChatGroupInfo(uid);
  }

  ///Adds a user into a group using their uids.
  Future<void> addMember(String userUid ,[bool admin])async
  {
    _repository.addMemberToGroup(userUid, uid);
  }

  ///Removes a member from a group using their uids.
  Future<void> removeMember(String userUid) async
  {
    _repository.removeMemberFromGroup(userUid, uid);
  }

  ///Gets a list of members of the group.
  Future<Map> getMembers() async
  {
    return await _repository.getMembers(uid);
  }


}
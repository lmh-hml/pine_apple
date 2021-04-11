import 'package:flutter/material.dart';
import 'package:pine_apple/controller/pineapple_context.dart';
import 'package:pine_apple/import_firebase.dart';
import 'package:pine_apple/model/ChatMessage.dart';
import 'package:pine_apple/model/UserProfile.dart';
import 'package:pine_apple/model/backend.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pine_apple/screen/screen.dart';

class NewChatSearchScreen extends StatefulWidget{


  @override
  _NewChatSearchScreenState createState() => _NewChatSearchScreenState();
}

class _NewChatSearchScreenState extends State<NewChatSearchScreen> {
  @override

  final SearchNewChatScreenController controller = SearchNewChatScreenController();


  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.black,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Find new users to chat",style: TextStyle( fontSize: 18 ,fontWeight: FontWeight.w600, color: Colors.black54),),
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Stack(
              children: <Widget>[
                Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: (){
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile()));
                      },
                      icon: Icon(Icons.check),
                    )
                ),

              ],
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildSearchBar(),

          StreamBuilder(
              stream: controller.searchResultsStream,
              builder: (context, snapshot){
                if(!snapshot.hasData)
                  return Center(child:Text("Enter a username to search"));
                List<UserProfile> list = snapshot.data;
                if(list.isEmpty)return Center(child: Text("Unable to find user with username"),);
                print("ChatSearchScreen:${list.length}");
                return ListView.builder(
                  shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (context, index){
                      UserProfile up = list[index];
                      if(up.uid == PineAppleContext.currentUid) return null;
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar( child:Icon(Icons.person), backgroundColor: Colors.red, radius: 20,),
                          title: Text(up.username),
                          onTap: () async{
                            String groupName = '${PineAppleContext.currentUserprofile.username} and ${up.username}';
                            GroupChatInfo groupChatInfo = await controller.createOneToOneChat( groupName, PineAppleContext.currentUid, up.uid);
                            Get.toNamed(Routes.CHAT_SCREEN, arguments:{Routes.ARG_GROUP_CHAT_INFO:groupChatInfo});
                          },
                        ),
                      );
                    });
              }
          )

        ],
      ),
    );
  }

  Widget buildSearchBar()
  {
    return Padding(
      padding: EdgeInsets.only(top: 16,left: 16,right: 16),
      child: TextField(
        textInputAction: TextInputAction.search,
        controller: controller.searchBarController,
        onSubmitted: (text) => controller.doQuery(text),
        decoration: InputDecoration(
          hintText: "Search...",
          hintStyle: TextStyle(color: Colors.grey.shade600),
          prefixIcon: Icon(Icons.search,color: Colors.grey.shade600, size: 20,),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: EdgeInsets.all(8),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                  color: Colors.grey.shade100
              )
          ),
        ),
      ),
    );
  }
}


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

  Future<GroupChatInfo> createChat(List<String> members) async
  {
    return await _chatRepository.createChatGroup("Chat", members);
  }

  Stream<List<UserProfile>> get searchResultsStream => _resultsStream.stream;

}
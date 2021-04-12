import 'package:flutter/material.dart';
import 'package:pine_apple/controller/pineapple_context.dart';
import 'screen.dart';
import 'conversation_list_screen.dart';
import 'package:pine_apple/model/UserProfile.dart';
import 'package:pine_apple/model/profiles_repository.dart';
import 'package:get/get.dart';



class MainScreen extends StatefulWidget {
  final List<Widget> pages;
  MainScreen(this.pages);
  @override
  _MainScreenState createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen> {
  int pageIndex = 0;
  List<Widget> pages;
  @override
  void initState() {
    pages = widget.pages;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(),
      body: getBody(),
      bottomNavigationBar: getFooter(),
    );
  }

  //Appbar
  // ignore: missing_return
  Widget getAppBar(){
    if (pageIndex == 0){
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: false, // Don't show the leading button
        title: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: "Pine",
                style: TextStyle(
                  color: Color.fromARGB(255,255,192,0),
                  fontFamily: 'One',
                  fontSize: 40.0,
                ),
              ),
              TextSpan(
                text: "Apple",
                style: TextStyle(
                  color: Color.fromARGB(255,192,80,70),
                  fontFamily: 'One',
                  fontSize: 40.0,
                ),
              ),
            ],
          ),
        ),

        actions: <Widget> [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20.0, 10.0, 0),
            child: TextButton(
              onPressed: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewAllEvents() ))
              },
              child: Text(
                'View All Events',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
        ],
      );
    }

    else if (pageIndex == 1){
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: false, // Don't show the leading button
        title: Padding(
          padding: const EdgeInsets.only(left: 155),
          child: Text(
              'CHATS',
              style: TextStyle(
                color: Color.fromARGB(255,192,80,70),
                fontFamily: 'One',
                fontSize: 35.0,
                letterSpacing: 1.0,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.black,
            iconSize: 40.0,
            onPressed: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NewChatSearchScreen() ))
              //showSearch(context: context, delegate: NewChatSearchScreen()),
            },
          ),
        ],
      );
    }

    else if (pageIndex == 3) {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: false, // Don't show the leading button
        title: Center(
          child: Text(
              'SETTINGS',
              style: TextStyle(
                color: Color.fromARGB(255,192,80,70),
                fontFamily: 'One',
                fontSize: 35.0,
                letterSpacing: 1.0,
            ),
          ),
        ),
      );
    }
  }

  //Body
  Widget getBody(){
    return IndexedStack(
      index: pageIndex,
      children: pages,
    );
  }

  Widget getFooter(){
    List bottomItems = [
      pageIndex == 0 ? "assets/events_logo_pressed.png":"assets/events_logo.png",
      pageIndex == 1 ? "assets/chats_logo_pressed.png":"assets/chats_logo.png",
      pageIndex == 2 ? "assets/profile_logo_pressed.png":"assets/profile_logo.png",
      pageIndex == 3 ? "assets/setting_logo_pressed.png":"assets/setting_logo.png",
    ];
    return Container(
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(width: 1.0, color: Colors.grey),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0, top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(bottomItems.length, (index) {
            return InkWell(
              onTap: (){
                selectedTab(index);
              },
                child: Image.asset(bottomItems[index],
                  width: 40.0,)
            );
          },
          ),
        ),
      ),
    );
  }

  void selectedTab(index){
    setState(() {

      pageIndex = index;
    });
  }
}

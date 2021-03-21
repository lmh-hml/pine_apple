import 'package:flutter/material.dart';
import 'events_page.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}
class _RootState extends State<Root> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(),
      body: getBody(),
      bottomNavigationBar: getFooter(),
    );
  }
  Widget getBody(){
    List<Widget> pages = [
      EventsPage(),
      Center(
        child: Text(
          "Events page",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      Center(
        child: Text(
          "Explore page",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      Center(
        child: Text(
          "Groups page",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      Center(
        child: Text(
          "Chats page",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    ];
    return IndexedStack(
      index: pageIndex,
      children: pages,
    );
  }

  // ignore: missing_return
  Widget getAppBar(){
    if (pageIndex == 0){
      return AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          automaticallyImplyLeading: false, // Don't show the leading button
          title: Row(
            children: <Widget>[
              RichText(
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
            ],
          ),

        actions: <Widget>[
          Padding(padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
            child: IconButton(
              icon: Icon(Icons.search),
              color: Colors.black,
              iconSize: 40.0,
              onPressed: (){},
            ),
          ),
          Padding(padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
            child: IconButton(
              icon: Icon(Icons.account_box),
              color: Colors.black,
              iconSize: 40.0,
              onPressed: (){},
            ),
          ),
          Padding(padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
            child: IconButton(
              icon: Icon(Icons.settings_outlined),
              color: Colors.black,
              iconSize: 40.0,
              onPressed: (){},
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
        title: Row(
          children: <Widget>[
            RichText(
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
          ],
        ),
        actions: <Widget>[
          Padding(padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
            child: IconButton(
              icon: Icon(Icons.search),
              color: Colors.black,
              iconSize: 40.0,
              onPressed: (){},
            ),
          ),
          Padding(padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
            child: IconButton(
              icon: Icon(Icons.account_box),
              color: Colors.black,
              iconSize: 40.0,
              onPressed: (){},
            ),
          ),
          Padding(padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
            child: IconButton(
              icon: Icon(Icons.settings_outlined),
              color: Colors.black,
              iconSize: 40.0,
              onPressed: (){},
            ),
          ),
        ],
      );
    }

    else if (pageIndex == 2){
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: false, // Don't show the leading button
        title: Row(
          children: <Widget>[
            RichText(
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
          ],
        ),
        actions: <Widget>[
          Padding(padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
            child: IconButton(
              icon: Icon(Icons.search),
              color: Colors.black,
              iconSize: 40.0,
              onPressed: (){},
            ),
          ),
          Padding(padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
            child: IconButton(
              icon: Icon(Icons.account_box),
              color: Colors.black,
              iconSize: 40.0,
              onPressed: (){},
            ),
          ),
          Padding(padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
            child: IconButton(
              icon: Icon(Icons.settings_outlined),
              color: Colors.black,
              iconSize: 40.0,
              onPressed: (){},
            ),
          ),
        ],
      );
    }
  }

  Widget getFooter(){
    List bottomItems = [
      pageIndex == 0 ? "assets/events_logo.png":"assets/events_logo.png",
      pageIndex == 1 ? "assets/explore_logo.png":"assets/explore_logo.png",
      pageIndex == 2 ? "assets/group_logo.png":"assets/group_logo.png",
      pageIndex == 3 ? "assets/chats_logo.png":"assets/chats_logo.png",
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
          }
          ),
        ),
      ),
    );
  }

  selectedTab(index){
    setState(() {
      pageIndex = index;
    });

  }


}

import 'package:flutter/material.dart';
import 'package:pine_apple/model/profiles_repository.dart';
import 'package:pine_apple/import_firebase.dart';
import 'package:pine_apple/model/user_profile_model.dart';
import 'screen.dart';
import 'edit_profile_screen.dart';

final UserProfileTextTheme = TextTheme(
  headline1: TextStyle(
      color: Colors.redAccent, fontStyle: FontStyle.normal, fontSize: 28.0),
  bodyText1: TextStyle(
    fontSize: 22.0,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w300,
    color: Colors.black,
    letterSpacing: 2.0,
  ),
);

class UserProfileScreen extends StatelessWidget
{
  final UserProfileReference profileReference;
  final _forCurrentUser;
  UserProfileScreen(this.profileReference, {bool forCurrentUser = true}):
        _forCurrentUser = forCurrentUser ?? true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
            child: Text(
              'Profile',
              style: TextStyle(
                color: Color.fromARGB(255,192,80,70),
                fontFamily: 'One',
                fontSize: 35.0,
                letterSpacing: 1.0,
              ),
            ),
          ),
        leading: Navigator.canPop(context) ? BackButton(onPressed: ()=>Navigator.pop(context),):null,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
        body: SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: <Widget>[
          Container(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
              child: StreamBuilder<UserProfile>(
                  stream: profileReference.profileStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildProfileIconAndName(
                            context, snapshot.data.username, Colors.redAccent),
                        Divider(
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Bio:",
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontStyle: FontStyle.normal,
                              fontSize: 28.0),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          snapshot.data.description ?? "null",
                          style: UserProfileTextTheme.bodyText1,
                        ),
                        SizedBox( height: 30.0,),
                        _buildCategoryChips(context, snapshot.data.categories),
                      ],
                    );
                  }),
            ),
          ),
          SizedBox(
            height: 100.0,
          ),
          _forCurrentUser ?
          _buildEditProfileButton(context):Container(),
        ],
      ),
    ));
  }

  Widget _buildProfileIconAndName(
      BuildContext context, String username, Color iconBackground) {
    return Row(
      children: [
        CircleAvatar(
          child: Icon(
            Icons.person,
            color: Colors.white,
            size: 50,
          ),
          backgroundColor: iconBackground,
          radius: 35,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            username,
            style: TextStyle(
              fontSize: 26.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: 2.0,
            ),
            softWrap: true,
          ),
        )
      ],
    );
  }

  Widget _buildEditProfileButton(BuildContext context) {
    return Container(
      width: 300,
      child: RaisedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EditProfileScreen(profileReference)));
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
          elevation: 0.0,
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [Colors.redAccent, Colors.pinkAccent]),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Container(
              constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
              alignment: Alignment.center,
              child: Text(
                "Edit Profile",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26.0,
                    fontWeight: FontWeight.w300),
              ),
            ),
          )),
    );
  }

  Widget _buildCategoryChips(BuildContext context, List<dynamic> categories) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      Text(
        "Categories:",
        style: UserProfileTextTheme.headline1,
      ),
      SizedBox(
        height: 6.0,
      ),
      Container(
        child: Wrap(
          spacing: 5.0,
          runSpacing: 3.0,
          children: <Widget>[
            for (var item in categories)
              Chip(
                label: Text(item.toString()),
              )
          ],
        ),
      ),
    ]);
  }
}

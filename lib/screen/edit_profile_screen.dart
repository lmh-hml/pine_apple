import 'package:flutter/material.dart';
import 'package:pine_apple/controller/pineapple_context.dart';
import 'package:pine_apple/model/UserProfile.dart';
import 'package:pine_apple/model/backend.dart';
import 'screen.dart';

///Screen that allows users to edit their profile information.
///(Bio only for now.)
class EditProfileScreen extends StatefulWidget {
  final EditProfileController _editProfileController;
  final EditCategorySelectionController _categorySelectionController;
  final bool _newUser;
  EditProfileScreen(UserProfileReference profileReference,{bool newUser})
      : _editProfileController = EditProfileController(profileReference),
        _categorySelectionController =
            EditCategorySelectionController(profileReference),
        _newUser = newUser ?? false;

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _bioTextController;
  final _bioTextKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {


    return FutureBuilder<UserProfile>(
      future: PineAppleContext.currentUser.getUserProfile(),
      builder: (context, snapshot){
        if(!snapshot.hasData)return Center(child:Text("Loading profile..."));

        _bioTextController = TextEditingController(text:snapshot.data.description);
        for(String category in snapshot.data.categories)
          {
            widget._categorySelectionController.addSelection(category);
          }

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: BackButton(
              color: Colors.black,
            ),
            title: Text(
              'Edit Your Bio:',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.done),
                color: Colors.black,
                iconSize: 40.0,
                onPressed: onSave,
              ),
            ],
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30.0, horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Bio:",
                          style: TextStyle(
                              color: Colors.black54,
                              fontStyle: FontStyle.normal,
                              fontSize: 22.0),
                        ),
                        Form(
                          key: _bioTextKey,
                          child: TextFormField(
                            controller: _bioTextController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter your Biography'),
                            autovalidateMode: AutovalidateMode.always,
                            validator: (text) {
                              if (text.length > 0)
                                return null;
                              else
                                return "Bio cannot be empty";
                            },
                          ),
                        ),
                        SizedBox(height: 30,),
                        Divider(thickness: 1,color: Colors.black,),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Choose your interests:",
                            style: TextStyle(
                                color: Colors.black54,
                                fontStyle: FontStyle.normal,
                                fontSize: 22.0),
                          ),
                        ),
                        ChipSelectionWidget(widget._categorySelectionController, ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }

  void onSave() async {
    bool bioValid = (_bioTextKey.currentState.validate());
    if (bioValid) {
      await widget._editProfileController.saveBio(_bioTextController.text);
      await widget._categorySelectionController.saveSelection();
    }
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(bioValid ? "Saved New Bio!" : "Invalid Bio!"),
        actions: <Widget>[
          TextButton(
            child: Text("Ok"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        elevation: 24.0,
      ),
      barrierDismissible: false,
    );
    if (bioValid)
      print(widget._newUser);
      if(!widget._newUser)Navigator.pop(context);
      else Navigator.pushReplacementNamed(context, Routes.MAIN_SCREEN);
  }
}

class EditProfileController {
  final UserProfileReference reference;
  EditProfileController(this.reference);

  Future<void> saveBio(String bio) async {
    if (bio.length > 0)
      return await reference.updateBio(bio);
    else
      return;
  }

  Future<UserProfile> get profileData async => reference.getUserProfile();
}

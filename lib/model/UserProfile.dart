///A class that holds user information not related to authentication
///such as interests, groups joined and profile descriptions.
class UserProfile {
  List<String> joinedGroups;
  List<dynamic> categories;
  String description;
  String username;
  String photoURL;
  String uid;

  UserProfile(
      {
        this.joinedGroups,
        this.description,
        this.username,
        this.photoURL,
        this.uid}
  );

  UserProfile.fromMap(Map map)
  {
    description = map["description"]??"Null";
    username = map["userName"]??"Null";
    uid = map["uid"]??"Null";
    photoURL = map["photoURL"]??"Null";
    categories = map["categories"] ?? [];
  }

  Map<String, dynamic> get map {
    return {
      "description": description??"Null",
      "userName": username??"Null",
      "uid": uid??"Null",
      "photoURL":photoURL??"Null",
      "categories": categories,
    };
  }
}

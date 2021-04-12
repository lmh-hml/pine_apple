import 'package:get/get.dart';
import 'package:pine_apple/import_firebase.dart';
import 'package:pine_apple/model/UserProfile.dart';
import 'package:pine_apple/model/backend.dart';

final _PineAppleContextImpl PineAppleContext = _PineAppleContextImpl();

class _PineAppleContextImpl
{
  static _PineAppleContextImpl _pineAppleContext = _PineAppleContextImpl._();
  factory _PineAppleContextImpl() => _pineAppleContext;

  String _uid;
  UserProfile _profile;

  bool _init = false;

  _PineAppleContextImpl._();

  Future<bool> initialize() async
  {
    _init = await _pineAppleContext._initialize();
    return true;
  }

  Future<bool> _initialize() async
  {
    _authService.userAuthState.listen(_listenToAuth);
    return true;
  }

  void _listenToAuth(User user) async{
    if(user != null )
    {
      _uid = user.uid;
      _profile = await _profilesRepository.getUserProfile(_uid);
      print("From context: Init with uid $_uid");
    }
    else
    {
      _uid=null;
      print("From context: logout with uid $_uid");
    }
  }

  String get currentUid => _uid;

  ChatRepository _chatRepository = Get.put(ChatRepository());
  ChatRepository get chatRepository => Get.find();

  ProfilesRepository _profilesRepository = Get.put(ProfilesRepository());
  ProfilesRepository get profilesRepository => Get.find();

  AuthService _authService = Get.put(AuthService());
  AuthService get auth => Get.find();

  UserProfileReference get currentUser{
    print("PINEAPPLE CONTEXT ID: $_uid");
    return _uid!=null ? UserProfileReference(_uid) : null;
  }
  UserProfile get currentUserprofile => _profile;
}



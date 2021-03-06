export 'event_detail_screen.dart';
export 'widgets/chip_selection_widget.dart';
export 'edit_profile_screen.dart';
export 'events_screen.dart';
export 'login_screen.dart';
export 'register_screen.dart';
export 'main_screen.dart';
export 'search_event_screen.dart';
export 'settings_screen.dart';
export 'user_profile_screen.dart';
export 'view_all_events_screen.dart';
export 'chat_screen.dart';
export 'new_chat_search_screen.dart';
export 'conversation_list_screen.dart';
export 'widgets/conversation_list_item.dart';
export 'conversation_list_screen.dart';
import 'package:get/get.dart';
import 'package:pine_apple/controller/chat_screen_controller.dart';
import 'package:pine_apple/controller/conversation_list_screen_controller.dart';
import 'package:pine_apple/controller/event_detail_screen_controller.dart';
import 'package:pine_apple/controller/group_detail_screen_controller.dart';
import 'package:pine_apple/controller/settings_screen_controller.dart';
import 'package:pine_apple/model/chat_message_model.dart';
import 'package:pine_apple/model/backend.dart';
import 'package:pine_apple/screen/edit_profile_screen.dart';
import 'package:pine_apple/screen/event_detail_screen.dart';
import 'package:pine_apple/screen/login_screen.dart';
import 'package:pine_apple/screen/main_screen.dart';
import 'package:pine_apple/screen/register_screen.dart';
import 'package:pine_apple/screen/settings_screen.dart';
import 'package:pine_apple/screen/start_up_screen.dart';
import 'package:pine_apple/screen/user_profile_screen.dart';
import 'package:pine_apple/screen/group_detail_screen.dart';
import '../import_firebase.dart';
import 'package:pine_apple/controller/pineapple_context.dart';
import 'chat_screen.dart';
import 'conversation_list_screen.dart';
import 'events_screen.dart';

export 'package:get/get.dart';



class Routes {
  Routes._();
  static const String START_UP = '/';
  static const String LOGIN = "/login";
  static const String REGISTER = "/register";
  static const String NEW_USER_EDIT_PROFILE = '/new_user_edit_profile';
  static const String MAIN_SCREEN = "/main_screen";
  static const String CONVERSATION_LIST = "/conversation_list_screen";
  static const String CHAT_GROUP_DETAILS = "/chat_detail_screen";
  static const String CHAT_SCREEN = "/chat_screen";
  static const String USER_PROFILE_SCREEN = "/profile_screen";
  static const String EDIT_PROFILE = "/edit_profile_screen";
  static const String EDIT_CATEGORY = "/edit_category_selection_screen";
  static const String SETTINGS_SCREEN = "/settings";
  static const String VIEW_GROUP_DETAILS = "/view_group_detail";
  static const String GROUP_DETAIL_SCREEN = "/group_detail_screen";
  static const String OTHER_PROFILE_SCREEN = "/other_user_profile_screen";
  static const String EVENT_DETAIL_SCREEN = '/event_detail_screen';
  static const String EVENT_DETAIL_SCREEN_WITH_JOIN = '/event_detail_screen_join';

  static const String ARG_USER_PROFILE = "UserProfile";
  static const String ARG_GROUP_CHAT_INFO = "GroupChatInfo";
  static const String ARG_PROFILE_REF = "UserProfileReference";
  static const String ARG_FOR_CURRENT_USER = "forCurrentUser";
  static const String ARG_USER_ID = "userId";
  static const String ARG_IS_NEW_USER = "is_new_user?" ;
  static const String ARG_EVENT_MODEL = 'event_model';

  static EventDetailScreenController eventDetailScreenController = EventDetailScreenController();


  static Route generateRoutes(RouteSettings routeSettings) {

    Map args = routeSettings.arguments as Map;


    switch (routeSettings.name) {

      case START_UP:
        {
          return GetPageRoute(page:()=>StartUpScreen());
        }

      case LOGIN:
        return GetPageRoute( page: () => LoginScreen(),);

      case REGISTER:
        return GetPageRoute(page: () => RegisterScreen());

      case NEW_USER_EDIT_PROFILE:
        {
          UserProfileReference profileReference  = PineAppleContext.currentUser;
          assert(profileReference!=null);
          return GetPageRoute(page:()=>EditProfileScreen(profileReference, newUser:true));
        }

      case MAIN_SCREEN:
      case START_UP:
        return GetPageRoute(page:()=>MainScreen());

      case USER_PROFILE_SCREEN:
        {
          UserProfileReference profileReference  = PineAppleContext.currentUser;
          assert(profileReference!=null);
          return GetPageRoute(page:()=>UserProfileScreen(profileReference));
        }

      case OTHER_PROFILE_SCREEN:
        {
          assert(args[ARG_USER_ID]!=null);
          UserProfileReference profileReference = PineAppleContext.profilesRepository.getProfileReference(args[ARG_USER_ID]);
          return GetPageRoute(page:()=> UserProfileScreen(profileReference,forCurrentUser: false,));
        }

      case EDIT_PROFILE:
        {
          UserProfileReference profileReference  = PineAppleContext.currentUser;
          assert(profileReference!=null);
          return GetPageRoute(page:()=>EditProfileScreen(profileReference, newUser:args[ARG_IS_NEW_USER]??false ));
        }

      case CONVERSATION_LIST:
        {
          UserProfileReference profileReference  = PineAppleContext.currentUser;
          assert(profileReference!=null);
          return GetPageRoute(page:()=>ConversationListScreen(ConversationListController(profileReference)));
        }

      case CHAT_SCREEN:
        {
          return GetPageRoute(page:()=>ChatScreen(ChatController(
            groupChatInfo:args[ARG_GROUP_CHAT_INFO],
            userProfile: PineAppleContext.currentUserprofile,
          )));
        }

      case SETTINGS_SCREEN:
        {
          return GetPageRoute(
            page: ()=> SettingsScreen(SettingsController(PineAppleContext.auth))
          );
        }

      case GROUP_DETAIL_SCREEN:
        {
          GroupChatInfo groupChatInfo = args[ARG_GROUP_CHAT_INFO];
          assert(groupChatInfo!=null);
          return GetPageRoute( page: ()=>GroupDetailsScreen(GroupDetailsScreenController(groupChatInfo.groupChatUid)));
        }

      case EVENT_DETAIL_SCREEN_WITH_JOIN:
        {
          assert(args[ARG_EVENT_MODEL]!=null);
          return GetPageRoute(page: ()=>EventDetailsScreen(args[ARG_EVENT_MODEL],onJoinTapped: eventDetailScreenController.onJoinTapped,));
          //Join:
          //If event group exist, go to group
          //If event group NOT exit, create group, go to group.
        }

      case EVENT_DETAIL_SCREEN:
        {
          assert(args[ARG_EVENT_MODEL]!=null);
          return GetPageRoute(page: ()=>EventDetailsScreen(args[ARG_EVENT_MODEL]));
        }

    }
  }
}

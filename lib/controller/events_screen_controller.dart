import 'dart:async';

import 'package:pine_apple/controller/pineapple_context.dart';
import 'package:pine_apple/model/chat_message_model.dart';
import 'package:pine_apple/model/event_model.dart';
import 'package:pine_apple/model/events_repository.dart';
import 'package:pine_apple/model/profiles_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:get/get.dart';

class EventsScreenController {
  EventsRepository _eventsRepository = EventsRepository();
  UserProfileReference userProfileReference;
  StreamController<List<GroupChatInfo>> _stream = BehaviorSubject();
  StreamController<List<EventModel>> _eventStream = BehaviorSubject();
  var searching = false.obs;

  ///Constructor of EventScreenController
  ///Subscribes to the user's joined groups list to update the list of event groups that the user in a member of.
  EventsScreenController() {
    PineAppleContext.currentUser.getJoinedGroupsStream.listen((event) async {
      if (event.isEmpty) {
        _stream.add([]);
        return;
      }
      List<GroupChatInfo> list = await getUserJoinedEventGroups();
      if (list != null) _stream.add(list);
    });
  }

  ///Get all recommended events for the user according to their categories. If they do have any category selected,
  ///a general search for all current events is performed instead.
  Future<List<EventModel>> getRecommendedEvents() async {
    if (PineAppleContext.currentUid == null || PineAppleContext.currentUserprofile == null)
      return await _eventsRepository.getAllRecentEvents();
    else {
      String search = '';
      print(PineAppleContext.currentUserprofile.map.toString());
      for (String category
      in PineAppleContext.currentUserprofile.categories) {
        search += ',$category';
      }
      if (search.isBlank) return await _eventsRepository.getAllRecentEvents();
      return await _eventsRepository.searchEventWithKeyword(search);
    }
  }

  Future<void> refreshRecommendations() async {
    searching.value = true;
    List<EventModel> results = await getRecommendedEvents();
    _eventStream.add(results);
    searching.value = false;
  }

  ///Gets a snapshot of event groups that the user has joined.
  Future<List<GroupChatInfo>> getUserJoinedEventGroups() async {
    List<GroupChatInfo> groupChatInfo;
    List<String> ids =
    await PineAppleContext.currentUser.getJoinedEventGroups();
    if (ids.isEmpty) return groupChatInfo;
    groupChatInfo =
    await PineAppleContext.chatRepository.getMultipleChatGroupInfo(ids);
    return groupChatInfo;
  }

  ///Stream that fires whenever a the user joins a new event group
  Stream<List<GroupChatInfo>> get joinedEventStream => _stream.stream;
  Stream<List<EventModel>> get recommendedEventStream => _eventStream.stream;
}
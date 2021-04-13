import 'dart:async';
import 'package:pine_apple/model/event_model.dart';
import 'package:pine_apple/model/events_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:get/get.dart';

class SearchEventScreenController
{
  EventsRepository _eventsRepository = EventsRepository();
  StreamController<List<EventModel>> _resultsStream = BehaviorSubject();
  var searching = false.obs;

  ///Perform a query based on the indicated keywords
  Future<void> doQuery(String keyword) async
  {
    searching.value = true;
    List<EventModel> results =  await _eventsRepository.searchEventWithKeyword(keyword);
    _resultsStream.add(results);
    searching.value = false;
  }

  ///Stream that updates whenever results from doQuery() is available.
  Stream<List<EventModel>> get resultsStream=>_resultsStream.stream;
}

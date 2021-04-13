import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pine_apple/model/event_model.dart';



class EventsRepository
{
  final String _username = 'pineapple4';
  final String _pwd = '7r9r8tjyz2kb';
  String _basicAuth;

  EventsRepository(){
    _basicAuth = 'Basic ' + base64Encode(utf8.encode('$_username:$_pwd'));
  }

  ///Gets a a list of ongoing events associated with the keyword from the repository.
  ///If the returned list is empty, it means that there no ongoing events related to the queried keyword.
  Future<List<EventModel>> searchEventWithKeyword(String keyword) async
  {
    return await _query(_queryKeywordURL(keyword));
  }

  ///Gets a list of ongoing events from the repository.
  Future<List<EventModel>> getAllRecentEvents() async
  {
    return _query(_queryAllEventsURL());
  }

  ///Performs a http get request using the urlString.
  ///This query will wait for 5 seconds. Beyond that, the function returns an empty list.
  Future<List<EventModel>> _query(String urlString) async
  {
    var url = Uri.parse(urlString);
    try{
      http.Response r = await http.get(url, headers: {HttpHeaders.authorizationHeader:_basicAuth}).timeout(Duration(seconds: 5));
      var resp = jsonDecode(r.body) as Map;
      return _processResponse(resp);
    }on TimeoutException catch(e)
    {
      print('QUERYING EVENTS EXCEEDED TIMEOUT OF 5 SECONDS, RETRYING');
      return [];
    }
  }

  ///Processes response from http get into a list of event models.
  List<EventModel> _processResponse(Map map)
  {
    List<EventModel> results = [];
    for(Map event in map['events'])
    {
      results.add(EventModel.fromMap(event));
    }
    return results;
  }


  String _queryKeywordURL(String keyword)
  {
    return 'https://api.eventfinda.sg/v2/events.json?q=($keyword)'+
        '&fields=event:(id,name,description,address,datetime_start,datetime_end,url,images,category)';
  }

  String _queryAllEventsURL()
  {
    return 'https://api.eventfinda.sg/v2/events.json?category=246&fields=category(id,name,children)';
  }
}


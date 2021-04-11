import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EventModel
{
  EventModel({this.id,this.title,this.description,this.venue,this.startDateTIme, this.endDateTime,this.time,this.imageURL, this.keywords});
  final String id;
  final String title;
  final String description;
  final String venue;
  final DateTime startDateTIme;
  final DateTime endDateTime;
  final String time;
  final String imageURL;
  final List<String> keywords;

  String get startDate => DateFormat('dd MMM yy').format(startDateTIme);
  String get endDate => DateFormat('dd MMM yy').format(endDateTime);
  String get startTime => DateFormat('hh:mm a').format(startDateTIme);
  String get endTime => DateFormat('hh:mm a').format(endDateTime);
}


class EventsRepository
{
  final String _username = 'pineapple4';
  final String _pwd = '7r9r8tjyz2kb';
  String _basicAuth;

  EventsRepository(){
    _basicAuth = 'Basic ' + base64Encode(utf8.encode('$_username:$_pwd'));
    print(_basicAuth);
  }


  ///Gets a a list of events associated with the keyword from the internet.
  Future<List<EventModel>> searchEventsByCategory(String keyword) async
  {
    var url = Uri.parse(queryEvents(keyword));
    http.Response r = await http.get(url, headers: {HttpHeaders.authorizationHeader:_basicAuth});
    print(r.statusCode);
    var resp = jsonDecode(r.body) as Map;
    return processResponse(resp);
  }

  Future<List<EventModel>> processResponse(Map map) async
  {
    List<EventModel> results = [];
    for(Map event in map['events'])
      {
        results.add(EventModel(
            id: event['id'].toString(),
            description: event['description'],
            title: event['name'],
            venue: event['address'],
            startDateTIme: DateTime.parse(event['datetime_start']),
            endDateTime: DateTime.parse(event['datetime_end']),
            imageURL: 'https:'+processResponseImages(event['images'])+'?',
            keywords: [event['category']['name']],
        ));
      }
    return results;
  }

  String processResponseImages(Map map)
  {
    String imageUrl = "";
    for(Map item in map['images'][0]['transforms']['transforms'])
      {
        if(item['width']==350||item['height']==350)
          {
            imageUrl = item['url'];
            break;
          }
      }
    return imageUrl;
  }

  String queryEvents(String keyword)
  {
    return 'https://api.eventfinda.sg/v2/events.json?q=($keyword)'+
        '&fields=event:(id,name,description,address,datetime_start,datetime_end,url,images,category)';
  }






}
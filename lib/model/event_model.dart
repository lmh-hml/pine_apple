import 'package:intl/intl.dart';

///Model representing a public event.
class EventModel {
  EventModel(
      {this.id,
      this.title,
      this.description,
      this.venue,
      this.startDateTIme,
      this.endDateTime,
      this.time,
      this.imageURL,
      this.keywords,
      this.datetime_end,
      this.datetime_start});
  final String id;
  final String title;
  final String description;
  final String venue;
  final String datetime_end;
  final String datetime_start;
  final DateTime startDateTIme;
  final DateTime endDateTime;
  final String time;
  final String imageURL;
  final List<String> keywords;

  String get startDate => startDateTIme == null
      ? ""
      : DateFormat('dd MMM yy').format(startDateTIme);
  String get endDate =>
      endDateTime == null ? "" : DateFormat('dd MMM yy').format(endDateTime);
  String get startTime =>
      startDateTIme == null ? "" : DateFormat('hh:mm a').format(startDateTIme);
  String get endTime =>
      endDateTime == null ? "" : DateFormat('hh:mm a').format(endDateTime);
  String get startAndEndDateString => '$startDate - $endDate';
  String get keywordString {
    String s = '';
    for (var value in keywords) {
      s += value;
    }
    return s;
  }

  @override
  String toString() {
    return toMap().toString();
  }

  Map toMap() {
    return {
      'id': id,
      'name': title,
      'description': description,
      'address': venue,
      'start_date': startDate,
      'end_date': endDate,
      'start_time': startTime,
      'end_time': endTime,
      'datetime_start': datetime_start,
      'datetime_end': datetime_end,
      'keywords': keywords.toString(),
      'imageURL': imageURL,
    };
  }

  factory EventModel.fromMap(Map map) {
    return _fromEventFindDAResponse(map);
  }
}

///Helper function which Processes an event resource response from EvenfindDA into EventModel object.
EventModel _fromEventFindDAResponse(Map map) {
  EventModel ev = EventModel(
    id: map['id']?.toString() ?? "",
    description: map['description'] ?? "",
    title: map['name'] ?? map['title'] ?? "",
    venue: map['address'] ?? (map['venue']??""),
    startDateTIme: map['datetime_start'] != null
        ? DateTime.parse(map['datetime_start'])
        : null,
    endDateTime: map['datetime_end'] != null
        ? DateTime.parse(map['datetime_end'])
        : null,
    datetime_start: map["datetime_start"] ?? "",
    datetime_end: map["datetime_end"] ?? "",
    imageURL:
        map['images'] == null ? "" : _processResponseImages(map['images']),
    keywords: map['category'] == null ? [] : [map['category']['name'] ?? []],
  );
  return ev;
}

///Heloer function which Processes the 'images' resource from EventFindDA to a single image url.
String _processResponseImages(Map map) {
  String imageUrl = "";
  // imageUrl =  'https:'+map['images'][0]['original_url'] +'?'?? null;
  if (map['images'] == null) return imageUrl;
  for (Map item in map['images'][0]['transforms']['transforms']) {
    //if(item['width']==350||item['height']==350)
    if (item['transformation_id'] == 7) {
      imageUrl = 'https:' + item['url'] + '?';
      break;
    }
  }
  return imageUrl;
}

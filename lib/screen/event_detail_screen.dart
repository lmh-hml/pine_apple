import 'package:flutter/material.dart';
import 'package:pine_apple/model/event_model.dart';

class EventDetailsScreen extends StatelessWidget {

  final EventModel event;
  final Function(BuildContext,EventModel) onJoinTapped;

  EventDetailsScreen(this.event,{this.onJoinTapped});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title,style: TextStyle(color: Colors.black, fontSize: 30),),
        automaticallyImplyLeading: true,
        leading: Navigator.canPop(context)?BackButton(color: Colors.black,onPressed:()=>Navigator.pop(context),):null,
        backgroundColor: Colors.white,
      ),
      body:
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[

                    Container(
                      child: Image.network(event.imageURL+'?',fit: BoxFit.fill,),
                    ),

                    Container(
                      padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          event.title,
                          style: TextStyle(
                            fontSize: 30.0,
                            fontFamily: 'One',
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          event.description,
                          style: TextStyle(
                            fontSize: 15.0,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    ),
                    _buildDetailPair('Venue: ', event.venue),
                    _buildDetailPair('Date: ', '${event.startDate} to ${event.endDate}'),
                    _buildDetailPair('Time: ', '${event.startTime} - ${event.endTime}'),
                    _buildDetailPair('Categories: ', event.keywordString),

                    if(onJoinTapped!=null)Container(
                      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                      width: 150.0,
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: onJoinTapped==null ? null:(){
                          onJoinTapped(context,event);
                        },
                        child: Text(
                          "JOIN",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontFamily: 'One',
                            letterSpacing: 2.0,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255,192,80,70),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(80.0),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildDetailPair(String title, String value)
  {
    return Container(
      padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: title,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontFamily: 'One',
                  letterSpacing: 1.0,
                ),
              ),
              TextSpan(
                text: value,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



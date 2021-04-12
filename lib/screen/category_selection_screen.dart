import 'package:flutter/material.dart';
import "package:pine_apple/screen/main_screen.dart";
import 'package:pine_apple/screen/screen.dart';

class CategorySelection extends StatefulWidget {
  @override
  _CategorySelectionState createState() => _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
            'Category of Events:',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            color: Colors.black,
            iconSize: 40.0,
            onPressed: () => {
              Navigator.pushNamed(context,Routes.START_UP)
            },
          ),
        ],
      ),
      body: getBody(),
    );
  }
  Widget getBody(){

    final List<String> items = [
      'Food/Beverage',
      'Exhibitions',
      'Arts',
      'Film',
      'Digital and interactive',
      'Theatre',
    ];

    return SingleChildScrollView(
      child: Column(
        children: <Widget> [
          Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Wrap(
                  spacing: 5.0,
                  runSpacing: 3.0,
                  children:<Widget>[
                    for (var item in items) FilterChipWidget(chipName: (item),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FilterChipWidget extends StatefulWidget {
  final String chipName;

  FilterChipWidget({Key key, this.chipName}) : super(key: key);

  @override
  _FilterChipWidgetState createState() => _FilterChipWidgetState();
}

class _FilterChipWidgetState extends State<FilterChipWidget> {
  var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.chipName),
      labelStyle: TextStyle(
        color: Color(0xff6200ee),
        fontSize: 16.0,
        fontWeight: FontWeight.bold
      ),
      selected: _isSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: Color(0xffededed),
      onSelected: (isSelected) {
        setState(() {
          _isSelected = isSelected;
        });
      },
      selectedColor: Color(0xffeadffd),
    );
  }
}
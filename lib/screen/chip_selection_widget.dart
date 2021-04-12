import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pine_apple/model/profiles_repository.dart';

final List<String> EventCategories = [
  'Food/Beverage',
  'Exhibitions',
  'Arts',
  'Film',
  'Digital and interactive',
  'Theatre',
  'Concerts & Gig Guide',
  'Performing Arts',
  'Theater',
  'Sports',
  'Festivals & Lifestyle'
  'Ballet',
  'Exhibitions',
  'Business & Education',
  'Musicals'
];


class ChipSelectionWidget extends StatefulWidget {

  final EditCategorySelectionController controller;
  ChipSelectionWidget(this.controller);

  @override
  _ChipSelectionWidgetState createState() => _ChipSelectionWidgetState();
}

class _ChipSelectionWidgetState extends State<ChipSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        spacing: 5.0,
        runSpacing: 3.0,
        children:<Widget>[
          for (var item in EventCategories)
            FilterChip(
              label: Text(item),
              labelStyle: TextStyle(
                  color: Color(0xff6200ee),
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              backgroundColor: Color(0xffededed),
              selectedColor: Color(0xffeadffd),
              selected: widget.controller.isSelected(item),
              onSelected: (selected){
                  setState(() {
                    if(selected)widget.controller.addSelection(item);
                    else widget.controller.removeSelection(item);
                  });
                },
            )
        ],
      ),
    );
  }
}

class EditCategorySelectionController
{
  UserProfileReference profileReference;
  Set<String> selectedCategories = Set<String>();
  EditCategorySelectionController(this.profileReference);

  void addSelection(String categoryName)
  {
    selectedCategories.add(categoryName);
  }

  void removeSelection(String categoryName)
  {
    selectedCategories.remove(categoryName);
  }

  Future<void> saveSelection() async
  {
    await profileReference.updateCategories(selectedCategories.toList());
  }

  bool isSelected(String category)
  {
    return selectedCategories.contains(category);
  }

  UnmodifiableListView get selected => UnmodifiableListView(selectedCategories.toList(growable: false));
}
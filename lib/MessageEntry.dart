import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pine_apple/ChatModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'model.dart';

/// Widget used by users to enter messages or attach files to their messages before sending.
class MessageEntryBar extends StatefulWidget {
  Function(String)
      onSend; //The function to be called whenever the send button is tapped
  MessageEntryBar({@required this.onSend});

  @override
  _MessageEntryBarState createState() => _MessageEntryBarState();
}

class _MessageEntryBarState extends State<MessageEntryBar> {
  TextEditingController _textEditingController = TextEditingController();
  ChatMessage _chatMessage;
  ImagePicker _picker = ImagePicker();
  File _msgAttachment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          child: Icon(
            Icons.image,
            size: 20,
          ),
          style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.symmetric(horizontal: 5)),
          onPressed: _onAttachButton,
        ),
        Expanded(
            child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: TextField(
                  decoration: InputDecoration(hintText: "Enter Message here"),
                  controller: _textEditingController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ))),
        ElevatedButton(
          child: Icon(Icons.send, size: 20),
          style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.symmetric(horizontal: 5)),
          onPressed: _onSendButton,
        ),
      ],
    );
  }

  void _onAttachButton() {
    getImage(ImageSource.gallery);
  }

  Future<void> getImage(ImageSource src) async {
    final pickedFile = await _picker.getImage(source: src);
    if (pickedFile != null) _msgAttachment = File(pickedFile.path);
  }

  void _onSendButton() {
    widget.onSend.call(_textEditingController.text);
  }
}

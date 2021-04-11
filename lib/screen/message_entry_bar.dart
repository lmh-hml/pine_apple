import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Widget used by users to enter messages or attach files to their messages before sending.
class MessageEntryBar extends StatefulWidget {
  final Function(String)
      onSend; //The function to be called whenever the send button is tapped
  MessageEntryBar({@required this.onSend});

  @override
  _MessageEntryBarState createState() => _MessageEntryBarState();
}

class _MessageEntryBarState extends State<MessageEntryBar> {
  TextEditingController _textEditingController = TextEditingController();
  ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset: Offset(0, -2),
                blurRadius: 10)
          ]),

      child: Row(
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
      ),
    );
  }

  void _onAttachButton() {
  }

  void _onSendButton() {
    widget.onSend.call(_textEditingController.text);
  }
}

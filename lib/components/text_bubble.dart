import 'package:flutter/material.dart';
import 'package:billy/constant.dart';

class TextBubble extends StatelessWidget {
  final String message;
  final bool isSender;

  const TextBubble({
    Key? key,
    required this.message,
    required this.isSender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 20), // Set a minimum height
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: isSender
                ? Constants.SenderColorMessage
                : Constants.ReceiverColorMessage,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Stack(
            children: [
              FractionallySizedBox(
                widthFactor: 0.8, // Limit the width to 80% of the total width
                child: Padding(
                  padding:
                      EdgeInsets.only(right: 40), // Add padding to the right
                  child: Text(
                    message,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              if (isSender)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.info, color: Colors.white),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Improved Message'),
                            content: Text(
                                'This is the improved version of the message.'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Close'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

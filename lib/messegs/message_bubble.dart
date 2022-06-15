import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class MessageBubble extends StatelessWidget {
  //const MessageBubble({Key? key}) : super(key: key);
  MessageBubble(this.message, this.userName, this.imageUrl, this.isMe,
      {this.key});
  final Key? key;
  final String message;
  final String userName;
  final bool isMe;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color:
                      isMe ? Colors.grey[300] : Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                    bottomLeft: isMe ? Radius.circular(0) : Radius.circular(14),
                    bottomRight:
                        !isMe ? Radius.circular(0) : Radius.circular(14),
                  )),
              width: 200,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isMe ? Colors.black : Colors.black,
                    ),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                        color: isMe
                            ? Colors.black
                            : Theme.of(context).highlightColor),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  )
                ],
              ),
            )
          ],
        ),
        Positioned(
          top: -10,
          left: isMe ? 20 : 0,
          right: !isMe ? 20 : 0,
          child: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl, scale: 20),
          ),
        ),
      ],
    );
  }
}

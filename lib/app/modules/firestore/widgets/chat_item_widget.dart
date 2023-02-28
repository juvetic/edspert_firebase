import 'package:firebase/helpers/date_utils.dart';
import 'package:flutter/material.dart';

import '../models/chat_item.dart';

class ChatItemWidget extends StatelessWidget {
  final ChatItem chat;

  const ChatItemWidget({required this.chat, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: (chat.isSender!)
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            chat.name,
            style: TextStyle(color: mappingNameColor(context)),
          ),
          Card(
            color: mappingCardColor(context),
            margin: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: (chat.isSender!)
                      ? const Radius.circular(0)
                      : const Radius.circular(8),
                  bottomLeft: const Radius.circular(8),
                  topLeft: (!chat.isSender!)
                      ? const Radius.circular(0)
                      : const Radius.circular(8),
                  topRight: const Radius.circular(8)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (chat.image != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: Image.network(
                        chat.image!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  Text(chat.content,
                      style: TextStyle(
                        color: (chat.isSender!) ? Colors.white : Colors.black,
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            chat.dateTime.chatDateTime,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xff979797),
            ),
          ),
        ],
      ),
    );
  }

  Color mappingCardColor(BuildContext context) {
    if (chat.isTutor) {
      return const Color(0xffE0F8FF);
    }

    if (chat.isSender!) {
      return const Color(0xff3A7FD5);
    }

    if (chat.id.isEven) {
      return const Color(0xffEAE0FF);
    }

    if (chat.id.isOdd) {
      return const Color(0xffFFDCDC);
    }

    return Colors.white;
  }

  Color mappingNameColor(BuildContext context) {
    if (chat.isTutor) {
      return const Color(0xff00C4FF);
    }

    if (chat.isSender!) {
      return const Color(0xff03BDB9);
    }

    if (chat.id.isEven) {
      return const Color(0xff5200FF);
    }

    if (chat.id.isOdd) {
      return const Color(0xffFF0000);
    }

    return Colors.black;
  }
}

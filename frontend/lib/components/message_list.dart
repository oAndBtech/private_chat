import 'package:flutter/material.dart';
import 'package:private_chat/components/received_message.dart';
import 'package:private_chat/components/sent_message.dart';
import 'package:private_chat/models/message_model.dart';

class MessageList extends StatefulWidget {
  const MessageList({required this.messages, super.key});

  final List<MessageModel> messages;

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  int senderId = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: widget.messages.length,
          itemBuilder: (context, index) {
            return widget.messages[index].sender == senderId
                ? SentMessage(message: widget.messages[index])
                : ReceivedMessage(message: widget.messages[index]);
          }),
    );
  }
}

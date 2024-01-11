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
  int senderId = 1; //TODO: hardcoded
  final ScrollController scrollController = ScrollController();
  scrollToBottom() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
    return ListView.builder(
        controller: scrollController,
        itemCount: widget.messages.length,
        itemBuilder: (context, index) {
          return widget.messages[index].sender == senderId
              ? SentMessage(message: widget.messages[index])
              : ReceivedMessage(message: widget.messages[index]);
        });
  }
}

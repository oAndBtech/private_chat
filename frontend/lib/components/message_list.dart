import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat/components/received_message.dart';
import 'package:private_chat/components/sent_message.dart';
import 'package:private_chat/models/message_model.dart';
import 'package:private_chat/providers/user_provider.dart';

class MessageList extends ConsumerStatefulWidget {
  const MessageList({required this.messages, super.key});

  final List<MessageModel> messages;

  @override
  ConsumerState<MessageList> createState() => _MessageListState();
}

class _MessageListState extends ConsumerState<MessageList> {
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
    int senderId = ref.watch(userIdProvider);
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

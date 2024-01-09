import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat/components/bottom_component.dart';
import 'package:private_chat/components/message_list.dart';
import 'package:private_chat/models/message_model.dart';
import 'package:private_chat/providers/message_provider.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  // List<MessageModel> messages =[];

  @override
  Widget build(BuildContext context) {
    List<MessageModel> messages = ref.watch(messageProvider);

    return Scaffold(
        backgroundColor: const Color(0xff282C34),
        appBar: AppBar(),
        body: SafeArea(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(child: MessageList(messages: messages)),
              const BottomComponent()
            ],
          ),
        ));
  }
}

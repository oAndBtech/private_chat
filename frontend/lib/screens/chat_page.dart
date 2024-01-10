import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat/components/bottom_component.dart';
import 'package:private_chat/components/message_list.dart';
import 'package:private_chat/models/message_model.dart';
import 'package:private_chat/providers/message_provider.dart';
import 'package:private_chat/providers/room_provider.dart';
import 'package:private_chat/services/socket_services.dart';
import 'package:web_socket_client/web_socket_client.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  addRoomId() {
    ref.read(roomProvider.notifier).addRoom("aa45");
  }

  WebSocket? socket;

  @override
  void initState() {
    super.initState();
    // addRoomId();
    buildSocketConnection();
  }

  buildSocketConnection() {
    String roomId = 'abc'; //TODO: change this
    WebSocket ws = SocketService().buildSocketConnection(roomId, 1);
    setState(() {
      socket = ws;
    });
    handleMessages();
  }

  handleMessages() {
    if (socket != null) {
      socket!.messages.listen((event) {
        final jsonResponse = jsonDecode(event);

        print(jsonResponse);

        List<int> content = utf8.encode(jsonResponse["content"]);

        MessageModel receivedMessage = MessageModel(
            timestamp: jsonResponse["timestamp"],
            sendername: jsonResponse["sender"],
            istext: jsonResponse["istext"],
            content: content);

        ref.read(messageProvider.notifier).addMessage(receivedMessage);
      });
    }
  }

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
              BottomComponent(socket: socket)
            ],
          ),
        ));
  }
}

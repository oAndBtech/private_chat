import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:private_chat/components/appbar.dart';
import 'package:private_chat/components/bottom_component.dart';
import 'package:private_chat/components/message_list.dart';
import 'package:private_chat/models/message_model.dart';
import 'package:private_chat/models/room_model.dart';
import 'package:private_chat/models/user_model.dart';
import 'package:private_chat/providers/message_provider.dart';
import 'package:private_chat/providers/room_provider.dart';
import 'package:private_chat/providers/users_in_room_provider.dart';
import 'package:private_chat/services/api_services.dart';
import 'package:private_chat/services/socket_services.dart';
import 'package:web_socket_client/web_socket_client.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  WebSocket? socket;

  int status = 0;
  bool isLoading = true;

  chechStatus() {
    print(status);
    if (status > 3) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    buildSocketConnection();
    fetchRoom();
    fetchAllMessages();
    fetchAllUsers();
  }

  @override
  void initState() {
    super.initState();
  }

  buildSocketConnection() {
    if (socket == null) {
      String roomId = ref.watch(roomIdProvider) ?? '-1';
      WebSocket ws = SocketService().buildSocketConnection(roomId, 1);
      setState(() {
        socket = ws;
        status++;
      });
    }

    chechStatus();
    handleMessages();
  }

  handleMessages() {
    if (socket != null) {
      socket!.messages.listen((event) {
        final jsonResponse = jsonDecode(event);

        print(jsonResponse);

        List<int> content = utf8.encode(jsonResponse["content"]);

        MessageModel receivedMessage = MessageModel(
            sender: jsonResponse["senderId"],
            timestamp:
                formatTimestamp(jsonResponse["timestamp"] ?? DateTime.now()),
            sendername: jsonResponse["sender"],
            istext: jsonResponse["istext"],
            content: content);
        ref.read(messageProvider.notifier).addMessage(receivedMessage);
      });
    }
  }

  fetchAllMessages() async {
    if (ref.read(messageProvider).isEmpty) {
      String roomId = ref.watch(roomIdProvider) ?? '-1';
      List<MessageModel> messages =
          await ApiService().messagesInRoom(roomId) ?? [];

      ref.read(messageProvider.notifier).addAllMessages(messages);
      setState(() {
        status++;
      });
    }

    chechStatus();
  }

  fetchAllUsers() async {
    if (ref.read(usersInRoomProvider).isEmpty) {
      String roomId = ref.watch(roomIdProvider) ?? '-1';
      List<UserModel> usrs = await ApiService().allUsersInRoom(roomId) ?? [];
      ref.read(usersInRoomProvider.notifier).addAllUsers(usrs);
      setState(() {
        status++;
      });
    }
    chechStatus();
  }

  fetchRoom() async {
    if (ref.read(roomProvider) == null) {
      String roomId = ref.watch(roomIdProvider) ?? '-1';
      RoomModel? room = await ApiService().getRoom(roomId);
      if (room != null) {
        ref.read(roomProvider.notifier).addRoom(room);
        setState(() {
          status++;
        });
      }
    }
    chechStatus();
  }

  String formatTimestamp(String timestampString) {
    DateTime timestamp = DateTime.parse(timestampString).toLocal();
    DateTime currentDate = DateTime.now();
    if (timestamp.year == currentDate.year &&
        timestamp.month == currentDate.month &&
        timestamp.day == currentDate.day) {
      return DateFormat('hh:mm a').format(timestamp);
    } else {
      return DateFormat('hh:mm a, dd-MM-yyyy').format(timestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<MessageModel> messages = ref.watch(messageProvider);
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: const Color(0xff282C34),
            appBar: AppBar(
              elevation: 0,
              toolbarHeight: 0.0,
              systemOverlayStyle:
                  const SystemUiOverlayStyle(statusBarColor: Color(0xff111216)),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  const CustomAppBar(),
                  Expanded(child: MessageList(messages: messages)),
                  BottomComponent(socket: socket)
                ],
              ),
            ));
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:private_chat/components/appbar.dart';
import 'package:private_chat/components/bottom_component.dart';
import 'package:private_chat/components/message_list.dart';
import 'package:private_chat/models/message_model.dart';
import 'package:private_chat/models/room_model.dart';
import 'package:private_chat/models/user_model.dart';
import 'package:private_chat/providers/message_provider.dart';
import 'package:private_chat/providers/room_provider.dart';
import 'package:private_chat/providers/user_provider.dart';
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
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

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

  setupFirebase() async {
    if (kIsWeb) {
      final fcmToken = await FirebaseMessaging.instance.getToken(
          vapidKey:
              "BLrhT_yN89tQv7TPDPaurZr6tmwrb1Rs0ckVbNwkTlsAi5S4lUJNkrXXodhCHKucDhjoy70XY0E90k99PeY5LlA");
      if (fcmToken != null) {
        await sendTokenToServer(fcmToken);
      }
      return;
    }

    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      await sendTokenToServer(token);
    }
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      sendTokenToServer(newToken);
    });
  }

  sendTokenToServer(String token) async {
    int userId = ref.watch(userIdProvider);
    if (userId == -1) {
      return;
    }
    ApiService().updateFcmToken(token, userId);
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
    setupFirebase();
  }

  buildSocketConnection() async {
    if (socket == null) {
      int userId = ref.watch(userIdProvider);
      String roomId = ref.watch(roomIdProvider) ?? '-1';
      if (userId == -1 || roomId == '-1') {
        return;
      }
      WebSocket ws = SocketService().buildSocketConnection(roomId, userId);
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
        : WillPopScope(
            onWillPop: () async {
              return await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: const Color(0xff111216),
                      title: Text(
                        'Are you sure you want to exit?',
                        style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xffFFFFFF)),
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel',
                                style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff000000)))),
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) =>
                                        const Color.fromARGB(255, 50, 153, 101))),
                            onPressed: () {
                              exit(0);
                            },
                            child: Text('Exit',
                                style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff000000))))
                      ],
                    ),
                  ) ??
                  false;
            },
            child: Scaffold(
                backgroundColor: const Color(0xff282C34),
                appBar: AppBar(
                  elevation: 0,
                  toolbarHeight: 0.0,
                  systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarColor: Color(0xff111216)),
                ),
                body: SafeArea(
                  child: Column(
                    children: [
                      const CustomAppBar(),
                      Expanded(child: MessageList(messages: messages)),
                      BottomComponent(socket: socket)
                    ],
                  ),
                )),
          );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:private_chat/components/custom_textfield.dart';
import 'package:private_chat/components/send_button.dart';
import 'package:private_chat/models/message_model.dart';
import 'package:private_chat/models/user_model.dart';
import 'package:private_chat/providers/message_provider.dart';
import 'package:private_chat/services/socket_services.dart';
import 'package:web_socket_client/web_socket_client.dart';

class BottomComponent extends ConsumerStatefulWidget {
  const BottomComponent({super.key, this.socket});
  // final TextEditingController messageController;
  final WebSocket? socket;
  @override
  ConsumerState<BottomComponent> createState() => _BottomComponentState();
}

class _BottomComponentState extends ConsumerState<BottomComponent> {
  TextEditingController messageController = TextEditingController();

  void sendMessage() {
    String text = messageController.text.trim();

    UserModel user = UserModel(
        name: "bhaskar", phone: "98465", id: 1, fcmtoken: "xdrcvftgy");

    if (text.isNotEmpty && user.id != null) {

      List<int> contentByte = utf8.encode(text);
      SocketService().sendMessage(text, widget.socket,true);

      MessageModel sentMsg = MessageModel(
          sender: user.id!,
          receiver: "",
          istext: true,
          content: contentByte,
          timestamp: formatTimestamp(DateTime.now().toString()));

      ref.read(messageProvider.notifier).addMessage(sentMsg);
    }
    messageController.clear();
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextfield(
          socket: widget.socket,
          messageController: messageController,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 11),
          child: SendButton(send: () {
            sendMessage();
          }),
        )
      ],
    );
  }
}

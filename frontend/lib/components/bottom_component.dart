import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      // MessageModel msg = MessageModel(
      //     istext: true,
      //     content: text);

      SocketService().sendMessage(text, widget.socket,true);//TODO: change this

      MessageModel sentMsg = MessageModel(
          sender: user.id!,
          receiver: "",
          istext: true,
          content: contentByte,
          timestamp: DateTime.now().toString());

      ref.read(messageProvider.notifier).addMessage(sentMsg);
    }
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextfield(
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

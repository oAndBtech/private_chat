import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat/components/custom_textfield.dart';
import 'package:private_chat/components/send_button.dart';
import 'package:private_chat/models/message_model.dart';
import 'package:private_chat/models/user_model.dart';
import 'package:private_chat/providers/message_provider.dart';
import 'package:private_chat/providers/room_provider.dart';
import 'package:private_chat/providers/user_provider.dart';

class BottomComponent extends ConsumerStatefulWidget {
  const BottomComponent({super.key});
  // final TextEditingController messageController;
  @override
  ConsumerState<BottomComponent> createState() => _BottomComponentState();
}

class _BottomComponentState extends ConsumerState<BottomComponent> {
  TextEditingController messageController = TextEditingController();

  void sendMessage() {
    print("HELLO WORLD");
    // String? roomId = ref.watch(roomProvider);
    String roomId = "AA45";
    // UserModel? user = ref.watch(userProvider);
    String text = messageController.text.trim();
    UserModel user = UserModel(
        name: "bhaskar", phone: "98465", id: 1, fcmtoken: "xdrcvftgy");

    print(user!.id);

    if (text.isNotEmpty && user != null && roomId != null && user.id != null) {
    print("HELLO WORLD");
      List<int> contentByte = utf8.encode(text);
      MessageModel msg = MessageModel(
          sender: user.id!,
          receiver: roomId,
          istext: true,
          content: contentByte);
      ref.read(messageProvider.notifier).addMessage(msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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

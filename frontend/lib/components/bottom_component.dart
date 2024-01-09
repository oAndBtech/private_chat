import 'package:flutter/material.dart';
import 'package:private_chat/components/custom_textfield.dart';
import 'package:private_chat/components/send_button.dart';
import 'package:private_chat/models/message_model.dart';

class BottomComponent extends StatefulWidget {
  const BottomComponent({ super.key});
  // final TextEditingController messageController;
  @override
  State<BottomComponent> createState() => _BottomComponentState();
}

class _BottomComponentState extends State<BottomComponent> {
  TextEditingController messageController = TextEditingController();

  void sendMessage(params) {
    MessageModel msg = MessageModel(sender: sender, receiver: receiver, istext: istext, timestamp: timestamp, content: content)
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

          }),
        )
      ],
    );
  }
}

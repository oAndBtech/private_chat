import 'package:flutter/material.dart';
import 'package:private_chat/components/custom_textfield.dart';
import 'package:private_chat/components/send_button.dart';

class BottomComponent extends StatefulWidget {
  const BottomComponent({required this.messageController, super.key});
  final TextEditingController messageController;
  @override
  State<BottomComponent> createState() => _BottomComponentState();
}

class _BottomComponentState extends State<BottomComponent> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomTextfield(
          messageController: widget.messageController,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 11),
          child: SendButton(send: () {}),
        )
      ],
    );
  }
}

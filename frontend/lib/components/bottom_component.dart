import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:private_chat/components/custom_textfield.dart';
import 'package:private_chat/components/send_button.dart';
import 'package:private_chat/models/message_model.dart';
import 'package:private_chat/providers/message_provider.dart';
import 'package:private_chat/providers/room_provider.dart';
import 'package:private_chat/providers/user_provider.dart';
import 'package:private_chat/services/socket_services.dart';
import 'package:private_chat/services/uniqueid.dart';
import 'package:rich_text_controller/rich_text_controller.dart';
import 'package:web_socket_client/web_socket_client.dart';

class BottomComponent extends ConsumerStatefulWidget {
  const BottomComponent({super.key, this.socket});
  final WebSocket? socket;
  @override
  ConsumerState<BottomComponent> createState() => _BottomComponentState();
}

class _BottomComponentState extends ConsumerState<BottomComponent> {
  RichTextController messageController = RichTextController(
      patternMatchMap: {
        RegExp(r"@(.*)+\(+([6789]\d{9})+\)"): GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.blue,
        ),
      },
      onMatch: (List<String> matches) {},
      deleteOnBack: true,
      regExpUnicode: true);

  void sendMessage() {
    String text = messageController.text.trim();

    int id = ref.watch(userIdProvider);
    String roomId = ref.watch(roomIdProvider) ?? 'roomID';

    if (text.isNotEmpty && id != -1) {
      List<int> contentByte = utf8.encode(text);
      String uniqueid = UniqueIdService().generateUniqueId(id, roomId);
      SocketService().sendMessage(text, widget.socket, true, uniqueid,
          null); //TODO change this reply to accordingly

      MessageModel sentMsg = MessageModel(
          uniqueid: uniqueid,
          replyto: null, //TODO: handle this
          sender: id,
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
    return kIsWeb
        ? RawKeyboardListener(
            autofocus: true,
            focusNode: FocusNode(),
            onKey: (event) {
              if (event is RawKeyDownEvent) {
                if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                  sendMessage();
                }
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomTextfield(
                  socket: widget.socket,
                  messageController: messageController,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 11, left: 20),
                  child: SendButton(send: () {
                    sendMessage();
                  }),
                )
              ],
            ),
          )
        : Row(
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

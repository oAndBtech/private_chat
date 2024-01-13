import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:private_chat/components/img_container.dart';
import 'package:private_chat/models/message_model.dart';
import 'package:private_chat/models/user_model.dart';

class SentMessage extends StatefulWidget {
  const SentMessage({required this.message, super.key});
  final MessageModel message;

  @override
  State<SentMessage> createState() => _SentMessageState();
}

class _SentMessageState extends State<SentMessage> {
  UserModel? user;

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
    double width = MediaQuery.of(context).size.width;
    // String msg = utf8.decode(widget.message.content);
    return Align(
      alignment: Alignment.centerRight,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 8, 8, 0),
            constraints:
                BoxConstraints(maxWidth: width * 0.65, minWidth: width * 0.25),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(18),
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
              color: Color.fromARGB(255, 136, 240, 153),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.message.isOffline != null && widget.message.isOffline!
                      ? ImageContainer(
                          bytes: widget.message.content,
                          isUrl: false,
                        )
                      : !widget.message.istext
                          ? ImageContainer(
                              url: utf8.decode(widget.message.content),
                              isUrl: true,
                            )
                          : Text(
                              utf8.decode(widget.message.content),
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.2,
                                color: const Color(0xff000000),
                              ),
                            ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 8,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                formatTimestamp(
                    widget.message.timestamp ?? DateTime.now().toString()),
                style: GoogleFonts.montserrat(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.2,
                  color: const Color.fromARGB(255, 121, 121, 121),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

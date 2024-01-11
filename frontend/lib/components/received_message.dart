import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:private_chat/models/message_model.dart';

//TODO: timestamp alignment

class ReceivedMessage extends StatefulWidget {
  const ReceivedMessage({required this.message, super.key});

  final MessageModel message;

  @override
  State<ReceivedMessage> createState() => _ReceivedMessageState();
}

class _ReceivedMessageState extends State<ReceivedMessage> {
  // UserModel user = UserModel(
  //       name: "bhaskar", phone: "98465", id: 1, fcmtoken: "xdrcvftgy");

  // fetchUser() {
  //   //TODO: call api (/user/message.sender)
  // }

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
    String msg = utf8.decode(widget.message.content);

    return Align(
      alignment: Alignment.centerLeft,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(8, 8, 0, 0),
            constraints: BoxConstraints(
              minWidth: width * 0.25,
              maxWidth: width * 0.65,
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(18),
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
              color: Color.fromARGB(255, 208, 236, 213),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 10, 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.message.sendername!,
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.2,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    msg,
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
            bottom: -3,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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

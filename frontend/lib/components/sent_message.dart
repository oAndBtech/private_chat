import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:private_chat/components/img_container.dart';
import 'package:private_chat/models/message_model.dart';

class SentMessage extends StatelessWidget {
  const SentMessage({required this.message, super.key});
  final MessageModel message;

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
            constraints: BoxConstraints(
                maxWidth: kIsWeb ? width * 0.45 : width * 0.65, minWidth: 120),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(18),
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
              color: Color.fromARGB(188, 50, 153, 102),
            ),
            child: Padding(
              padding: message.istext
                  ? const EdgeInsets.fromLTRB(8, 8, 8, 18)
                  : const EdgeInsets.fromLTRB(3, 3, 3, 21),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  message.isOffline != null && message.isOffline!
                      ? ImageContainer(
                          bytes: message.content,
                          isUrl: false,
                        )
                      : !message.istext
                          ? ImageContainer(
                              url: utf8.decode(message.content),
                              isUrl: true,
                            )
                          : SelectableText(
                              utf8.decode(message.content),
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.2,
                                color: const Color(0xffEEEEEE),
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
                message.timestamp!,
                style: GoogleFonts.montserrat(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.2,
                  color: const Color(0xffBABABA),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

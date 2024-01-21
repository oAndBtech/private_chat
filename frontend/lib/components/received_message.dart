import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:private_chat/components/img_container.dart';
import 'package:private_chat/models/message_model.dart';

class ReceivedMessage extends StatelessWidget {
  const ReceivedMessage({required this.message, super.key});

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Align(
      alignment: Alignment.centerLeft,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(8, 8, 0, 0),
            constraints: BoxConstraints(
              maxWidth: kIsWeb ? width * 0.45 : width * 0.65,
                minWidth: 120
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(18),
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
              color: Color.fromARGB(255, 76, 77, 76),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 10, 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.sendername ?? '',
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.2,
                      color: Colors.blue,
                    ),
                  ),
                  !message.istext
                      ? ImageContainer(
                          url: utf8.decode(message.content),
                          isUrl: true,
                        )
                      : SelectableText(
                          utf8.decode(message.content),
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
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
            bottom: -3,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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

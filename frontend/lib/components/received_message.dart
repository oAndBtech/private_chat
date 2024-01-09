import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReceivedMessage extends StatelessWidget {
  const ReceivedMessage({
    required this.timestamp,
    required this.alignment,
    required this.messageText,
    required this.senderName,
    super.key
    });

    final String messageText;
    final String senderName; 
    final Alignment alignment;
    final String timestamp;

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Align(
      alignment: alignment,
      child: Container(
        // width: width * 0.65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(18),topLeft: Radius.circular(18),topRight: Radius.circular(18)),
          color: Color.fromARGB(255, 208, 236, 213),
      
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                senderName,
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.2,
                  color: Colors.blue
                ),
              ),
          
              Text(
                messageText,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.2,
                  color: Color(0xff000000)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
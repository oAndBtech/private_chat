import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SentMessage extends StatelessWidget {
  const SentMessage({
    required this.messageText,
    required this.senderName,
    super.key
    });

    final String messageText;
    final String senderName; 

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Container(
      // width: width * 0.65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(18),topLeft: Radius.circular(18),topRight: Radius.circular(18)),
        color: Color.fromARGB(255, 136, 240, 153),

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
                fontSize: 14,
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
            Text(
              '8:00 PM',
              style: GoogleFonts.montserrat(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.2,
                color: Color.fromARGB(255, 121, 121, 121)
              ),
            )
          ],
        ),
      ),
    );
  }
}
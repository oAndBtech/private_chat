import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MemberElement extends StatelessWidget {
  const MemberElement({
    required this.name,
    required this.number,
    super.key
    });
    final String name;
    final String number;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(text: TextSpan(
            text: name,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: const Color(0xffFFFFFF) 
            )
          )),
          RichText(text: TextSpan(
            text: number,
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: const Color(0xffBABABA) 
            )
          ))
        ],
      ),
    );
  }
}
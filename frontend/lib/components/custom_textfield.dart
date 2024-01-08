import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// TODO: add icon must alwas remain down and length of text input must be in container

class CustomTextfield extends StatelessWidget {
  const CustomTextfield({super.key});

  @override
  Widget build(BuildContext context) {
  double width = MediaQuery.of(context).size.width;

    return Container(
      width: width*0.8,
      margin: EdgeInsets.only(top: 12, bottom: 12),
      decoration: BoxDecoration(
        color: Color(0xff000000).withOpacity(0.6),
        borderRadius: BorderRadius.circular(20)
      ),
      padding: EdgeInsets.only(right: 12),
      child: TextField(
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          hintText: 'Message...',
          hintStyle: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.grey
          ),
          icon: IconButton(
            onPressed: () {}, 
            icon: Icon(Icons.add),
            color: Colors.grey,
            ),
          contentPadding: EdgeInsets.symmetric(horizontal: -18),
          border: InputBorder.none,
          focusColor: Color(0xffFFFFFF),
        ),
        style: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.2,
          color: Color(0xffFFFFFF)
        ),
        maxLines: null,
      ),
    );
  }
}
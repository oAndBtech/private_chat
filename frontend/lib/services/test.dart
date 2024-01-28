import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TestTagColors {

  
  List<TextSpan> anotherFunction(String str) {
    RegExp regExp = RegExp(r"@(.*)+\(+([6789]\d{9})+\)");
    int prev = 0;
    List<TextSpan> list = [];

    regExp.allMatches(str).forEach((element) {
      final start = element.start;
      final end = element.end;
      if (start > prev) {
        list.add(TextSpan(
          text: str.substring(prev, start),
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.2,
            color: const Color(0xffFFFFFF),
          ),
        ));
      }

      list.add(TextSpan(
        text: str.substring(start, end),
        style: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.2,
          color: Colors.blue,
        ),
      ));
      prev = end;
    });
    return list;
  }

  List<TextSpan> initFunction(String str) {
    if (str.contains(" @") || str.startsWith("@") || str.contains("\n@")) {
      return anotherFunction(str);
    } else {
      return [
        TextSpan(
          text: str,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.2,
            color: const Color(0xffFFFFFF),
          ),
        )
      ];
    }
  }
}

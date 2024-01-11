import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  //TODO: fetch room name and people count, hardcoded right now

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      width: double.infinity,
      color: const Color(0xff000000).withOpacity(0.6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Icon(
              Icons.arrow_back,
              size: 28,
              color: Color(0xffFFFFFF),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 8,
                ),
                RichText(
                    text: TextSpan(
                        text: 'Da\'s',
                        style: GoogleFonts.montserrat(
                            fontSize: 21,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.2,
                            color: const Color(0xffFFFFFF)))),
                RichText(
                  text: TextSpan(
                    text: '11 people are in the room',
                  style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xffBABABA)),
                ))
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.more_vert_rounded,
              size: 28,
              color: Color(0xffFFFFFF),
            )
          ],
        ),
      ),
    );
  }
}

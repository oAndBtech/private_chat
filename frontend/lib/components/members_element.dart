import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class MemberElement extends StatelessWidget {
  const MemberElement(
      {required this.name, required this.isTag, required this.number, Key? key})
      : super(key: key);

  final String name;
  final String number;
  final bool isTag;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Material(
          color: Colors.transparent,
          child: !isTag ? InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () async {
              final Uri callUser = Uri(scheme: 'tel', path: number);

              if (await canLaunchUrl(callUser)) {
                await launchUrl(callUser);
              } else {
                throw 'Could not launch $callUser';
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: name,
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xffFFFFFF),
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: number,
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xffBABABA),
                    ),
                  ),
                ),
              ],
            ),
          ) : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: name,
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xffFFFFFF),
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: number,
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xffBABABA),
                    ),
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }
}

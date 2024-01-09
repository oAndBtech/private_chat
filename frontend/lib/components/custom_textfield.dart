import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield({Key? key});


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final TextEditingController messageController = TextEditingController();

    return Container(
      width: width * 0.8,
      margin: EdgeInsets.only(top: 12, bottom: 12),
      decoration: BoxDecoration(
        color: Color(0xff000000).withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      // padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add),
            color: Colors.grey,
          ),
          Expanded(
            child: TextField(
              controller: messageController,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText: 'Message...',
                hintStyle: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
                border: InputBorder.none,
                focusColor: Color(0xffFFFFFF),
              ),
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.2,
                color: Color(0xffFFFFFF),
              ),
              maxLines: null,
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:private_chat/providers/room_provider.dart';
import 'package:private_chat/screens/chat_page.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen(
      {
      // required this.controller,
      super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xff282C34),
      body: SafeArea(
          child: Center(
        child: AlertDialog(
          elevation: 20,
          backgroundColor: Color(0xff111216),
          title: Text(
            'Enter your Room ID',
            style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.2,
                color: const Color(0xffFFFFFF)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter a valid Room ID!";
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.2,
                    color: const Color(0xffFFFFFF)),
                cursorColor: Color(0xffFFFFFF).withOpacity(0.7),
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      width: 2,
                      color: Color(0xffFFFFFF).withOpacity(0.7),
                    )),
                    // enabledBorder: OutlineInputBorder(),
                    border: OutlineInputBorder()),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Color(0xffBABABA))),
                onPressed: () {
                  exit(0);
                },
                child: Text(
                  'Exit',
                  style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff000000).withOpacity(0.7)),
                )),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Color.fromARGB(255, 50, 153, 101))),
                onPressed: () {
                  if (controller.text.trim().isNotEmpty) {
                    ref.read(roomIdProvider.notifier).state =
                        controller.text.trim();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => ChatPage()));
                  } else {}
                },
                child: Text(
                  'Continue',
                  style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff000000).withOpacity(0.7)),
                )),
          ],
        ),
      )),
    );
  }
}

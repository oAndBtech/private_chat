import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:private_chat/components/custom_route.dart';
import 'package:private_chat/providers/room_provider.dart';
import 'package:private_chat/screens/chat_page.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff282C34),
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            elevation: 20,
            backgroundColor: const Color(0xff111216),
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
                  cursorColor: const Color(0xffFFFFFF).withOpacity(0.7),
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        width: 2,
                        color: const Color(0xffFFFFFF).withOpacity(0.7),
                      )),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: const Color.fromARGB(255, 212, 212, 212)
                            .withOpacity(0.7),
                      )),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        color:
                            const Color.fromARGB(255, 212, 212, 212).withOpacity(0.7),
                      ))),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => const Color(0xffBABABA))),
                  onPressed: () {
                    exit(0);
                  },
                  child: Text(
                    'Exit',
                    style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff000000).withOpacity(0.7)),
                  )),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => const Color.fromARGB(255, 50, 153, 101))),
                  onPressed: () {
                    if (controller.text.trim().isNotEmpty) {
                      ref.read(roomIdProvider.notifier).state =
                          controller.text.trim();
                      Navigator.pushReplacement(context,
                          CustomPageRoute(child: const ChatPage()));
                    } else {}
                  },
                  child: Text(
                    'Continue',
                    style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff000000).withOpacity(0.7)),
                  )),
            ],
          ),
        ),
      )),
    );
  }
}

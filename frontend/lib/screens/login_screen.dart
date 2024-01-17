import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:private_chat/components/custom_route.dart';
import 'package:private_chat/providers/room_provider.dart';
import 'package:private_chat/screens/chat_page.dart';
import 'package:private_chat/screens/sign_up_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController controller = TextEditingController();
  bool showError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff282C34),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Stack(
              alignment: Alignment.center,
              children: [
                AlertDialog(
                  elevation: 20,
                  backgroundColor: const Color(0xff111216),
                  title: Text(
                    'Enter your Room ID',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.2,
                      color: const Color(0xffFFFFFF),
                    ),
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
                          color: const Color(0xffFFFFFF),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              showError = false;
                            });
                          }
                        },
                        cursorColor: const Color(0xffFFFFFF).withOpacity(0.7),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: const Color(0xffFFFFFF).withOpacity(0.7),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color.fromARGB(255, 212, 212, 212)
                                  .withOpacity(0.7),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color.fromARGB(255, 212, 212, 212)
                                  .withOpacity(0.7),
                            ),
                          ),
                          errorText: showError
                              ? "Please Enter a valid Room ID!"
                              : null,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 0),
                        alignment: Alignment.topRight,
                        child: RichText(
                          text: TextSpan(
                            text: "Not a user? ",
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.2,
                              color: const Color(0xffFFFFFF),
                            ),
                            children: [
                              TextSpan(
                                  text: "Sign up",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.2,
                                    color:
                                        const Color.fromARGB(255, 14, 153, 245),
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                          context,
                                          CustomPageRoute(
                                              child: const SignUpScreen(),
                                              startPos: const Offset(-1, 0)));
                                    }),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                          (states) => const Color(0xffBABABA),
                        ),
                      ),
                      onPressed: () {
                        exit(0);
                      },
                      child: Text(
                        'Exit',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff000000).withOpacity(0.7),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                          (states) => const Color.fromARGB(255, 50, 153, 101),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          showError = controller.text.trim().isEmpty;
                        });

                        if (!showError) {
                          ref.read(roomIdProvider.notifier).state =
                              controller.text.trim();
                          Navigator.pushReplacement(
                            context,
                            CustomPageRoute(child: const ChatPage()),
                          );
                        }
                      },
                      child: Text(
                        'Continue',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff000000).withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

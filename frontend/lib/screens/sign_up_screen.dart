import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:private_chat/models/add_user_response.dart';
import 'package:private_chat/models/user_model.dart';
import 'package:private_chat/providers/user_provider.dart';
import 'package:private_chat/screens/login_screen.dart';
import 'package:private_chat/services/api_services.dart';
import 'package:private_chat/services/shared_services.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen(
      {
      // required this.controller,
      super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xff282C34),
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            elevation: 20,
            backgroundColor: Color(0xff111216),
            title: Text(
              'Enter your details',
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
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter a valid name!";
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
                      labelText: 'Your name',
                      labelStyle: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xffFFFFFF).withOpacity(0.7)),
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
                            Color.fromARGB(255, 212, 212, 212).withOpacity(0.7),
                      ))),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter a valid phone number!";
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
                        color: const Color(0xffFFFFFF).withOpacity(0.7),
                      )),
                      labelText: 'Phone number',
                      labelStyle: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xffFFFFFF).withOpacity(0.7)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: const Color.fromARGB(255, 212, 212, 212)
                            .withOpacity(0.7),
                      )),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        color:
                            Color.fromARGB(255, 212, 212, 212).withOpacity(0.7),
                      ))),
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
                  onPressed: () async {
                    if (nameController.text.trim().isNotEmpty &&
                        phoneController.text.trim().isNotEmpty) {
                      UserModel user = UserModel(
                          name: nameController.text.trim(),
                          phone: phoneController.text.trim());
                      ResponseData? response = await ApiService().addUser(user);

                      if (response == null) {
                        if (mounted) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Center(
                            child: Text("Something went worng!"),
                          )));
                        }
                      } else {
                        ref
                            .watch(userProvider.notifier)
                            .addUser(response.userModel);
                        SharedService().storeUserId(response.userModel.id);
                        if (response.statusCode == 205) {
                          if (mounted) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                    content: Center(
                              child: Text(
                                  "You are already registered, please join with ROOM ID"),
                            )));
                          }
                        } else {
                          if (mounted) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                    content: Center(
                              child: Text("Successfully Registered!"),
                            )));

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          }
                        }
                      }
                    }
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
        ),
      )),
    );
  }
}

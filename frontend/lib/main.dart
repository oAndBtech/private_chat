import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:private_chat/components/custom_textfield.dart';
import 'package:private_chat/components/sent_message.dart';
import 'package:private_chat/screens/chat_page.dart';

void main() async {
   await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Our Chat App',
      home: Scaffold(body: SafeArea(child: Center(child: ChatPage()))),
    );
  }
}

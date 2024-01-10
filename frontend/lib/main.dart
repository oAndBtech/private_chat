import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat/components/custom_textfield.dart';
import 'package:private_chat/components/sent_message.dart';
import 'package:private_chat/models/user_model.dart';
import 'package:private_chat/providers/room_provider.dart';
import 'package:private_chat/providers/user_provider.dart';
import 'package:private_chat/screens/chat_page.dart';

void main() async {
   await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // This widget is the root of your application.
  addIdsToTheProviders() {
    UserModel user = UserModel(
        name: "bhaskar", phone: "98465", id: 1, fcmtoken: "xdrcvftgy");
    ref.read(userProvider.notifier).addUser(user);
  }

  addRoomId(){
    ref.read(roomProvider.notifier).addRoom("aa45");
  }

  @override
  void initState() {
    super.initState();
    addIdsToTheProviders();
    // addRoomId();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Our Chat App',
      home: Scaffold(body: SafeArea(child: Center(child: ChatPage()))),
    );
  }
}

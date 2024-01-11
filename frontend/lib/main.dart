import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat/models/user_model.dart';
import 'package:private_chat/providers/room_provider.dart';
import 'package:private_chat/providers/user_provider.dart';
import 'package:private_chat/screens/chat_page.dart';
import 'package:private_chat/services/api_services.dart';
import 'firebase_options.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // This widget is the root of your application.
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  addIdsToTheProviders() {
    UserModel user = UserModel(
        name: "bhaskar", phone: "98465", id: 1, fcmtoken: "xdrcvftgy");
    ref.read(userProvider.notifier).addUser(user);
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    addIdsToTheProviders();
    // addRoomId();
    setupFirebase();
    setupFirebaseListeners();
  }

  setupFirebase() async {
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      await sendTokenToServer(token);
    }
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      sendTokenToServer(newToken);
    });
  }

  sendTokenToServer(String token) async {
    int userId = 1; //TODO: get userId
    ApiService().updateFcmToken(token, userId);
  }

  setupFirebaseListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await handleMessage(message);
    });
  }

  handleMessage(RemoteMessage message) async {}

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Our Chat App',
      home: ChatPage(),
    );
  }
}

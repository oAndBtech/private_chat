import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat/models/user_model.dart';
import 'package:private_chat/providers/user_provider.dart';
import 'package:private_chat/screens/chat_page.dart';
import 'package:private_chat/screens/login_screen.dart';
import 'package:private_chat/services/api_services.dart';
import 'firebase_options.dart';

void main() async {
  if (kIsWeb) {
    await dotenv.load(fileName: "env-web");
  } else {
    await dotenv.load(fileName: "env");
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      sound: true,
      provisional: false);
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
        name: "Omkar", phone: "98465", id: 2, fcmtoken: "xdrcvftgy");
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
    if (kIsWeb) {
      final fcmToken = await FirebaseMessaging.instance.getToken(
          vapidKey:
              "BLrhT_yN89tQv7TPDPaurZr6tmwrb1Rs0ckVbNwkTlsAi5S4lUJNkrXXodhCHKucDhjoy70XY0E90k99PeY5LlA");
      if (fcmToken != null) {
        await sendTokenToServer(fcmToken);
      }
      return;
    }

    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      await sendTokenToServer(token);
    }
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      sendTokenToServer(newToken);
    });
  }

  sendTokenToServer(String token) async {
    int userId = 2; //TODO: get userId
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
      home: LoginScreen(),
    );
  }
}

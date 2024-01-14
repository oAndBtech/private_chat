import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat/models/user_model.dart';
import 'package:private_chat/providers/user_provider.dart';
import 'package:private_chat/screens/login_screen.dart';
import 'package:private_chat/screens/sign_up_screen.dart';
import 'package:private_chat/services/api_services.dart';
import 'package:private_chat/services/shared_services.dart';
import 'firebase_options.dart';

void main() async {
  if (kIsWeb) {
    await dotenv.load(fileName: "env");
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
  bool isLoggedin = false;

  addUserToTheProviders(int id) async {
    UserModel? user = await ApiService().getUser(id);
    if (user == null) {
      setState(() {
        isLoggedin = false;
      });
    } else {
      setState(() {
        isLoggedin = true;
      });
      ref.read(userIdProvider.notifier).state = id;
      ref.read(userProvider.notifier).addUser(user);
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    setupFirebaseListeners();
    checkLoginStatus();
  }

  setupFirebaseListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await handleMessage(message);
    });
  }

  handleMessage(RemoteMessage message) async {}

  checkLoginStatus() async {
    int? status = await SharedService().getUserId();
    if (status != null) {
      addUserToTheProviders(status);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Our Chat App',
      home: !isLoggedin ? const SignUpScreen() : const LoginScreen(),
    );
  }
}

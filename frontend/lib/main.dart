import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat/models/user_model.dart';
import 'package:private_chat/providers/user_provider.dart';
import 'package:private_chat/screens/login_screen.dart';
import 'package:private_chat/screens/sign_up_screen.dart';
import 'package:private_chat/services/api_services.dart';
import 'package:private_chat/services/local_notifs.dart';
import 'package:private_chat/services/shared_services.dart';
import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  await dotenv.load(fileName: "env");
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalNotification(flutterLocalNotificationsPlugin)
      .initializeNotifications();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // String title = message.notification?.title ?? "New Message!";
  // String body = message.notification?.body ?? "Someone sent a message";
  // LocalNotification(flutterLocalNotificationsPlugin)
  //     .showNotification(title, body);
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // This widget is the root of your application.
  bool isLoading = true;
  bool isLoggedin = false;
  int status = 0;

  checkStatus() {
    print(status);
    if (status > 1) {
      setState(() {
        isLoading = false;
      });
    }
  }

  addUserToTheProviders(int? id) async {
    if (id == null) {
      setState(() {
        status++;
        checkStatus();
      });
      return;
    }

    UserModel? user = await ApiService().getUser(id);
    if (user == null) {
      setState(() {
        isLoggedin = false;
      });
    } else {
      setState(() {
        isLoggedin = true;
      });
      ref.read(notificationProvider.notifier).state = user.notif ?? true;
      ref.read(userIdProvider.notifier).state = id;
      ref.read(userProvider.notifier).state = user;

      setState(() {
        status++;
        checkStatus();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    setupFirebaseListeners();
    checkLoginStatus();
  }

  setupFirebaseListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await handleMessage(message);
    });
    setState(() {
      status++;
      checkStatus();
    });
  }

  handleMessage(RemoteMessage message) async {}

  checkLoginStatus() async {
    int? id = await SharedService().getUserId();
    await addUserToTheProviders(id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Our Chat App',
      home: isLoading
          ? const Scaffold(
              backgroundColor:Color(0xff111216),
              body: Center(child: CircularProgressIndicator()))
          : !isLoggedin
              ? const SignUpScreen()
              : const LoginScreen(),
    );
  }
}

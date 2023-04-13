import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'package:yiwumart/screens/main_screen.dart';
import 'package:yiwumart/screens/notification_screen.dart';
import 'package:yiwumart/util/constants.dart';
import 'package:yiwumart/util/function_class.dart';
import 'package:yiwumart/util/styles.dart';

GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Permission.notification.request();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    Future.delayed(const Duration(milliseconds: 100)).then((value) => navKey
                .currentState !=
            null
        ? navKey.currentState!.push(
            MaterialPageRoute(builder: (context) => const NotificationScreen()))
        : null);
  }
  await messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification!.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  });
  FirebaseMessaging.onBackgroundMessage(
      (message) => _firebaseMessagingBackgroundHandler(message));

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) async {
    if (navKey.currentState != null) {
      if (Constants.USER_TOKEN.isNotEmpty) {
        navKey.currentState!.push(MaterialPageRoute(
            builder: (context) => const NotificationScreen()));
      }
    }
  });

  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@drawable/ic_notification');
  var initializationSettingsIOS = const DarwinInitializationSettings();
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await messaging.requestPermission();
  if (Platform.isIOS) {
    var APNS = await messaging.getAPNSToken();
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  String? token;

  getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      Constants.USER_TOKEN = pref.getString('login') ?? "";
      if (Constants.USER_TOKEN.isNotEmpty) {
        Constants.bearer = 'Bearer ${pref.getString('login') ?? ""}';
      }
    });
  }

  // For dark theme controller
  Brightness getThemeMode = WidgetsBinding.instance.window.platformBrightness;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {
      getThemeMode = WidgetsBinding.instance.window.platformBrightness;
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await Func.getCookies();
    await getToken();
  }
  @override
  Widget build(BuildContext context) {
    Func().getFirebaseToken();
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return UpgradeAlert(
          upgrader: Upgrader(
            dialogStyle: Platform.isIOS
                ? UpgradeDialogStyle.cupertino
                : UpgradeDialogStyle.material,
            languageCode: 'ru',
          ),
          child: MaterialApp(
            navigatorKey: navKey,
            title: 'YiwuMart',
            debugShowCheckedModeBanner: false,
            theme: getThemeMode == Brightness.light ? lightTheme : darkTheme,
            home: MainScreen(
              key: scakey,
            ),
          ),
        );
      },
    );
  }
}

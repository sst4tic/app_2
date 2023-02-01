import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yiwumart/screens/main_screen.dart';
import 'package:yiwumart/util/constants.dart';
import 'package:yiwumart/util/styles.dart';

GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("NEW FIREBASE MESSAGE on background");
// }

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'High Importance Notifications', // title
//   description: 'This channel is used for important notifications.',
//   // description
//   importance: Importance.high,
// );
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
//
// FirebaseMessaging _messaging = FirebaseMessaging.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Permission.notification.request();


  // RemoteMessage? initialMessage =
  //     await FirebaseMessaging.instance.getInitialMessage();
  // if (initialMessage != null) {
  //   if (navKey.currentState != null) {
  //     print('Message');
  //   }
  // }
  // await _messaging.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   RemoteNotification? notification = message.notification;
  //   AndroidNotification? android = message.notification!.android;
  //   if (notification != null && android != null) {
  //     print('Got a message whilst in the foreground!');
  //     print('Message data: ${message.data}');
  //     flutterLocalNotificationsPlugin.show(
  //       notification.hashCode,
  //       notification.title,
  //       notification.body,
  //       NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           channel.id,
  //           channel.name,
  //           channelDescription: channel.description,
  //           icon: '@mipmap/ic_launcher',
  //         ),
  //       ),
  //     );
  //     if (navKey.currentState != null) {
  //       print('Message');
  //     }
  //   }
  // });
  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
  //   print("On message opened app: $message");
  //   if (navKey.currentState != null) {
  //     print('Message');
  //   }
  // });
  //
  // var initializationSettingsAndroid =
  //     const AndroidInitializationSettings('@drawable/ic_notification');
  //
  // var initializationSettingsIOS = const DarwinInitializationSettings();
  //
  // var initializationSettings = InitializationSettings(
  //     android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  // await _messaging.requestPermission();
  // String? token = await _messaging.getToken();
  // if (token != null) {
  //   print("FIREBASE TOKEN $token");
  // } else {
  //   print("CANNOT TAKE FIREBASE TOKEN");
  // }
  // if (Platform.isIOS) {
  //   var APNS = await _messaging.getAPNSToken();
  //   print(APNS ?? 'null');
  // }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Constants.USER_TOKEN = pref.getString('login') ?? "";
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
    await getToken();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          navigatorKey: navKey,
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: getThemeMode == Brightness.light ? lightTheme : darkTheme,
          home: MainScreen(
            key: scakey,
          ),
        );
      },
    );
  }
}

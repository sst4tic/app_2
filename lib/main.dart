import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yiwumart/bloc/auth_bloc/auth_bloc.dart';
import 'package:yiwumart/bloc/auth_bloc/auth_repo.dart';
import 'package:yiwumart/screens/main_screen.dart';
import 'package:yiwumart/screens/notification_screen.dart';
import 'package:yiwumart/util/constants.dart';
import 'package:yiwumart/util/styles.dart';

GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

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

Brightness getThemeMode = WidgetsBinding.instance.window.platformBrightness;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      Constants.isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
      Constants.isSystemTheme = prefs.getBool('isSystemTheme') ?? false;
      Constants.isLightTheme = prefs.getBool('isNotification') ?? false;
    });
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        setState(() {
          Constants.useragent = androidInfo.model;
        });
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        setState(() {
          Constants.useragent = iosInfo.utsname.machine!;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return BlocProvider(
          create: (context) => AuthBloc(authRepo: AuthRepo()),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is ThemeChanged) {
                Constants.isDarkTheme = state.isDarkTheme;
                Constants.isLightTheme = state.isLightTheme;
                Constants.isSystemTheme = state.isSystemTheme;
              }
              return MaterialApp(
                navigatorKey: navKey,
                title: 'YiwuMart',
                debugShowCheckedModeBanner: false,
                themeMode: Constants.isSystemTheme
                    ? ThemeMode.system
                    : Constants.isDarkTheme
                        ? ThemeMode.dark
                        : ThemeMode.light,
                theme: lightTheme,
                darkTheme: darkTheme,
                home: MainScreen(
                  key: scakey,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

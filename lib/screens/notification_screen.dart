import 'package:flutter/material.dart';

import '../util/styles.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.bodyColor,
      appBar: AppBar(
        title: const Text('Уведомления',
        ),
      ),
      body: const Center(
        child: Text('Уведомления'),
      ),
    );
  }
}

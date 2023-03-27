import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:yiwumart/util/notification.dart';
import '../models/shimmer_model.dart';
import '../util/function_class.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<NotificationClass>> notificationFuture;

  @override
  void initState() {
    super.initState();
    notificationFuture = Func().getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Уведомления',
        ),
      ),
      body: RefreshIndicator(
        color: Theme.of(context).disabledColor,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onRefresh: () async {
          setState(() {
            notificationFuture = Func().getNotifications();
          });
        },
        child: FutureBuilder(
            future: notificationFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return buildNotificationsShimmer();
              } else if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'Нет уведомлений',
                      style: TextStyle(fontSize: 25),
                    ),
                  );
                }
                final not = snapshot.data!;
                return buildNotifications(not);
              } else {
                return const Text("No widget to build");
              }
            }),
      ),
    );
  }

  Widget buildNotifications(List<NotificationClass> notification) =>
      ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: notification.length,
          itemBuilder: (context, index) {
            final notItem = notification[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        notItem.unread
                            ? const Icon(
                                Icons.circle,
                                color: Colors.blue,
                                size: 10,
                              )
                            : const SizedBox(),
                        SizedBox(width: notItem.unread ? 5 : 0),
                        Text(
                          notItem.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(notItem.date,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ExpandableText(
                    notItem.body,
                    expandOnTextTap: true,
                    expandText: '',
                    collapseText: '',
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    collapseOnTextTap: true,
                  ),
                ),
              ),
            );
          });
}

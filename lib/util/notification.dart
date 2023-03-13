class NotificationClass {
final int id;
final String title;
final String body;
final String date;
final bool unread;

  const NotificationClass ({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.unread,
  });
  static NotificationClass fromJson(json) => NotificationClass(
    id: json['id'],
    title: json['title'],
    body: json['body'],
    date: json['date'],
    unread: json['unread'],
  );
}


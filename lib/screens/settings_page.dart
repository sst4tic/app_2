import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:yiwumart/models/profile_item.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<IconData, String> items = {
    LineIcons.key: 'Изменить пароль',
    CupertinoIcons.trash: 'Удалить аккаунт',
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: 2,
          itemBuilder: (context, index) {
        return ProfileModel(icon: items.keys.toList()[index], title: items.values.toList()[index], action: () {}, logout: index == 1,);
      }),
    );
  }
}

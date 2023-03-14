import 'package:flutter/material.dart';
import 'package:yiwumart/authorization/login.dart';
import 'package:yiwumart/screens/profile_screen.dart';

import '../util/constants.dart';

class UserProfileScaffold extends StatefulWidget {
  const UserProfileScaffold({Key? key}) : super(key: key);

  @override
  State<UserProfileScaffold> createState() => _UserProfileScaffoldState();
}

class _UserProfileScaffoldState extends State<UserProfileScaffold> {
  dynamic val;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
      val = Constants.USER_TOKEN;
  }
  @override
  void initState() {
    super.initState();
    val = Constants.USER_TOKEN;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: val != null && val != '' ? const ProfilePage() : const Login(),
    );
  }
}

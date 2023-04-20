import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:yiwumart/catalog_screens/favorite_products.dart';
import 'package:yiwumart/screens/edit_profile.dart';
import 'package:yiwumart/screens/main_screen.dart';
import 'package:yiwumart/screens/purchase_history.dart';
import 'package:http/http.dart' as http;
import 'package:yiwumart/screens/seissions_page.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../models/build_user.dart';
import '../models/shimmer_model.dart';
import '../util/constants.dart';
import '../util/styles.dart';
import '../util/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<User> _future;
  String version = '';

  @override
  void initState() {
    _future = getUser();
    getVersion();
    super.initState();
  }

  static Future<User> getUser() async {
    var url = '${Constants.API_URL_DOMAIN}action=user_profile';
    final response =
        await http.get(Uri.parse(url), headers: Constants.headers());
    final body = jsonDecode(response.body);
    return User.fromJson(body['data']);
  }

  Future<void> refresh() async {
    setState(() {
      _future = getUser();
    });
  }

  void getVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Профиль',
        ),
        centerTitle: false,
      ),
      body: Container(
        padding: REdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: const BorderRadius.all(Radius.circular(12))),
              padding: REdgeInsets.symmetric(horizontal: 10),
              height: 80,
              child: FutureBuilder<User>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return buildProfileShimmer();
                  } else if (snapshot.hasData) {
                    final user = snapshot.data!;
                    return buildUser(user);
                  } else {
                    return const Center(
                      child: Text('Не удалось загрузить пользователя'),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            Text('Активность'.toUpperCase(), style: TextStyles.headerStyle2),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PurchaseHistory()));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12))),
                padding: REdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(
                        Icons.history,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 5.h),
                    Text('История покупок', style: TextStyles.bodyStyle),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 15,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 0,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FavoriteProducts()));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12))),
                padding: REdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 5.h),
                    Text('Избранные товары', style: TextStyles.bodyStyle),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 15,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text('Аккаунт'.toUpperCase(), style: TextStyles.headerStyle2),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditProfile()))
                    .then((value) => refresh());
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12))),
                padding: REdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 5.h),
                    Text('Редактирование', style: TextStyles.bodyStyle),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 15,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 0,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Sessions()));
              },
              child: Container(
                padding: REdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.grey[600],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(
                        Icons.devices,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 5.h),
                    Text('Активные устройства', style: TextStyles.bodyStyle),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 15,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 0,
            ),
            GestureDetector(
              onTap: () {
                scakey.currentState?.updateBadgeCount(0);
                context.read<AuthBloc>().add(LogoutEvent());
              },
              child: Container(
                padding: REdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 5.h),
                    Text('Выйти из аккаунта', style: TextStyles.bodyStyle),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 15,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Center(
              child: Text(
                "Версия приложения $version",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            )
          ],
        ),
      ),
    );
  }
}

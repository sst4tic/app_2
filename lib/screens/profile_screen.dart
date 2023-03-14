import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yiwumart/authorization/login.dart';
import 'package:yiwumart/catalog_screens/favorite_products.dart';
import 'package:yiwumart/screens/edit_profile.dart';
import 'package:yiwumart/screens/purchase_history.dart';
import 'package:http/http.dart' as http;
import '../models/build_user.dart';
import '../models/shimmer_model.dart';
import '../util/constants.dart';
import '../util/function_class.dart';
import '../util/user.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<User> _future;

  @override
  void initState() {
    _future = getUser();
    super.initState();
  }

  static Future<User> getUser() async {
    var url =
        '${Constants.API_URL_DOMAIN}action=user_profile';
    final response = await http.get(Uri.parse(url), headers: {Constants.header: Constants.bearer});
    final body = jsonDecode(response.body);
    return User.fromJson(body['data']);
  }

  Future<void> refresh() async {
    setState(() {
      _future = getUser();
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
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: const BorderRadius.all(Radius.circular(12))),
              padding: const EdgeInsets.only(left: 10, right: 10),
              height: 80,
              child: FutureBuilder<User>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return buildProfileShimmer();
                    // Center(child: CircularProgressIndicator());
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
            Row(
              children: [
                Icon(
                  Icons.local_activity,
                  color: Theme.of(context).primaryColorLight,
                ),
                const SizedBox(width: 10),
                Text(
                  'Активность',
                  style: TextStyle(
                      fontSize: 17,
                      color: Theme.of(context).primaryColorLight,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
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
                padding: const EdgeInsets.only(left: 10, right: 10),
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('История покупок',
                        style: Theme.of(context).textTheme.bodyLarge),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 0,
              thickness: 2,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FavoriteProducts()));
              },
              child: Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12))),
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Избранные товары',
                        style: Theme.of(context).textTheme.bodyLarge),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Theme.of(context).primaryColorLight,
                ),
                const SizedBox(width: 10),
                Text(
                  'Аккаунт',
                  style: TextStyle(
                      fontSize: 17,
                      color: Theme.of(context).primaryColorLight,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
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
                padding: const EdgeInsets.only(left: 10, right: 10),
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Редактирование',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 0,
              thickness: 2,
            ),
            GestureDetector(
              onTap: () async {
                setState(() {
                  Constants.USER_TOKEN = '';
                  Constants.bearer = '';
                });
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.remove('login');
                Func().getFirebaseToken();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Login()),
                    (route) => false);
              },
              child: Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12))),
                height: 60,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Выйти из аккаунта',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.red,
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

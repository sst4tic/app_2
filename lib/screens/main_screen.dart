import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:yiwumart/authorization/login.dart';
import 'package:yiwumart/catalog_screens/favorite_products.dart';
import 'package:yiwumart/screens/profile_screen.dart';
import 'package:yiwumart/screens/purchase_history.dart';
import 'package:yiwumart/util/function_class.dart';
import '../util/constants.dart';
import 'auth_home_screen.dart';
import 'package:yiwumart/screens/shopping_bag.dart';
import 'package:yiwumart/catalog_screens/catalog_screen.dart';

GlobalKey<MainScreenState> scakey = GlobalKey<MainScreenState>();
final tabNavKeys = <GlobalKey<NavigatorState>>[
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
];

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  final myKey = GlobalKey<MainScreenState>();
  int currentIndex = 0;
  final CupertinoTabController _controller = CupertinoTabController();
  int badgeCount = 0;

  void onItemTapped(int index) {
    setState(() {
      currentIndex = index;
      _controller.index = index;
    });
  }

  void updateBadgeCount(int count) {
    setState(() {
      badgeCount = count;
    });
  }

  void showSupport() => Func().showSupport(context);

  void onThirdItemTapped() {
    setState(() {
      currentIndex = 3;
      _controller.index = 3;
    });
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const PurchaseHistory()));
  }

  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    subscription.cancel();
    super.dispose();
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !await tabNavKeys[_controller.index].currentState!.maybePop();
      },
      child: buildTabScaffold(),
    );
  }

  Widget buildTabScaffold() {
    return CupertinoTabScaffold(
        controller: _controller,
        key: myKey,
        tabBar: CupertinoTabBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          activeColor: Theme.of(context).canvasColor,
          inactiveColor: Theme.of(context).disabledColor,
          iconSize: 27,
          currentIndex: currentIndex,
          onTap: onItemTapped,
          items: [
            const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.house),
                activeIcon: Icon(CupertinoIcons.house_fill)),
            const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.square_list),
                activeIcon: Icon(CupertinoIcons.square_list_fill)),
            const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.heart),
                activeIcon: Icon(CupertinoIcons.heart)),
            BottomNavigationBarItem(
              icon: badgeModel(
                  count: badgeCount, icon: const Icon(CupertinoIcons.cart)),
              activeIcon: badgeModel(
                  count: badgeCount,
                  icon: const Icon(CupertinoIcons.cart_fill)),
            ),
            const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person),
                activeIcon: Icon(CupertinoIcons.person_fill)),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              return CupertinoTabView(
                navigatorKey: tabNavKeys[index],
                builder: (BuildContext context) {
                  return const CupertinoPageScaffold(
                      resizeToAvoidBottomInset: false, child: AuthHomePage());
                },
              );
            case 1:
              return CupertinoTabView(
                navigatorKey: tabNavKeys[index],
                builder: (BuildContext context) => const CatalogPage(),
              );
            case 2:
              return currentIndex == 2 ? CupertinoTabView(
                navigatorKey: tabNavKeys[index],
                builder: (BuildContext context) => const FavoriteProducts(),
              ) : Container();
            case 3:
              return currentIndex == 3
                  ? CupertinoTabView(
                      navigatorKey: tabNavKeys[3],
                      builder: (BuildContext context) {
                        return const CupertinoPageScaffold(
                          resizeToAvoidBottomInset: false,
                          child: ShoppingBag(),
                        );
                      },
                    )
                  : Container();
            case 4:
              return CupertinoTabView(
                navigatorKey: tabNavKeys[3],
                builder: (BuildContext context) {
                  return CupertinoPageScaffold(
                    resizeToAvoidBottomInset: false,
                    child: Constants.USER_TOKEN != ''
                        ? const ProfilePage()
                        : const Login(),
                  );
                },
              );
            default:
              return Container();
          }
        });
  }

  Widget badgeModel({required int count, required Icon icon}) {
    return Badge(
      backgroundColor: Theme.of(context).canvasColor,
      alignment: const AlignmentDirectional(2.5, -1),
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
      label: Text(
        count.toString(),
        style:
            const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'Noto Sans',
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
      ),
      isLabelVisible: count == 0 ? false : true,
      child: icon,
    );
  }

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => Platform.isIOS
            ? CupertinoAlertDialog(
                title: const Text('Нет интернет соединения'),
                content: const Text('Пожалуйста проверьте интернет соедниение'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context, 'Cancel');
                      setState(() => isAlertSet = false);
                      isDeviceConnected =
                          await InternetConnectionChecker().hasConnection;
                      if (!isDeviceConnected && isAlertSet == false) {
                        showDialogBox();
                        setState(() => isAlertSet = true);
                      }
                    },
                    child: const Text('Повторить'),
                  ),
                ],
              )
            : AlertDialog(
                title: const Text('Нет интернет соединения'),
                content: const Text('Пожалуйста проверьте интернет соедниение'),
                actions: <Widget>[
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context, 'Cancel');
                        setState(() => isAlertSet = false);
                        isDeviceConnected =
                            await InternetConnectionChecker().hasConnection;
                        if (!isDeviceConnected && isAlertSet == false) {
                          showDialogBox();
                          setState(() => isAlertSet = true);
                        }
                      },
                      child: const Text('Повторить'),
                    ),
                  ]),
      );
}

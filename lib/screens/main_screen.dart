import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:yiwumart/screens/purchase_history.dart';
import 'package:yiwumart/screens/user_profile_scaffold.dart';
import '../util/constants.dart';
import 'auth_home_screen.dart';
import 'home_screen.dart';
import 'package:yiwumart/screens/shopping_bag.dart';
import 'package:yiwumart/catalog_screens/catalog_screen.dart';

GlobalKey<MainScreenState> scakey = GlobalKey<MainScreenState>();
final tabNavKeys = <GlobalKey<NavigatorState>>[
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

  void onItemTapped(int index) {
    setState(() {
      currentIndex = index;
      _controller.index = index;
    });
  }

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
    setState(() {
      Constants.USER_TOKEN;
    });
    return WillPopScope(
      onWillPop: () async {
        return !await tabNavKeys[_controller.index].currentState!.maybePop();
      },
      child: CupertinoTabScaffold(
          controller: _controller,
          key: myKey,
          tabBar: CupertinoTabBar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            activeColor: Theme.of(context).canvasColor,
            inactiveColor: Theme.of(context).disabledColor,
            iconSize: 27,
            currentIndex: currentIndex,
            onTap: onItemTapped,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.house),
                  activeIcon: Icon(CupertinoIcons.house_fill)),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.square_list),
                  activeIcon: Icon(CupertinoIcons.square_list_fill)),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.cart),
                  activeIcon: Icon(CupertinoIcons.cart_fill)),
              BottomNavigationBarItem(
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
                    return CupertinoPageScaffold(
                      resizeToAvoidBottomInset: false,
                      child: Constants.USER_TOKEN != ''
                          ? const AuthHomePage()
                          : const HomePage(),
                    );
                  },
                );
              case 1:
                return CupertinoTabView(
                  navigatorKey: tabNavKeys[index],
                  builder: (BuildContext context) => const CatalogPage(),
                );
              case 2:
                return currentIndex == 2
                    ? CupertinoTabView(
                        navigatorKey: tabNavKeys[2],
                        builder: (BuildContext context) {
                          return const CupertinoPageScaffold(
                            resizeToAvoidBottomInset: false,
                            child: ShoppingBag(),
                          );
                        },
                      )
                    : Container();
              case 3:
                return CupertinoTabView(
                  navigatorKey: tabNavKeys[3],
                  builder: (BuildContext context) {
                    return const CupertinoPageScaffold(
                      resizeToAvoidBottomInset: false,
                      child: UserProfileScaffold(),
                    );
                  },
                );
              default:
                return Container();
            }
          }),
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

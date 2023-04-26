import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yiwumart/bloc/auth_bloc/auth_bloc.dart';
import '../util/styles.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({Key? key}) : super(key: key);

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  bool isSystemTheme = true;
  bool isLightTheme = false;
  bool isDarkTheme = false;
  late SharedPreferences prefs;
  Future getTheme() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isSystemTheme = prefs.getBool('isSystemTheme') ?? true;
      isLightTheme = prefs.getBool('isLightTheme') ?? false;
      isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    });
  }
  @override
  initState() {
    super.initState();
    getTheme();
  }

  Row _buildThemeRow(String themeName, bool isSelected) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 5.h),
        Text(themeName, style: TextStyles.bodyStyle),
        const Spacer(),
        if (isSelected)
          const Icon(
            Icons.check,
            color: Colors.grey,
            size: 15,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Выбор темы'),
        ),
        body: Container(
          width: double.infinity,
          margin: REdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: REdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        setState(() {
                          isSystemTheme = true;
                          isLightTheme = false;
                          isDarkTheme = false;
                        });
                        context.read<AuthBloc>().add(ChangeThemeEvent(isDarkTheme: isDarkTheme, isLightTheme: isLightTheme, isSystemTheme: isSystemTheme));
                      },
                      child: _buildThemeRow('Системная', isSystemTheme),
                    ),
                    const Divider(),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        setState(() {
                          isSystemTheme = false;
                          isLightTheme = true;
                          isDarkTheme = false;
                        });
                        context.read<AuthBloc>().add(ChangeThemeEvent(isDarkTheme: isDarkTheme, isLightTheme: isLightTheme, isSystemTheme: isSystemTheme));
                      },
                      child: _buildThemeRow('Светлая', isLightTheme),
                    ),
                    const Divider(),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        setState(() {
                          isSystemTheme = false;
                          isLightTheme = false;
                          isDarkTheme = true;
                        });
                        context.read<AuthBloc>().add(ChangeThemeEvent(isDarkTheme: isDarkTheme, isLightTheme: isLightTheme, isSystemTheme: isSystemTheme));
                      },
                      child: _buildThemeRow('Темная', isDarkTheme),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'constants.dart';

final darkTheme = ThemeData(
  primaryColor: Colors.black,
  accentColor: ColorStyles.accentColor,
  canvasColor: Colors.white,
  disabledColor: Colors.white,
  primaryColorLight: Colors.white,
  scaffoldBackgroundColor: ColorStyles.bodyColorDark,
  brightness: Brightness.dark,
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    titleTextStyle: const TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
    elevation: Platform.isIOS ? 0 : 1,
    color: ColorStyles.accentColor,
    iconTheme: const IconThemeData(color: ColorStyles.bodyColor),
  ),
  sliderTheme: const SliderThemeData(
    overlayColor: Colors.transparent,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
        color: Colors.white, fontSize: 16),
    bodyMedium: TextStyle(fontSize: 12, color: Colors.white),
    titleMedium: TextStyle(
        fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white),
    // appbar title
    titleSmall: TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
  ),
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.all(Colors.white),
  ),
  fontFamily: 'NotoSans',
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          backgroundColor:
          MaterialStateProperty.all<Color>(ColorStyles.primaryColor))),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.white,
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: ColorStyles.bodyColor,
    labelStyle: TextStyle(
      color: Colors.white,
      fontSize: 16.sp,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white, width: 1),
      borderRadius: BorderRadius.circular(18),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red, width: 1),
      borderRadius: BorderRadius.circular(18),
    ),
  ),
    expansionTileTheme: const ExpansionTileThemeData(
      textColor: Colors.white,
      iconColor: Colors.grey
      // collapsedTextColor: Colors.white
    ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      )),
    ),
  ),
  tabBarTheme: TabBarTheme(
    labelColor: Colors.white,
    unselectedLabelColor: Colors.grey,
    indicator: BoxDecoration(
      borderRadius: const BorderRadius.all(
        Radius.circular(10.0),
      ),
      color: Colors.grey[800]!,
    ),
    labelStyle: const TextStyle(
    ),
  ),
);

final lightTheme = ThemeData(
  primaryColor: Colors.white,
  accentColor: Colors.white,
  canvasColor: const Color.fromRGBO(232, 69, 69, 1),
  disabledColor: ColorStyles.primaryColor,
  primaryColorLight: Colors.black,
  scaffoldBackgroundColor: ColorStyles.bodyColor,
  brightness: Brightness.light,
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: ColorStyles.primaryColor,
  ),
  // iconTheme: const IconThemeData(size: 18),
  appBarTheme: AppBarTheme(
    titleTextStyle: const TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
    elevation: Platform.isIOS ? 0 : 1,
    color: Colors.white,
    iconTheme: const IconThemeData(color: ColorStyles.primaryColor),
  ),
  sliderTheme: const SliderThemeData(
    overlayColor: Colors.transparent,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
        color: Colors.black, fontSize: 16),
    bodyMedium: TextStyle(fontSize: 12, color: Colors.black),
    titleMedium: TextStyle(
        fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black),
    // appbar title
    titleSmall: TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
  ),
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.all(ColorStyles.primaryColor),
  ),
  fontFamily: 'NotoSans',
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          backgroundColor:
          MaterialStateProperty.all<Color>(ColorStyles.primaryColor))),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: ColorStyles.primaryColor
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: ColorStyles.bodyColor,
    labelStyle: TextStyle(
      color: Colors.grey,
      fontSize: 16.sp,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.grey, width: 1),
      borderRadius: BorderRadius.circular(18),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red, width: 1),
      borderRadius: BorderRadius.circular(18),
    ),
  ),
  expansionTileTheme: const ExpansionTileThemeData(
    collapsedTextColor: ColorStyles.primaryColor,
      textColor: ColorStyles.primaryColor,
      iconColor: Colors.grey
    // collapsedTextColor: Colors.white
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(ColorStyles.primaryColor),
      textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      )),
    ),
  ),
  tabBarTheme:  const TabBarTheme(
    labelColor: Colors.white,
    unselectedLabelColor: Colors.grey,
    indicator: BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      ),
      color: ColorStyles.primaryColor,
    ),
  ),
  indicatorColor: Colors.black,
);

class TextStyles {
  static const TextStyle appBarTitle =
  TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
  static TextStyle headerStyle =
  TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[600]!);
  static TextStyle editStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: Colors.grey[600],
  );
}

class ColorStyles {
  static const Color accentColor = Color.fromRGBO(34, 34, 34, 1);
  static const Color bodyColorDark = Color.fromRGBO(20, 20, 20, 1);
  static const Color bodyColor = Color.fromRGBO(245, 248, 250, 1);
  static const Color primaryColor = Color.fromRGBO(43, 46, 74, 1);
  static Color lightShimmerBaseColor = Colors.grey[200]!;
  static Color lightShimmerHighlightColor = Colors.grey[100]!;
  static Color darkShimmerBaseColor = Colors.grey[800]!;
  static Color darkShimmerHighlightColor = Colors.grey[700]!;
}

class BagButtonStyle extends ButtonStyle {
  BagButtonStyle({required BuildContext context,
    required isLoaded,
    required selectedIndex,
     index})
      : super(
      elevation: MaterialStateProperty.all(0),
      fixedSize: MaterialStateProperty.all(Constants.USER_TOKEN != ''
          ? Size(MediaQuery
          .of(context)
          .size
          .width * 0.293, 33)
          : Size(MediaQuery
          .of(context)
          .size
          .width, 33)),
      backgroundColor: MaterialStateProperty.all(
        isLoaded && selectedIndex == index
            ? Colors.green
            : ColorStyles.primaryColor,
      ),
      shape: BorderStyles.buttonBorder);
}

class BagButtonItemStyle extends ButtonStyle {
  BagButtonItemStyle({required BuildContext context,
    required isLoaded,
    index})
      : super(
      elevation: MaterialStateProperty.all(0),
      fixedSize: MaterialStateProperty.all(Size(MediaQuery
          .of(context)
          .size
          .width * 0.43, 33.h)),
      backgroundColor: MaterialStateProperty.all(
        isLoaded
            ? Colors.green
            : ColorStyles.primaryColor,
      ),
      shape: BorderStyles.buttonBorder);
}

class BorderStyles {
  static MaterialStateProperty<OutlinedBorder> buttonBorder =
  MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
  );
}

class GridDelegateClass {
  static SliverGridDelegateWithFixedCrossAxisCount gridDelegate =
  SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 20.w / 30.5.h,
    crossAxisSpacing: 8.8.w,
    mainAxisSpacing: 10.h,
  );
}

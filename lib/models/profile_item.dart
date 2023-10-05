import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yiwumart/models/size_tap_model.dart';

import '../screens/profile_screen.dart';

class ProfileModel extends StatelessWidget {
  ProfileModel(
      {Key? key,
      required this.icon,
      required this.title,
      this.logout = false,
      required this.action})
      : super(key: key);
  final IconData icon;
  final String title;
  bool logout;
  VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return SizeTapAnimation(
      onTap: action,
      child: Container(
        margin: REdgeInsets.only(bottom: 8),
        padding: REdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 24,
                color: logout
                    ? const Color.fromRGBO(241, 0, 46, 1)
                    : const Color.fromRGBO(84, 84, 84, 1)),
            SizedBox(width: 10.w),
            Text(title,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Noto Sans',
                  fontWeight: FontWeight.w600,
                  color: logout ? const Color.fromRGBO(241, 0, 46, 1) : null,
                )),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: Color.fromRGBO(111, 111, 111, 1),
            ),
          ],
        ),
      ),
    );
  }
}

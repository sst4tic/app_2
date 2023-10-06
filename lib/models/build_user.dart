import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiwumart/screens/edit_profile.dart';

Widget buildUser(user) => ListView.builder(
  physics: const NeverScrollableScrollPhysics(),
  itemCount: 1,
  itemBuilder: (context, index) {
    final users = user;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const EditProfile(),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        padding: const EdgeInsets.only(left: 5, right: 5),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Avatar(
              placeholderColors: const [Color.fromRGBO(232, 69, 69, 1)],
              shape: AvatarShape.circle(28),
              name: users.surname != null ? users.fullName : users.fullName.substring(0, 1),
              textStyle: const TextStyle(fontSize: 20, color: Colors.white),
              margin: const EdgeInsets.all(5),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      users.fullName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontFamily: 'Noto Sans',
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    users.phone ?? '',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ]
              ),
            ),
            IconButton(
              padding: const EdgeInsets.all(0),
              alignment: Alignment.centerRight,
              icon: const Icon(FontAwesomeIcons.penToSquare, color: Color.fromRGBO(124, 124, 124, 1), size: 20,),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfile(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  },
);

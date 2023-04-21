import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';

Widget buildUser(user) => ListView.builder(
  physics: const NeverScrollableScrollPhysics(),
  itemCount: 1,
  itemBuilder: (context, index) {
    final users = user;
    return Container(
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
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColorLight,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  users.roleName,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).primaryColorLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  },
);

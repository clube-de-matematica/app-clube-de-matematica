import 'dart:io';

import 'package:flutter/material.dart';

import '../models/userapp.dart';

import 'dart:developer' as dev;

///Um avatar circular com a imágem de perfil de [user].
class Avatar extends StatelessWidget {
  Avatar(
    this.user, {
    Key key,
    this.backgroundColor = Colors.transparent,
    this.radius,
  }) : super(key: key);

  final UserApp user;
  final Color backgroundColor;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: user,
      builder: (_,__) {
        ///O provedor da imágem do usuário;
        ImageProvider image;
dev.debugger();

        if (user.pathAvatar != null) {
          try {
            if (File(user.pathAvatar).existsSync())
dev.debugger();
              image = FileImage(File(user.pathAvatar));
          } catch (_) {
dev.debugger();
            image = null;
          }
        }
dev.debugger();

        if (image == null) image = NetworkImage(user.urlAvatar);

        return CircleAvatar(
          radius: radius,
          backgroundImage: image,
          backgroundColor: backgroundColor,
          child: image != null
              ? null
              : Icon(
                  Icons.person,
                  color: Colors.white.withOpacity(0.75),
                  size: 1.5 * radius,
                ),
        );
      },
    );
  }
}

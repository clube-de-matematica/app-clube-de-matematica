import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/userapp.dart';

///Um avatar circular com a imágem de perfil de [user].
class Avatar extends StatelessWidget {
  Avatar(
    this.user, {
    Key? key,
    this.backgroundColor = Colors.transparent,
    this.radius,
  }) : super(key: key);

  final UserApp user;
  final Color backgroundColor;
  final double? radius;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: user,
      builder: (_, __) {
        ///O provedor da imágem do usuário;
        ImageProvider? image;

        if (user.pathAvatar != null) {
          if (kIsWeb)
            image = NetworkImage(user.pathAvatar!);
          else {
            try {
              if (File(user.pathAvatar!).existsSync())
                image = MemoryImage(File(user.pathAvatar!)
                    .readAsBytesSync()); //FileImage(File(user.pathAvatar));
            } catch (_) {
              image = null;
            }
          }
        }

        if (image == null && user.urlAvatar != null)
          image = NetworkImage(user.urlAvatar!);

        return CircleAvatar(
          radius: radius,
          backgroundImage: image,
          backgroundColor: backgroundColor,
          child: image != null
              ? null
              : Icon(
                  Icons.person,
                  color: Colors.white.withOpacity(0.75),
                  size: 1.5 * (radius ?? 1.0),
                ),
        );
      },
    );
  }
}

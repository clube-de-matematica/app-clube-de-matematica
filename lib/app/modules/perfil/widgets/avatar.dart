import 'dart:io';

import 'package:clubedematematica/app/shared/widgets/myShimmer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/userapp.dart';

///Um avatar circular com a imágem de perfil de [user].
class Avatar extends StatelessWidget {
  const Avatar(
    this.user, {
    Key? key,
    this.backgroundColor, // = Colors.white,//.transparent,
    this.radius,
    this.backgroundImage,
  }) : super(key: key);

  final UserApp user;
  final Color? backgroundColor;
  final double? radius;

  ///A imágem do avatar.
  ///Se fornecido, não será utilizado a imágem de [user].
  final ImageProvider<Object>? backgroundImage;

  ///Retorna o provedor da imágem do avatar.
  ImageProvider? _getImage(UserApp user) {
    if (backgroundImage != null) return backgroundImage;
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

    return image;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: user,
      builder: (_, __) {
        return CircleAvatar(
          radius: radius,
          backgroundColor:
              backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
          child: _buildChild(),
        );
      },
    );
  }

  Widget _buildChild() {
    final provider = _getImage(user);
    late final icon = Icon(
      Icons.person,
      size: 1.5 * (radius ?? 30.0),
    );
    if (provider != null) {
      return ClipOval(
        child: Image(
          image: provider,
          errorBuilder: (_, __, ___) => icon,
          frameBuilder: (_, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) {
              return child;
            } else {
              final size = radius == null ? null : radius! * 2;
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: frame != null
                    ? child
                    : MyShimmer(
                        height: size,
                        width: size,
                      ),
              );
            }
          },
        ),
      );
    } else {
      return icon;
    }
  }
}

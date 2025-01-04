import 'package:cached_network_image/cached_network_image.dart';
import 'package:estilodevida/ui/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: blue,
                width: 5.0,
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              child: CachedNetworkImage(
                imageUrl: user.photoURL!,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(
                  Icons.account_circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ));
  }

  // // Widget para mostrar un ícono predeterminado
  // Widget _defaultIcon() {
  //   return Container(
  //     color: Colors.grey[200],
  //     child: const Icon(
  //       Icons.person,
  //       size: 40.0,
  //       color: Colors.grey,
  //     ),
  //   );
  // }
}

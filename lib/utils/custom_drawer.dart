import 'package:diario_obra/pages/middleware.dart';
import 'package:diario_obra/pages/settings/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_animation_transition/animations/bottom_to_top_transition.dart';
import 'package:page_animation_transition/animations/top_to_bottom_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

import '../pages/user/criar.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  Widget _thumbnailPart() {
    final photoURL = FirebaseAuth.instance.currentUser?.photoURL;

    final imageProvider = photoURL != null
        ? NetworkImage(photoURL)
        : const AssetImage("assets/images/default_profile.png")
            as ImageProvider<Object>?;

    return Row(
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: CircleAvatar(
            backgroundImage: imageProvider,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  FirebaseAuth.instance.currentUser?.displayName
                          ?.split(' ')[0] ??
                      'Erro ao buscar nome',
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
                Text(
                  FirebaseAuth.instance.currentUser?.email ??
                      'Erro ao buscar email.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget get _line => Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      height: 1,
      color: Colors.white.withOpacity(0.2));

  @override
  Widget build(BuildContext context) {
    final firebaseAuth = FirebaseAuth.instance;

    logout() async {
      await firebaseAuth.signOut().then(
            (user) => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ChecagemPage(),
              ),
            ),
          );
      await GoogleSignIn().signOut().then(
            (user) => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ChecagemPage(),
              ),
            ),
          );
    }

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _thumbnailPart(),
            const SizedBox(height: 20),
            _line,
            MenuBox(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
              icon: const Icon(
                Icons.create_new_folder,
                color: Colors.white,
              ),
              menu: const Text(
                "Criar",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(PageAnimationTransition(
                    page: const Criar(),
                    pageAnimationType: TopToBottomTransition()));
              },
            ),
            MenuBox(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              menu: const Text(
                "Configuração",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(PageAnimationTransition(
                    page: const SettingsScreen(),
                    pageAnimationType: BottomToTopTransition()));
              },
            ),
            MenuBox(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              menu: const Text(
                "Sair",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              onTap: logout,
            ),
          ],
        ),
      ),
    );
  }
}

class MenuBox extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final Widget? icon;
  final Widget menu;
  final Function()? onTap;
  const MenuBox({
    Key? key,
    required this.menu,
    this.padding = const EdgeInsets.all(10),
    this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        padding: padding,
        child: Row(
          children: [
            icon != null ? icon! : Container(),
            const SizedBox(width: 15),
            menu,
          ],
        ),
      ),
    );
  }
}

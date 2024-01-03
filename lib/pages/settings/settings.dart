// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api

import 'package:diario_obra/pages/user/about.dart';
import 'package:diario_obra/pages/user/account.dart';
import 'package:diario_obra/pages/user/appearance.dart';
import 'package:diario_obra/pages/user/help.dart';
import 'package:diario_obra/pages/user/user_home.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/left_to_right_faded_transition.dart';
import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart'; 
import 'package:page_animation_transition/page_animation_transition.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
     appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(PageAnimationTransition(
                    page: const UserHome(),
                    pageAnimationType: RightToLeftFadedTransition()));
          },
          icon:  Icon(Icons.arrow_back_rounded, color: Theme.of(context).textTheme.titleLarge!.color),
        ),
        title: Text(
          'Configurações',
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge!.color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Customize as configurações do aplicativo de acordo com suas preferências",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            ItensSettings(context, Icons.person_outline, "Conta", Icons.arrow_forward_ios_rounded, const Account()),
            ItensSettings(context, Icons.remove_red_eye_outlined, "Aparência", Icons.arrow_forward_ios_rounded, const Appearence()),
            ItensSettings(context, Icons.headset_mic_outlined, "Ajuda e Suporte", Icons.arrow_forward_ios_rounded, const Help()),
            ItensSettings(context, Icons.help_outline_rounded, "Sobre", Icons.arrow_forward_ios_rounded, const About()),
          ],
        ),
      ),
    );
  }

  ListTile ItensSettings(BuildContext context, IconData leading, String title, IconData trailing, Widget nextScreen) {
    return ListTile(
            leading: Icon(leading),
            title: Text(title),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            onTap: () {
              Navigator.of(context).push(PageAnimationTransition(
                                page: nextScreen,
                                pageAnimationType:
                                    LeftToRightFadedTransition()));
            },
          );
  }
}

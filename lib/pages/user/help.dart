// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:url_launcher/url_launcher.dart';

import '../settings/settings.dart';

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).push(PageAnimationTransition(
                  page: const SettingsScreen(),
                  pageAnimationType: RightToLeftFadedTransition()));
            },
            icon: Icon(Icons.arrow_back_rounded,
                color: Theme.of(context).textTheme.titleLarge!.color),
          ),
          title: Text(
            'Ajuda e Suporte',
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge!.color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Bem-vindo à nossa Central de Ajuda e Suporte, onde estamos prontos para ajudá-lo em qualquer dúvida ou desafio durante o uso do aplicativo, garantindo sua satisfação com soluções eficazes e informações úteis.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              ItensSettings(
                  context, Icons.phone, 'Contato', '(89) 9 9933-9734'),
              ItensSettings(
                context,
                Icons.email,
                'Email',
                'catce.nogueira@gmail.com',
                isPhone: false,
              ),
              ItensSettings(
                context,
                Icons.question_answer_rounded,
                'Envie seu Feedback',
                'engenhariacertare@gmail.com',
                isPhone: false,
              ),
            ])));
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _sendEmail(String emailAddress) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
    );
    await launchUrl(launchUri);
  }

  ListTile ItensSettings(
      BuildContext context, IconData leading, String title, String contactInfo,
      {bool isPhone = true}) {
    return ListTile(
      leading: Icon(leading),
      title: Text(title),
      onTap: () async {
        if (isPhone) {
          await _makePhoneCall(contactInfo);
        } else {
          await _sendEmail(contactInfo);
        }
      },
    );
  }
}

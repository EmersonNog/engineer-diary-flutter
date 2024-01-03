// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

import '../settings/settings.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  String? label;
  String? creationDate;
  String? photoURL;

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    // Obtém o usuário atualmente autenticado
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Acessa o metadado de criação da conta do usuário
      UserMetadata metadata = user.metadata;
      DateTime? creationDateTime = metadata.creationTime;

      // Obtém a URL da foto do perfil do usuário
      String? userPhotoURL = user.photoURL;

      if (creationDateTime != null) {
        final creationDateTime = DateTime.now();
        final formattedDate =
            DateFormat('MMMM y', 'pt_BR').format(creationDateTime);
        final mesAno =
            '${DateFormat('MMMM', 'pt_BR').format(creationDateTime)[0].toUpperCase()}${DateFormat('MMMM', 'pt_BR').format(creationDateTime).substring(1)} de ${DateFormat('y', 'pt_BR').format(creationDateTime)}';

        setState(() {
          label = "Data de entrada";
          creationDate = mesAno;
          photoURL = userPhotoURL;
        });
      }
    }
  }

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
          'Sobre sua conta',
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge!.color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 25,
            ),
            if (photoURL != null)
              CircleAvatar(
                backgroundImage: NetworkImage(photoURL!),
                radius: 50,
              ),
            const SizedBox(
              height: 10,
            ),
            Text(
              FirebaseAuth.instance.currentUser?.displayName ??
                  'Erro ao buscar nome',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Text(
                'Registre atividades, dados e documentos visuais, crie PDFs automatizados e simplifique a gestão de projetos de construção. Economize tempo, aumente a precisão e entregue projetos de sucesso com a solução da Certare.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            if (creationDate != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    size: 30,
                  ),
                  Column(
                    children: [
                      Text(
                        label ?? 'Erro ao buscar data',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        creationDate ?? 'Erro ao buscar data',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  )
                ],
              )
            else
              const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously, unused_local_variable
import 'package:diario_obra/pages/login.dart';
import 'package:diario_obra/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_animation_transition/animations/left_to_right_faded_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import '../utils/custom_text_button.dart';
import 'user/user_home.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const UserHome(),
        ),
      );
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 54, 127, 89),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/supervisao.png',
                width: 280,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Bem-vindo',
                      style: TextStyle(
                          fontFamily: 'YuseiMagic',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text('Gerencie suas obras com',
                      style: TextStyle(
                          fontFamily: 'YuseiMagic',
                          fontSize: 15,
                          color: Colors.white)),
                  const Text('Agilidade e Intuitividade',
                      style: TextStyle(
                          fontFamily: 'YuseiMagic',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Colors.white)),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextButton(
                    width: MediaQuery.of(context).size.width * 0.9,
                    hasBorder: false,
                    backgroundColor: Colors.white,
                    textColor: const Color.fromARGB(255, 54, 127, 89),
                    icon: FontAwesomeIcons.google,
                    buttonText: "Entrar com Google",
                    onPressed: () {
                      signInWithGoogle();
                    },
                  ),
                  CustomTextButton(
                    width: MediaQuery.of(context).size.width * 0.9,
                    hasBorder: true,
                    borderColor: Colors.white,
                    buttonText: "Criar uma conta",
                    onPressed: () {
                      Navigator.of(context).push(PageAnimationTransition(
                          page: const SignUp(),
                          pageAnimationType: LeftToRightFadedTransition()));
                    },
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(PageAnimationTransition(
                      page: const Login(),
                      pageAnimationType: LeftToRightFadedTransition()));
                },
                child: RichText(
                  text: const TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "Já possuí uma conta? ",
                        style: TextStyle(
                            color: Color.fromARGB(255, 197, 197, 197)),
                      ),
                      TextSpan(
                        text: "Entre",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

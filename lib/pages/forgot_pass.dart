// ignore_for_file: use_build_context_synchronously
import 'package:diario_obra/pages/home.dart';
import 'package:diario_obra/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/fade_animation_transition.dart'; 
import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import '../utils/custom_text_button.dart';
import '../utils/custom_text_field.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _firebaseAuth = FirebaseAuth.instance;
  final _forgotController = TextEditingController();

  Future<void> resetPassword() async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(
        email: _forgotController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email de redefinição de senha enviado com sucesso."),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Verifique o email inserido ou sua conexão."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                alignment: const Alignment(-0.9, 0),
                height: MediaQuery.of(context).size.height * 0.20,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 54, 127, 89),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).push(PageAnimationTransition(
                                page: const Login(),
                                pageAnimationType:
                                    RightToLeftFadedTransition()));
                          },
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            size: 25,
                            color: Colors.white,
                          )),
                      const Text(
                        " Esqueceu senha",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'YuseiMagic',
                            fontSize: 27,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2),
                      ),
                    ],
                  ),
                )),
            Container(
                alignment: const Alignment(-0.7, 0),
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 0.80,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20,),
                      Image.asset(
                        'assets/images/vita_placa.png',
                        width: 250,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Redefine sua senha",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'YuseiMagic'),
                          ),
                          RichText(
                            text: const TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: "Insira seu e-mail de cadastro",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 185, 185, 185),
                                    fontFamily: 'YuseiMagic'),
                              ),
                            ]),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                CustomInputField(label: "Email", controller: _forgotController),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomTextButton(
                            width: MediaQuery.of(context).size.width * 1,
                            buttonText: "Enviar",
                            backgroundColor:
                                const Color.fromARGB(255, 54, 127, 89),
                            onPressed: resetPassword,
                          ),
                          Align(
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(PageAnimationTransition(
                                page: const Home(),
                                pageAnimationType:
                                    FadeAnimationTransition()));
                              },
                              child: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    const TextSpan(
                                      text: "Voltar ao ",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'YuseiMagic'),
                                    ),
                                    TextSpan(
                                      text: "Inicio",
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).textTheme.titleLarge!.color,
                                          fontFamily: 'YuseiMagic'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

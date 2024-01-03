// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:diario_obra/pages/home.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/left_to_right_faded_transition.dart';
import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import '../utils/custom_text_button.dart';
import '../utils/custom_text_field.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _firebaseAuth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  cadastrar() async {
  if (_emailController.text.isEmpty ||
      _userController.text.isEmpty ||
      _passController.text.isEmpty ||
      _confirmPassController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Por favor, preencha todos os campos."),
        backgroundColor: Colors.redAccent,
      ),
    );
    return;
  }

  try {
    UserCredential userCredential =
        await _firebaseAuth.createUserWithEmailAndPassword(
            email: _emailController.text, password: _passController.text);

    if (userCredential != null) {
      userCredential.user?.updateDisplayName(_userController.text);
      // Navigate to the login screen after successful account creation
      Navigator.push(
        context,
        PageAnimationTransition(
          page: const Login(),
          pageAnimationType: LeftToRightFadedTransition(),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Verifique seus dados ou seu acesso à rede."),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 54, 127, 89),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                alignment: const Alignment(-0.9, 0),
                height: MediaQuery.of(context).size.height * 0.20,
                color: const Color.fromARGB(255, 54, 127, 89),
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).push(PageAnimationTransition(
                                page: const Home(),
                                pageAnimationType:
                                    RightToLeftFadedTransition()));
                          },
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            size: 25,
                            color: Colors.white,
                          )),
                      const Text(
                        " Cadastro",
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
                      Image.asset(
                        'assets/images/for_the.png',
                        width: 200,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Junte-se",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'YuseiMagic'),
                          ),
                          RichText(
                            text: const TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: "Cadastre-se para começar!",
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
                                CustomInputField(
                                    label: "Email",
                                    controller: _emailController),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomInputField(
                                    label: "Nome completo",
                                    controller: _userController),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomInputField(
                                    label: "Senha",
                                    isPassword: true,
                                    controller: _passController),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomInputField(
                                    label: "Confirmar senha",
                                    isPassword: true,
                                    controller: _confirmPassController),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextButton(
                            width: MediaQuery.of(context).size.width * 1,
                            buttonText: "Cadastrar",
                            backgroundColor:
                                const Color.fromARGB(255, 54, 127, 89),
                            onPressed: () {
                              cadastrar();
                            },
                          ),
                          Align(
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                    PageAnimationTransition(
                                        page: const Login(),
                                        pageAnimationType:
                                            LeftToRightFadedTransition()));
                              },
                              child: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    const TextSpan(
                                      text: "Já possuí uma conta? ",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'YuseiMagic'),
                                    ),
                                    TextSpan(
                                      text: "Entre",
                                      style: TextStyle(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? const Color.fromARGB(
                                                  255, 54, 127, 89)
                                              : Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .color,
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

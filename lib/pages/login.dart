// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison
import 'package:diario_obra/pages/user/user_home.dart';
import 'package:diario_obra/pages/forgot_pass.dart';
import 'package:diario_obra/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/fade_animation_transition.dart';
import 'package:page_animation_transition/animations/left_to_right_faded_transition.dart';
import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/custom_text_button.dart';
import '../utils/custom_text_field.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _firebaseAuth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool rememberMe = false;

  login() async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passController.text,
      );

      User? user = userCredential.user;

      if (user != null) {
        if (rememberMe) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('email', _emailController.text);
          prefs.setString('password', _passController.text);
        }

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const UserHome()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Usuário não encontrado. Verifique seus dados."),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2),
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
  void initState() {
    super.initState();
    loadSavedCredentials();
  }

  void loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');

    if (savedEmail != null && savedPassword != null) {
      setState(() {
        _emailController.text = savedEmail;
        _passController.text = savedPassword;
        rememberMe = true;
      });
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
                        " Login",
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
                        'assets/images/vita.png',
                        width: 200,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Bem-vindo de Volta",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'YuseiMagic'),
                          ),
                          RichText(
                            text: const TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: "Olá, faça login para continuar!",
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
                                  height: 15,
                                ),
                                CustomInputField(
                                    label: "Senha",
                                    isPassword: true,
                                    controller: _passController),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        PageAnimationTransition(
                                            page: const ForgotPass(),
                                            pageAnimationType:
                                                FadeAnimationTransition()));
                                  },
                                  child: Row(
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: "Esqueceu a senha?",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                              .brightness ==
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
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Checkbox( 
                                      activeColor: const Color.fromARGB(255, 54, 127, 89),
                                      value: rememberMe,
                                      onChanged: (value) {
                                        setState(() {
                                          rememberMe = value!;
                                        });
                                      },
                                    ),
                                    const Text("Lembrar-me"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          CustomTextButton(
                            width: MediaQuery.of(context).size.width * 1,
                            buttonText: "Entrar",
                            backgroundColor:
                                const Color.fromARGB(255, 54, 127, 89),
                            onPressed: () {
                              login();
                            },
                          ),
                          Align(
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                    PageAnimationTransition(
                                        page: const SignUp(),
                                        pageAnimationType:
                                            LeftToRightFadedTransition()));
                              },
                              child: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    const TextSpan(
                                      text: "Não possuí uma conta? ",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'YuseiMagic'),
                                    ),
                                    TextSpan(
                                      text: "Cadastre-se",
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

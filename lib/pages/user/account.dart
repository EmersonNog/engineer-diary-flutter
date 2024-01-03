// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_const_declarations

import 'package:diario_obra/pages/middleware.dart';
import 'package:diario_obra/pages/settings/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  File? _imageFile;
  String? _imageUrl;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firebaseAuth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _loadUserProfileImage();
  }

  Future<void> _loadUserProfileImage() async {
    if (user != null && user!.photoURL != null) {
      setState(() {
        _imageUrl = user!.photoURL;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });

        final Reference storageRef = FirebaseStorage.instance.ref().child(
            'profile_pictures/${FirebaseAuth.instance.currentUser?.uid}');
        await storageRef.putFile(_imageFile!);

        final String downloadURL = await storageRef.getDownloadURL();

        await FirebaseAuth.instance.currentUser?.updatePhotoURL(downloadURL);

        _loadUserProfileImage();
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _resetPassword(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Redefinir senha'),
          content: const Text('Você tem certeza que quer redefinir sua senha?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Voltar'),
            ),
            TextButton(
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "Verifique seu email: ${FirebaseAuth.instance.currentUser?.email}"),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 3),
                ));
                Navigator.of(context).pop();
                try {
                  await _auth.sendPasswordResetEmail(email: user!.email!);
                } catch (e) {
                  print('Error resetting password: $e');
                }
              },
              child: const Text('Sim'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    String? password = '';
    String? confirmPassword = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          title: const Text(
            'Apagar Conta',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.red,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Para apagar sua conta, confirme sua senha abaixo.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Confirme sua senha',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                onChanged: (value) {
                  confirmPassword = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (password == confirmPassword) {
                  try {
                    AuthCredential credential = EmailAuthProvider.credential(
                      email: user!.email!,
                      password: password!,
                    );

                    await user?.reauthenticateWithCredential(credential);
                    await user?.delete();
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChecagemPage(),
                      ),
                    );
                  } catch (e) {
                    print('Error deleting account: $e');
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                      "As senhas não coincidem.",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    backgroundColor: Color.fromARGB(255, 250, 250, 250),
                  ));
                  print('As senhas não coincidem.');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                'Confirmar',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

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

  Future<void> _disconnectGoogleAccount(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final googleProviderId = 'google.com';
        if (user.providerData
            .any((info) => info.providerId == googleProviderId)) {
          final confirmDisconnect = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Desconectar Conta Google'),
                content: const Text(
                    'Você tem certeza que deseja desconectar sua conta Google?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false); // Cancel
                    },
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true); // Confirm
                    },
                    child: const Text('Confirmar'),
                  ),
                ],
              );
            },
          );

          if (confirmDisconnect == true) {
            await user.unlink(googleProviderId);
            await user.delete();
            await GoogleSignIn().signOut();

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text(
                  'Conta do Google desconectada e removida com sucesso.'),
              backgroundColor: Colors.green[300],
              duration: const Duration(seconds: 3),
            ));

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ChecagemPage(),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Sua conta atual não está associada ao Google.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ));
        }
      }
    } catch (e) {
      print('Erro ao desconectar a conta do Google: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Erro ao desconectar a conta do Google.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isGoogleSignIn = false;
    bool isEmailSignIn = false;

    if (user != null) {
      isGoogleSignIn =
          user!.providerData.any((info) => info.providerId == 'google.com');
      isEmailSignIn =
          user!.providerData.any((info) => info.providerId == 'password');
    }
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
          'Minha Conta',
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge!.color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sua conta está sob seu controle total nesta central de contas, permitindo que você faça alterações conforme necessário em seus e-mails, senhas e foto de perfil.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  _imageUrl != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(_imageUrl!),
                          radius: 60,
                        )
                      : const CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.all(12),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text(
                'Redefinir Senha',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              onTap: () {
                _resetPassword(context);
              },
            ),
            if (isEmailSignIn)
              ListTile(
                title: const Text(
                  'Apagar Conta',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  _deleteAccount(context);
                },
              ),
            if (isGoogleSignIn)
              ListTile(
                title: const Text(
                  'Desconectar Conta Google',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  _disconnectGoogleAccount(context);
                },
              ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
            onPressed: () {
              logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(16),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Logout',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            )),
      ),
    );
  }
}

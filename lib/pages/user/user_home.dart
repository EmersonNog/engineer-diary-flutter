import 'dart:io';
import 'package:diario_obra/pages/user/criar.dart';
import 'package:diario_obra/pages/user/file.dart';
import 'package:diario_obra/utils/custom_list_animated.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slide_drawer/flutter_slide_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_animation_transition/animations/fade_animation_transition.dart';
import 'package:page_animation_transition/animations/left_to_right_faded_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import '../../utils/custom_drawer.dart';
import '../../services/weather_api.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  final GlobalKey<SliderDrawerWidgetState> drawerKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? _imageUrl;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firebaseAuth = FirebaseAuth.instance;
  User? user;
  double temperatureCelsius = 0.0;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  User? currentUser = FirebaseAuth.instance.currentUser;

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

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadFile() async {
    if (pickedFile == null) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: const Text('Selecione um arquivo antes de enviar.'),
          backgroundColor: Colors.red[400],
        ),
      );
      return;
    }
    final path = 'files/${currentUser!.uid}/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    if (kDebugMode) {
      print('Download Link: $urlDownload');
    }

    setState(() {
      uploadTask = null;
    });
  }

  Widget buildProgress() {
    if (pickedFile != null && uploadTask != null) {
      return StreamBuilder<TaskSnapshot>(
        stream: uploadTask!.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            double progress = data.bytesTransferred / data.totalBytes;
            if (progress == 1.0) {
              return Container(height: 0);
            }
            return SizedBox(
              height: 40,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey,
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  Center(
                    child: Text(
                      '${(100 * progress).roundToDouble()}%',
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            );
          } else {
            return const SizedBox(
              height: 50,
            );
          }
        },
      );
    } else {
      return const SizedBox(height: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliderDrawerWidget(
      key: drawerKey,
      option: SliderDrawerOption(
        backgroundColor: const Color.fromARGB(255, 121, 120, 193),
        sliderEffectType: SliderEffectType.Rounded,
        upDownScaleAmount: 50,
        radiusAmount: 50,
        direction: SliderDrawerDirection.LTR,
      ),
      drawer: const CustomDrawer(),
      body: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color.fromARGB(255, 83, 81, 212),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: GestureDetector(
            onTap: () {
              drawerKey.currentState!.toggleDrawer();
            },
            child: const Center(
                child: FaIcon(
              FontAwesomeIcons.barsStaggered,
            )),
          ),
          actions: [
            _imageUrl != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(_imageUrl!),
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ],
        ),
        body: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      "Oi ${FirebaseAuth.instance.currentUser?.displayName?.split(" ")[0]}",
                      style: const TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromARGB(255, 134, 133, 206),
                      ),
                      child: TextButton(
                        child: const Text(
                          "Começar",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(PageAnimationTransition(
                              page: const Criar(),
                              pageAnimationType: FadeAnimationTransition()));
                        },
                      ),
                    ),
                  ],
                ),
                FutureBuilder<Map<String, dynamic>>(
                  future: getWeatherData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            CircularProgressIndicator(),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      if (snapshot.error is SocketException) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.signal_wifi_off,
                                color: Colors.white,
                                size: 48,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Sem conexão',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            const Icon(
                              Icons.error,
                              color: Colors.white,
                              size: 48,
                            ),
                            const Text(
                              'Erro ao buscar dados meteorológicos:',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '${snapshot.error}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        );
                      }
                    } else if (snapshot.hasData) {
                      final weatherData = snapshot.data;
                      final temperatureDouble =
                          weatherData!['temperatureCelsius'] as double;
                      final temperature = temperatureDouble.toInt();
                      return Container(
                        width: 100,
                        height: 100,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(360),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$temperature °C',
                              style: const TextStyle(
                                fontSize: 23,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Text(
                        'Não há dados disponíveis',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 134, 133, 206),
                    boxShadow: const [
                      BoxShadow(
                        blurStyle: BlurStyle.inner,
                        color: Colors.white, // Cor da sombra
                        offset: Offset(5, 10),
                        blurRadius: 50.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text('Mantenha-se organizado!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              wordSpacing: 2,
                              color: Color.fromARGB(255, 255, 255, 255))),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromARGB(255, 134, 133, 206),
                            border: Border.all(
                                color:
                                    const Color.fromARGB(255, 202, 202, 202))),
                        child: TextButton(
                          child: const Text(
                            "Lista de Arquivos",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(PageAnimationTransition(
                                page: const FileListScreen(),
                                pageAnimationType:
                                    LeftToRightFadedTransition()));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                RawMaterialButton(
                                  onPressed: selectFile,
                                  elevation: 2.0,
                                  fillColor:
                                      const Color.fromARGB(255, 32, 96, 184),
                                  padding: const EdgeInsets.all(15.0),
                                  shape: const CircleBorder(),
                                  child: const Icon(Icons.ads_click,
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "Selecione",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                RawMaterialButton(
                                  onPressed: uploadFile,
                                  elevation: 2.0,
                                  fillColor:
                                      const Color.fromARGB(255, 32, 96, 184),
                                  padding: const EdgeInsets.all(15.0),
                                  shape: const CircleBorder(),
                                  child: const Icon(Icons.upload_file_rounded,
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "Upload",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: buildProgress(),
            ),
            AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(seconds: 2),
                    childAnimationBuilder: (widget) => SlideAnimation(
                          horizontalOffset: 500.0,
                          curve: Curves.fastEaseInToSlowEaseOut,
                          child: FadeInAnimation(
                            child: widget,
                          ),
                        ),
                    children: [
                      const CustomListAnimated(
                        icon: Icons.info_outline,
                        colorIcon: Color.fromARGB(255, 125, 193, 102),
                        text: "Visualize, compartilhe e controle suas obras.",
                        colorText: Colors.white,
                      ),
                      CustomListAnimated(
                        icon: Icons.lightbulb_outline,
                        colorIcon: Colors.yellow.shade300,
                        text:
                            "Gerenciamento de diário de obras eficiente e fácil.",
                        colorText: Colors.white,
                      ),
                      CustomListAnimated(
                        icon: Icons.security,
                        colorIcon: Colors.deepOrange.shade300,
                        text:
                            "Seus dados com segurança para evitar danos ou perdas.",
                        colorText: Colors.white,
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}

// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api 
import 'package:diario_obra/pages/user/user_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart'; 
import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart'; 
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class FileListScreen extends StatefulWidget {
  const FileListScreen({super.key});

  @override
  _FileListScreenState createState() => _FileListScreenState();
}

class _FileListScreenState extends State<FileListScreen> {
  List<Reference> files = [];
  List<Reference> itemsToRemove = [];
  User? currentUser = FirebaseAuth.instance.currentUser;
  List<String> uploadDates = [];
  bool filesLoaded = false;

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      loadFiles(currentUser!.uid);
    }
  }

  Future<void> loadFiles(String userId) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('files/$userId');
      final items = await storageRef.listAll();

      List<String> formattedDates = [];
      List<Reference> loadedFiles = [];

      for (var item in items.items) {
        final metadata = await item.getMetadata();
        final date = metadata.timeCreated?.toLocal();

        final formattedDate = DateFormat('dd/MM/yyyy').format(date!);

        formattedDates.add(formattedDate);
        loadedFiles.add(item);
      }

      setState(() {
        files = loadedFiles;
        uploadDates = formattedDates;
        filesLoaded = true;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading files: $e');
      }
    }
  }

  void deleteFile(Reference file) async {
    try {
      await file.delete();
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao excluir arquivo: $e');
      }
    }
  }

  void showDeleteConfirmationDialog(BuildContext context, Reference file) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir arquivo'),
          content: Text('Tem certeza de que deseja excluir ${file.name}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                itemsToRemove.remove(file);
                setState(() {
                  files.add(file);
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Excluir'),
              onPressed: () {
                deleteFile(file);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: Text('Seus Arquivos',
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge!.color,
            )),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(PageAnimationTransition(
                page: const UserHome(),
                pageAnimationType: RightToLeftFadedTransition()));
          },
          icon: const Icon(Icons.arrow_back_rounded),
          color: Theme.of(context).textTheme.titleLarge!.color,
        ),
      ),
      body: filesLoaded
          ? files.isEmpty
              ? Center(
                  child: Lottie.asset('assets/images/not_found.json'),
                )
              : AnimationLimiter(
                  child: ListView.builder(
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      final file = files[index];
                      final uploadDate = uploadDates[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          horizontalOffset: 200.0,
                          child: FadeInAnimation(
                            child: Dismissible(
                              key: Key(file.name),
                              onDismissed: (direction) {
                                itemsToRemove.add(file);
                                setState(() {
                                  files.remove(file);
                                });
                                showDeleteConfirmationDialog(context, file);
                              },
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20.0),
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(file.name),
                                      subtitle: Text(uploadDate),
                                      leading: const Icon(
                                          Icons.picture_as_pdf_rounded,
                                          color:
                                              Color.fromARGB(255, 221, 70, 59)),
                                      trailing: IconButton(
                                        onPressed: () async {
                                          final downloadURL =
                                              await file.getDownloadURL();
                                          final uri = Uri.parse(downloadURL);
                                          if (!await launchUrl(uri,
                                              mode: LaunchMode
                                                  .externalApplication)) {
                                            throw Exception(
                                                'Could not launch $downloadURL');
                                          }
                                        },
                                        icon: const Icon(Icons.download,
                                            color: Color.fromARGB(
                                                255, 59, 86, 221)),
                                      ),
                                    ),
                                    const Divider(
                                      color: Colors.black,
                                      height: 5,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
          : Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Container(
                      width: double.infinity,
                      height: 20.0,
                      color: Colors.white,
                    ),
                    subtitle: Container(
                      width: double.infinity,
                      height: 16.0,
                      color: Colors.white,
                    ),
                    leading: Container(
                      width: 40.0,
                      height: 40.0,
                      color: Colors.white,
                    ),
                    trailing: Container(
                      width: 40.0,
                      height: 40.0,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
    );
  }
}

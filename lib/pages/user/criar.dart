// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:io';
import 'package:diario_obra/utils/staff_equipment.dart';
import 'package:diario_obra/utils/custom_button_photo.dart';
import 'package:diario_obra/utils/custom_input_form.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:page_animation_transition/animations/fade_animation_transition.dart';
import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_search_dropdown/simple_search_dropdown.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../utils/status_selector.dart';
import '../../services/weather_api.dart';
import 'user_home.dart';
import 'package:flutter/services.dart' show rootBundle;

class Criar extends StatefulWidget {
  const Criar({Key? key}) : super(key: key);

  @override
  State<Criar> createState() => _CriarState();
}

class _CriarState extends State<Criar> {
  final PageController _pageController = PageController();
  final textStyle = const TextStyle(
      fontSize: 20, wordSpacing: 2, fontWeight: FontWeight.bold);
  final GlobalKey<SearchDropDownState> singleSearchKey = GlobalKey();
  final GlobalKey<SearchDropDownState> singleSearchKey2 = GlobalKey();
  final GlobalKey<SearchDropDownState> singleSearchKey3 = GlobalKey();
  int _currentPageIndex = 0;
  DateTime selectedDate = DateTime.now();
  List<ValueItem> listitems = [
    const ValueItem(
      label: 'Náftaly Emanuel',
      value: 'Náftaly Emanuel',
    ),
    const ValueItem(label: 'Ilanna Mesquita', value: 'Ilanna Mesquita'),
    const ValueItem(label: 'Lailson Lucas', value: 'Lailson Lucas'),
    const ValueItem(label: 'Thiago Monte', value: 'Thiago Monte'),
  ];
  List<ValueItem> listObra = [
    const ValueItem(
        label: 'Marginal Poti Sul - 2ª Etapa',
        value: 'Marginal Poti Sul - 2ª Etapa'),
    const ValueItem(
        label: 'Marginal Poti Sul - 3ª Etapa',
        value: 'Marginal Poti Sul - 3ª Etapa'),
    const ValueItem(
        label: 'Req. Parque Rodoviário', value: 'Req. Parque Rodoviário'),
    const ValueItem(
        label: 'Req. Vila da Paz', value: 'Requalificação Vila da Paz'),
    const ValueItem(
        label: 'Implantação Floresta Fóssil',
        value: 'Implantação Floresta Fóssil'),
    const ValueItem(
        label: 'Req. Mercado São José', value: 'Req. Mercado São José'),
    const ValueItem(
        label: 'Req. Lagoa do Mazerine', value: 'Req. Lagoa do Mazerine'),
    const ValueItem(
        label: 'Revitalização do Centro', value: 'Revitalização do Centro'),
    const ValueItem(
        label: 'Acessibilidade Etapa 01', value: 'Acessibilidade Etapa 01'),
  ];
  List<ValueItem> listFiscal = [
    const ValueItem(label: 'Eneias de Miranda', value: 'Eneias de Miranda'),
    const ValueItem(label: 'Solange Alves', value: 'Solange Alves'),
    const ValueItem(label: 'Fabiano Pereira', value: 'Fabiano Pereira'),
  ];

  ValueItem? selectedSingleItem;
  ValueItem? selectedSingleFiscal;
  ValueItem? selectedSingleObra;
  final _companyController = TextEditingController();
  final _organController = TextEditingController();
  final _fiscalOrganController = TextEditingController();
  String? selectedStatus;
  String status_1 = "";
  String status_2 = "";
  String status_3 = "";
  String status_4 = "";
  String status_5 = "";
  String status_6 = "";
  String status_7 = "";
  String status_8 = "";
  String status_9 = "";
  String status_10 = "";
  final _obsController = TextEditingController();
  List<File> selectedImages = [];
  Map<String, int> selectedIndirectStaff = {};
  Map<String, int> selectedDirectStaff = {};
  Map<String, int> selectedEquipment = {};
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  User? currentUser = FirebaseAuth.instance.currentUser;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    loadListItemsFromSharedPreferences();
    loadFiscalFromSharedPreferences();
    loadObraFromSharedPreferences();
  }

  Future<void> selectImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImages.add(File(pickedFile.path));
      });
    }
  }

  Future<void> takePicture() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        selectedImages.add(File(pickedFile.path));
      });
    }
  }

  Future<void> saveListItemsToSharedPreferences(List<ValueItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final itemsJsonList = items.map((item) => item.toJson(null)).toList();
    await prefs.setStringList('listitems', itemsJsonList);
    loadListItemsFromSharedPreferences();
  }

  Future<void> loadListItemsFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final itemsJsonList = prefs.getStringList('listitems');
    if (itemsJsonList != null) {
      final items = itemsJsonList
          .map((itemJson) => ValueItem.fromJson(itemJson, null))
          .toList();
      setState(() {
        listitems = items;
      });
    }
  }

  void addItem(ValueItem item) {
    setState(() {
      listitems.add(item);
    });

    saveListItemsToSharedPreferences(listitems);
    loadListItemsFromSharedPreferences();
  }

  void removeItem(ValueItem item) {
    setState(() {
      listitems.remove(item);
    });
    saveListItemsToSharedPreferences(listitems);
    loadListItemsFromSharedPreferences();
  }

  void updateSelectedItem(ValueItem? newSelectedItem) {
    selectedSingleItem = newSelectedItem;

    if (newSelectedItem != null) {
      if (!listitems.contains(newSelectedItem)) {
        setState(() {
          listitems.add(newSelectedItem);
        });
        saveListItemsToSharedPreferences(listitems);
        loadListItemsFromSharedPreferences();
      }
    }
  }

  bool verifyInput(ValueItem item) {
    return item.label != 'name';
  }

  Future<void> saveFiscalToSharedPreferences(List<ValueItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final fiscalJsonList = items.map((item) => item.toJson(null)).toList();
    await prefs.setStringList('listFiscal', fiscalJsonList);
    loadFiscalFromSharedPreferences();
  }

  Future<void> loadFiscalFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final fiscalJsonList = prefs.getStringList('listFiscal');
    if (fiscalJsonList != null) {
      final items = fiscalJsonList
          .map((itemJson) => ValueItem.fromJson(itemJson, null))
          .toList();
      setState(() {
        listFiscal = items;
      });
    }
  }

  void removeFiscal(ValueItem item) {
    setState(() {
      listFiscal.remove(item);
    });
    saveFiscalToSharedPreferences(listFiscal);
    loadFiscalFromSharedPreferences();
  }

  void addFiscal(ValueItem item) {
    setState(() {
      listFiscal.add(item);
    });
    saveFiscalToSharedPreferences(listFiscal);
    loadFiscalFromSharedPreferences();
  }

  void updateSelectedFiscal(ValueItem? newSelectedItem) {
    selectedSingleFiscal = newSelectedItem;

    if (newSelectedItem != null) {
      if (!listFiscal.contains(newSelectedItem)) {
        setState(() {
          listFiscal.add(newSelectedItem);
        });
        saveFiscalToSharedPreferences(listFiscal);
      }
    }
    loadFiscalFromSharedPreferences();
  }

  bool verifyInputFiscal(ValueItem item) {
    return item.label != 'name';
  }

  Future<void> saveObraToSharedPreferences(List<ValueItem> items) async {
    final prefsObra = await SharedPreferences.getInstance();
    final obraJsonList = items.map((item) => item.toJson(null)).toList();
    await prefsObra.setStringList('listObra', obraJsonList);
    loadObraFromSharedPreferences();
  }

  Future<void> loadObraFromSharedPreferences() async {
    final prefsObra = await SharedPreferences.getInstance();
    final obraJsonList = prefsObra.getStringList('listObra');
    if (obraJsonList != null) {
      final items = obraJsonList
          .map((itemJson) => ValueItem.fromJson(itemJson, null))
          .toList();
      setState(() {
        listObra = items;
      });
    }
  }

  void addObra(ValueItem item) {
    setState(() {
      listObra.add(item);
    });

    saveObraToSharedPreferences(listObra);
    loadObraFromSharedPreferences();
  }

  void removeObra(ValueItem item) {
    setState(() {
      listObra.remove(item);
    });
    saveObraToSharedPreferences(listObra);
    loadObraFromSharedPreferences();
  }

  void updateSelectedObra(ValueItem? newSelectedObra) {
    selectedSingleObra = newSelectedObra;

    if (newSelectedObra != null) {
      if (!listObra.contains(newSelectedObra)) {
        setState(() {
          listObra.add(newSelectedObra);
        });
        saveObraToSharedPreferences(listObra);
        loadObraFromSharedPreferences();
      }
    }
  }

  bool verifyInputObra(ValueItem item) {
    return item.label != 'name';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<pw.PageTheme> _myPageTheme() async {
    return const pw.PageTheme(
      textDirection: pw.TextDirection.ltr,
      orientation: pw.PageOrientation.portrait,
    );
  }

  Future<void> generatePDF() async {
    final pdf = pw.Document();
    final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
    final formattedDateSave = DateFormat('dd-MM-yyyy').format(selectedDate);
    final weatherData = await getWeatherData();
    final pen = pw.MemoryImage(
      (await rootBundle.load('assets/pdf_images/pen.png')).buffer.asUint8List(),
    );
    final sun = pw.MemoryImage(
      (await rootBundle.load('assets/pdf_images/sun.png')).buffer.asUint8List(),
    );
    final water = pw.MemoryImage(
      (await rootBundle.load('assets/pdf_images/water.png'))
          .buffer
          .asUint8List(),
    );
    final rain = pw.MemoryImage(
      (await rootBundle.load('assets/pdf_images/rain.png'))
          .buffer
          .asUint8List(),
    );
    final footer = pw.MemoryImage(
      (await rootBundle.load('assets/pdf_images/footer.png'))
          .buffer
          .asUint8List(),
    );
    final double heightTitle = MediaQuery.of(context).size.height * 0.15;
    final double heightTime = MediaQuery.of(context).size.height * 0.15;
    final pageTheme = await _myPageTheme();

    // Adicione conteúdo ao PDF aqui
    pdf.addPage(
      pw.MultiPage(
          pageTheme: pageTheme,
          build: (final context) => [
                pw.Padding(
                  padding: const pw.EdgeInsets.only(left: -40, top: -57),
                  child: pw.Column(
                    children: [
                      pw.Row(
                        children: [
                          pw.Container(
                              width: 400,
                              height: heightTitle,
                              color: PdfColor.fromHex('8cb79f'),
                              child: pw.Column(children: [
                                pw.SizedBox(height: 10),
                                pw.Row(children: [
                                  pw.SizedBox(width: 20),
                                  pw.Container(
                                    width: 3,
                                    height: 60,
                                    color: PdfColor.fromHex('dcdddf'),
                                  ),
                                  pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Padding(
                                          padding: const pw.EdgeInsets.only(
                                              left: 5, top: 5),
                                          child: pw.Text("RELATÓRIO",
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                  fontSize: 30)),
                                        ),
                                        pw.Padding(
                                          padding:
                                              const pw.EdgeInsets.only(left: 5),
                                          child: pw.Text("DE DIÁRIO DE OBRA",
                                              style: pw.TextStyle(
                                                  color: PdfColor.fromHex(
                                                      '39815b'),
                                                  fontSize: 30)),
                                        ),
                                      ]),
                                ]),
                                pw.SizedBox(height: 5),
                                pw.Row(
                                  children: [
                                    pw.SizedBox(width: 30),
                                    pw.Column(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.start,
                                        children: [
                                          pw.Text("Obra:",
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                      pw.FontWeight.bold)),
                                          pw.SizedBox(height: 2),
                                          pw.Container(
                                              padding: const pw.EdgeInsets.only(
                                                  left: 1, top: 2),
                                              width: 150,
                                              height: 15,
                                              color: PdfColor.fromHex('dcdddf'),
                                              child: pw.Text(
                                                  ' ${selectedSingleObra?.label}',
                                                  style: const pw.TextStyle(
                                                      fontSize: 10))),
                                        ]),
                                    pw.SizedBox(width: 5),
                                    pw.Column(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.start,
                                        children: [
                                          pw.Text("Data:",
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                      pw.FontWeight.bold)),
                                          pw.SizedBox(height: 2),
                                          pw.Container(
                                              padding: const pw.EdgeInsets.only(
                                                  left: 1, top: 2),
                                              width: 55,
                                              height: 15,
                                              color: PdfColor.fromHex('dcdddf'),
                                              child: pw.Text(formattedDate,
                                                  style: const pw.TextStyle(
                                                      fontSize: 10))),
                                        ]),
                                    pw.SizedBox(width: 5),
                                    pw.Column(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.start,
                                        children: [
                                          pw.Text("Engenheiro Supervisor:",
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                      pw.FontWeight.bold)),
                                          pw.SizedBox(height: 2),
                                          pw.Container(
                                              padding: const pw.EdgeInsets.only(
                                                  left: 1, top: 2),
                                              width: 135,
                                              height: 15,
                                              color: PdfColor.fromHex('dcdddf'),
                                              child: pw.Text(
                                                  ' ${selectedSingleItem?.label}',
                                                  style: const pw.TextStyle(
                                                      fontSize: 10))),
                                        ]),
                                  ],
                                ),
                              ])),
                          pw.Container(
                              width: 162,
                              height: heightTime,
                              color: PdfColor.fromHex('39815b'),
                              child: pw.Stack(
                                children: [
                                  pw.Center(
                                    child: pw.Container(
                                      width: 100,
                                      height: 100,
                                      decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.white, width: 3),
                                      ),
                                      child: pw.Column(
                                        children: [
                                          pw.Container(
                                              width: 100,
                                              height: 60,
                                              child: pw.Column(
                                                  mainAxisAlignment: pw
                                                      .MainAxisAlignment.center,
                                                  children: [
                                                    pw.SizedBox(height: 9),
                                                    pw.Text(
                                                        '${weatherData['weatherCondition']}',
                                                        style: pw.TextStyle(
                                                            color: PdfColor
                                                                .fromHex('fff'),
                                                            fontSize: 10)),
                                                    pw.Text(
                                                        '${weatherData['temperatureCelsius'].toStringAsFixed(2)} °C',
                                                        style: pw.TextStyle(
                                                            color: PdfColor
                                                                .fromHex('fff'),
                                                            fontWeight: pw
                                                                .FontWeight
                                                                .bold))
                                                  ])),
                                          pw.Container(
                                              color: PdfColor.fromHex('fff'),
                                              width: 100,
                                              height: 40,
                                              child: pw.Column(
                                                mainAxisAlignment:
                                                    pw.MainAxisAlignment.center,
                                                children: [
                                                  pw.Text("PLUVIOMETRIA",
                                                      style: pw.TextStyle(
                                                          fontWeight: pw
                                                              .FontWeight.bold,
                                                          fontSize: 10)),
                                                  pw.Row(
                                                      mainAxisAlignment: pw
                                                          .MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        pw.Image(
                                                          water,
                                                          width: 15,
                                                          height: 15,
                                                          fit:
                                                              pw.BoxFit.contain,
                                                        ),
                                                        pw.SizedBox(width: 8),
                                                        pw.Text(
                                                            "${weatherData['rainfall']} mm"),
                                                      ])
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  pw.Positioned(
                                    left: 66,
                                    top: 5,
                                    child: pw.Container(
                                      child: pw.Image(
                                        weatherData['weatherCondition'] ==
                                                'CHUVOSO'
                                            ? rain
                                            : sun,
                                        width: 30,
                                        height: 30,
                                        fit: pw.BoxFit.contain,
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ],
                      ),
                      pw.Column(children: [
                        pw.SizedBox(
                          height: 5,
                        ),
                        pw.Row(
                          children: [
                            pw.Text("FISCAL CERTARE:  "),
                            pw.Container(
                                width: 449,
                                height: 15,
                                color: PdfColor.fromHex('dcdddf'),
                                child: pw.Text(
                                    " ${selectedSingleFiscal?.label ?? ""}")),
                          ],
                        ),
                        pw.SizedBox(
                          height: 5,
                        ),
                        pw.Row(children: [
                          pw.Text("FISCAL DO ÓRGÃO:  "),
                          pw.Container(
                              width: 220,
                              height: 15,
                              color: PdfColor.fromHex('dcdddf'),
                              child:
                                  pw.Text(" ${_fiscalOrganController.text}")),
                          pw.Text("  ÓRGÃO:  "),
                          pw.Container(
                              width: 159,
                              height: 15,
                              color: PdfColor.fromHex('dcdddf'),
                              child: pw.Text(" ${_organController.text}")),
                        ]),
                        pw.SizedBox(
                          height: 5,
                        ),
                        pw.Row(children: [
                          pw.Text("EMPRESA RESPONSÁVEL:  "),
                          pw.Container(
                              width: 400.3,
                              height: 15,
                              color: PdfColor.fromHex('dcdddf'),
                              child: pw.Text(" ${_companyController.text}")),
                        ]),
                        pw.SizedBox(
                          height: 5,
                        ),
                      ]),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(children: [
                            pw.Container(
                              child: pw.Image(pen, width: 30, height: 30),
                            ),
                            pw.SizedBox(width: 5),
                            pw.Container(
                                alignment: pw.Alignment.centerLeft,
                                width: 528,
                                height: 30,
                                color: PdfColor.fromHex('39815b'),
                                child: pw.Text("  OBSERVAÇÕES",
                                    style: pw.TextStyle(
                                        color: PdfColor.fromHex('fff'),
                                        fontSize: 15))),
                          ]),
                          pw.SizedBox(height: 5),
                          pw.Row(children: [
                            pw.Container(
                                width: 562,
                                height: 120,
                                color: PdfColor.fromHex('dcdddf'),
                                child: pw.Padding(
                                    padding: const pw.EdgeInsets.only(top: 5),
                                    child: pw.Padding(
                                      padding:
                                          const pw.EdgeInsets.only(left: 8),
                                      child: pw.Text(_obsController.text),
                                    ))),
                          ])
                        ],
                      ),
                      pw.Column(children: [
                        pw.SizedBox(height: 5),
                        pw.Row(children: [
                          pw.Container(
                            width: 3,
                            height: 30,
                            color: PdfColor.fromHex('dcdddf'),
                          ),
                          pw.Text(" EFETIVOS E EQUIPAMENTOS",
                              style: pw.TextStyle(
                                  color: PdfColor.fromHex('403f44'),
                                  fontSize: 15)),
                        ]),
                        pw.SizedBox(height: 10),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Column(children: [
                              pw.Row(
                                children: [
                                  pw.Text("Efetivos Diretos",
                                      style: const pw.TextStyle(fontSize: 14)),
                                  pw.SizedBox(
                                    width: 35,
                                  ),
                                  pw.Text('Qtnd.',
                                      style: const pw.TextStyle(fontSize: 14)),
                                ],
                              ),
                              pw.Column(
                                children: [
                                  for (var entry in selectedDirectStaff.entries)
                                    pw.Column(
                                      children: [
                                        pw.Row(
                                          children: [
                                            pw.Container(
                                              width: 130,
                                              height: 15,
                                              color: PdfColor.fromHex('dcdddf'),
                                              child: pw.Padding(
                                                padding:
                                                    const pw.EdgeInsets.only(
                                                        left: 5, top: 2),
                                                child: pw.Text(
                                                  entry.key,
                                                  style: const pw.TextStyle(
                                                      fontSize: 9),
                                                ),
                                              ),
                                            ),
                                            pw.SizedBox(width: 5),
                                            pw.Container(
                                              width: 30,
                                              height: 15,
                                              color: PdfColor.fromHex('dcdddf'),
                                              child: pw.Center(
                                                  child: pw.Text(
                                                      entry.value.toString())),
                                            ),
                                          ],
                                        ),
                                        pw.SizedBox(height: 5),
                                      ],
                                    ),
                                  // Fill with empty containers if there are less than 12 items
                                  for (var i = selectedDirectStaff.length;
                                      i < 16;
                                      i++)
                                    pw.Column(
                                      children: [
                                        pw.Row(
                                          children: [
                                            pw.Container(
                                              width: 130,
                                              height: 15,
                                              color: PdfColor.fromHex('dcdddf'),
                                              child: pw.Text(''),
                                            ),
                                            pw.SizedBox(width: 5),
                                            pw.Container(
                                              width: 30,
                                              height: 15,
                                              color: PdfColor.fromHex('dcdddf'),
                                              child: pw.Text(''),
                                            ),
                                          ],
                                        ),
                                        pw.SizedBox(height: 5),
                                      ],
                                    ),
                                ],
                              )
                            ]),
                            pw.SizedBox(width: 5),
                            pw.Column(
                              children: [
                                pw.Row(
                                  children: [
                                    pw.Text("Efetivos Indiretos",
                                        style:
                                            const pw.TextStyle(fontSize: 14)),
                                    pw.SizedBox(
                                      width: 25,
                                    ),
                                    pw.Text('Qtnd.',
                                        style:
                                            const pw.TextStyle(fontSize: 14)),
                                  ],
                                ),
                                pw.Column(
                                  children: [
                                    for (var entry
                                        in selectedIndirectStaff.entries)
                                      pw.Column(
                                        children: [
                                          pw.Row(
                                            children: [
                                              pw.Container(
                                                width: 130,
                                                height: 15,
                                                color:
                                                    PdfColor.fromHex('dcdddf'),
                                                child: pw.Padding(
                                                    padding: const pw
                                                        .EdgeInsets.only(
                                                        left: 5, top: 2),
                                                    child: pw.Text(entry.key,
                                                        style:
                                                            const pw.TextStyle(
                                                                fontSize: 9))),
                                              ),
                                              pw.SizedBox(width: 5),
                                              pw.Container(
                                                width: 30,
                                                height: 15,
                                                color:
                                                    PdfColor.fromHex('dcdddf'),
                                                child: pw.Center(
                                                    child: pw.Text(entry.value
                                                        .toString())),
                                              ),
                                            ],
                                          ),
                                          pw.SizedBox(height: 5),
                                        ],
                                      ),
                                    // Fill with empty containers if there are less than 12 items
                                    for (var i = selectedIndirectStaff.length;
                                        i < 16;
                                        i++)
                                      pw.Column(
                                        children: [
                                          pw.Row(
                                            children: [
                                              pw.Container(
                                                width: 130,
                                                height: 15,
                                                color:
                                                    PdfColor.fromHex('dcdddf'),
                                                child: pw.Text(''),
                                              ),
                                              pw.SizedBox(width: 5),
                                              pw.Container(
                                                width: 30,
                                                height: 15,
                                                color:
                                                    PdfColor.fromHex('dcdddf'),
                                                child: pw.Text(''),
                                              ),
                                            ],
                                          ),
                                          pw.SizedBox(height: 5),
                                        ],
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            pw.SizedBox(width: 5),
                            pw.Column(
                              children: [
                                pw.Row(
                                  children: [
                                    pw.Text("Equipamentos",
                                        style:
                                            const pw.TextStyle(fontSize: 14)),
                                    pw.SizedBox(
                                      width: 45,
                                    ),
                                    pw.Text('Qtnd.',
                                        style:
                                            const pw.TextStyle(fontSize: 14)),
                                  ],
                                ),
                                pw.Column(
                                  children: [
                                    for (var entry in selectedEquipment.entries)
                                      pw.Column(
                                        children: [
                                          pw.Row(
                                            children: [
                                              pw.Container(
                                                width: 130,
                                                height: 15,
                                                color:
                                                    PdfColor.fromHex('dcdddf'),
                                                child: pw.Padding(
                                                    padding: const pw
                                                        .EdgeInsets.only(
                                                        left: 5, top: 2),
                                                    child: pw.Text(entry.key,
                                                        style:
                                                            const pw.TextStyle(
                                                                fontSize: 9))),
                                              ),
                                              pw.SizedBox(width: 5),
                                              pw.Container(
                                                  width: 30,
                                                  height: 15,
                                                  color: PdfColor.fromHex(
                                                      'dcdddf'),
                                                  child: pw.Center(
                                                      child: pw.Text(entry.value
                                                          .toString()))),
                                            ],
                                          ),
                                          pw.SizedBox(height: 5),
                                        ],
                                      ),
                                    // Fill with empty containers if there are less than 12 items
                                    for (var i = selectedEquipment.length;
                                        i < 16;
                                        i++)
                                      pw.Column(
                                        children: [
                                          pw.Row(
                                            children: [
                                              pw.Container(
                                                width: 130,
                                                height: 15,
                                                color:
                                                    PdfColor.fromHex('dcdddf'),
                                                child: pw.Text(''),
                                              ),
                                              pw.SizedBox(width: 5),
                                              pw.Container(
                                                width: 30,
                                                height: 15,
                                                color:
                                                    PdfColor.fromHex('dcdddf'),
                                                child: pw.Text(''),
                                              ),
                                            ],
                                          ),
                                          pw.SizedBox(height: 5),
                                        ],
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(right: 10),
                          child: pw.Container(
                            width: 510,
                            height: 2,
                            color: PdfColor.fromHex('dcdddf'),
                          ),
                        )
                      ]),
                    ],
                  ),
                )
              ],
          footer: (context) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: -30, left: -15),
                child: pw.Row(children: [
                  pw.Image(
                    footer,
                    width: 500,
                    fit: pw.BoxFit.contain,
                  ),
                ]),
              )),
    );

    final selectedImagesPairs = <List<File>>[];
    for (int i = 0; i < selectedImages.length; i += 7) {
      final endIndex =
          (i + 7 < selectedImages.length) ? i + 7 : selectedImages.length;
      final pair = selectedImages.sublist(i, endIndex);
      selectedImagesPairs.add(pair);
    }

    final anoAtual = DateFormat('yyyy').format(DateTime.now());

    for (int i = 0; i < selectedImages.length; i += 2) {
      pdf.addPage(
        pw.MultiPage(
            build: (final context) => [
                  pw.Container(
                      child: pw.Column(children: [
                    pw.Row(children: [
                      pw.Container(
                        width: 3,
                        height: 30,
                        color: PdfColor.fromHex('dcdddf'),
                      ),
                      pw.Text(" FOTOS",
                          style: pw.TextStyle(
                              color: PdfColor.fromHex('403f44'), fontSize: 15)),
                    ]),
                    pw.Center(
                      child: pw.Column(
                        children: [
                          for (int j = 0;
                              j < 2 && i + j < selectedImages.length;
                              j++)
                            pw.Column(
                              children: [
                                pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.start,
                                    children: [
                                      pw.Text(getStatusLabel(i + j + 1)),
                                    ]),
                                pw.Image(
                                    pw.MemoryImage(Uint8List.fromList(
                                        selectedImages[i + j]
                                            .readAsBytesSync())),
                                    width: 350,
                                    height: 1350),
                                pw.SizedBox(height: 5),
                                pw.Text(
                                    "Fonte: Acervo Consórcio Certare - Assist, $anoAtual."),
                                pw.SizedBox(height: 15),
                              ],
                            ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(right: 10),
                            child: pw.Container(
                              alignment: pw.Alignment.bottomCenter,
                              width: 700,
                              height: 2,
                              color: PdfColor.fromHex('dcdddf'),
                            ),
                          )
                        ],
                      ),
                    )
                  ]))
                ],
            footer: (context) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: -30, left: -15),
                  child: pw.Row(children: [
                    pw.Image(
                      footer,
                      width: 500,
                      fit: pw.BoxFit.contain,
                    ),
                  ]),
                )),
      );
    }

    final directory = await getExternalStorageDirectory(); 
    final file = File(
        '${directory!.path}/relatorio_${formattedDateSave}_${selectedSingleObra?.label ?? 'Nenhuma Obra Informada'}.pdf');

    await file.writeAsBytes(await pdf.save());

    OpenFile.open(file.path);
  }

  String getStatusLabel(int index) {
    switch (index) {
      case 1:
        return status_1;
      case 2:
        return status_2;
      case 3:
        return status_3;
      case 4:
        return status_4;
      case 5:
        return status_5;
      case 6:
        return status_6;
      case 7:
        return status_7;
      case 8:
        return status_8;
      case 9:
        return status_9;
      case 10:
        return status_10;
      default:
        return 'Unknown Status';
    }
  }

  String _getTitleForPageIndex(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return "Relatório";
      case 1:
        return selectedSingleObra?.label.toUpperCase() ??
            "Nenhuma Obra Selecionada";
      case 2:
        return 'Efetivos e Equipamentos';
      case 3:
        return 'Cadastrar serviços';
      case 4:
        return 'Observações';
      case 5:
        return 'Finalizar';
      default:
        return 'Relatório';
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

  bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  MaterialStateColor getButtonBackgroundColor(BuildContext context) {
    if (isDarkMode(context)) {
      return MaterialStateColor.resolveWith((states) => Colors.grey.shade800);
    } else {
      return MaterialStateColor.resolveWith(
          (states) => const Color.fromARGB(187, 35, 72, 222));
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('d/M/y').format(selectedDate);
    bool showFloatingButton = _currentPageIndex < 5;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(PageAnimationTransition(
                page: const UserHome(),
                pageAnimationType: RightToLeftFadedTransition()));
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Theme.of(context).textTheme.titleLarge!.color,
          ),
        ),
        title: Text(
          _getTitleForPageIndex(_currentPageIndex),
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge!.color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              children: [
                SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(children: [
                            SearchDropDown(
                              dropdownwidth:
                                  MediaQuery.of(context).size.width * 0.8,
                              key: singleSearchKey,
                              elevation: 12,
                              hint: "Selecione/Crie um Engenheiro(a) Superv.",
                              hintStyle: TextStyle(
                                color: isDarkMode(context)
                                    ? Colors.grey
                                    : Colors.grey[500],
                              ),
                              backgroundColor: isDarkMode(context)
                                  ? Colors.grey[800]
                                  : const Color.fromARGB(255, 247, 247, 247),
                              dialogBackgroundColor: isDarkMode(context)
                                  ? Colors.grey[400]
                                  : const Color.fromARGB(255, 247, 247, 247),
                              listItems: listitems,
                              confirmDelete: true,
                              onDeleteItem: removeItem,
                              onAddItem: addItem,
                              addMode: true,
                              deleteMode: true,
                              updateSelectedItem: updateSelectedItem,
                              verifyInputItem: verifyInput,
                              newValueItem: (input) =>
                                  ValueItem(label: input, value: input),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            SearchDropDown(
                              dropdownwidth:
                                  MediaQuery.of(context).size.width * 0.8,
                              key: singleSearchKey3,
                              elevation: 12,
                              hint: "Selecione/Crie uma Obra",
                              hintStyle: TextStyle(
                                color: isDarkMode(context)
                                    ? Colors.grey
                                    : Colors.grey[500],
                              ),
                              backgroundColor: isDarkMode(context)
                                  ? Colors.grey[800]
                                  : const Color.fromARGB(255, 247, 247, 247),
                              dialogBackgroundColor: isDarkMode(context)
                                  ? Colors.grey[400]
                                  : const Color.fromARGB(255, 247, 247, 247),
                              listItems: listObra,
                              confirmDelete: true,
                              onDeleteItem: removeObra,
                              onAddItem: addObra,
                              addMode: true,
                              deleteMode: true,
                              updateSelectedItem: updateSelectedObra,
                              verifyInputItem: verifyInputObra,
                              newValueItem: (input) =>
                                  ValueItem(label: input, value: input),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    getButtonBackgroundColor(context),
                              ),
                              onPressed: () => _selectDate(context),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.date_range_rounded),
                                        Text("  Selecione a data"),
                                      ],
                                    ),
                                    Text(formattedDate),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            FutureBuilder<Map<String, dynamic>>(
                              future: getWeatherData(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
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
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.signal_wifi_off,
                                            color: isDarkMode(context)
                                                ? Colors.grey[700]
                                                : Colors.grey[700],
                                            size: 48,
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
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
                                          color: Colors.black,
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

                                  IconData weatherIcon;
                                  if (weatherData!['weatherCondition'] ==
                                      'CHUVOSO') {
                                    weatherIcon =
                                        FontAwesomeIcons.cloudShowersHeavy;
                                  } else {
                                    weatherIcon = FontAwesomeIcons.cloudSun;
                                  }

                                  final temperatureDouble =
                                      weatherData['temperatureCelsius']
                                          as double;
                                  final temperature = temperatureDouble.toInt();

                                  return Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                        color:
                                            getButtonBackgroundColor(context),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          weatherIcon,
                                          size: 37,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(height: 15),
                                        Text(
                                          'Condição do Clima: ${weatherData['weatherCondition']}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          'Pluviometria: ${weatherData['rainfall']} mm',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          'Temperatura: $temperature °C',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return const Text(
                                    'Nenhum dado disponível.',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  );
                                }
                              },
                            ),
                          ]),
                        )
                      ]),
                ),
                SingleChildScrollView(
                  child: Column(children: [
                    CustomInputForm(
                        prefixIcon: const Icon(Icons.account_balance_sharp),
                        controller: _companyController,
                        labelText: "Empresa Responsável"),
                    CustomInputForm(
                        prefixIcon: const Icon(Icons.fact_check),
                        controller: _organController,
                        labelText: "Órgão"),
                    CustomInputForm(
                        prefixIcon: const Icon(Icons.paste_sharp),
                        controller: _fiscalOrganController,
                        labelText: "Fiscal do Órgão"),
                    SizedBox(
                      width: 350,
                      child: SearchDropDown(
                        dropdownwidth: MediaQuery.of(context).size.width * 0.8,
                        key: singleSearchKey2,
                        dropdownHeight: 60,
                        elevation: 6,
                        hint: "Selecione ou Crie um Fiscal da Certare",
                        hintStyle: TextStyle(
                          color: isDarkMode(context)
                              ? Colors.grey
                              : Colors.grey[500],
                        ),
                        backgroundColor: isDarkMode(context)
                            ? Colors.grey[800]
                            : const Color.fromARGB(255, 247, 247, 247),
                        dialogBackgroundColor: isDarkMode(context)
                            ? Colors.grey[400]
                            : const Color.fromARGB(255, 247, 247, 247),
                        listItems: listFiscal,
                        confirmDelete: true,
                        onDeleteItem: removeFiscal,
                        onAddItem: addFiscal,
                        addMode: true,
                        deleteMode: true,
                        updateSelectedItem: updateSelectedFiscal,
                        verifyInputItem: verifyInputFiscal,
                        newValueItem: (input) =>
                            ValueItem(label: input, value: input),
                      ),
                    ),
                  ]),
                ),
                SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(children: [
                    StaffEquipment(
                      title: "Efetivo Indireto",
                      selectedItems: selectedIndirectStaff,
                      predefinedItems: const [
                        'ALMOXARIFE',
                        'ADMINISTRADOR',
                        'ASSISTENTE ADM',
                        'TEC. SEG. TRABALHO',
                        'ENG. CIVIL',
                        'ESTAGIÁRIO',
                        'TEC. EDIFICAÇÃO',
                        'TOPOGRÁFO',
                        'AUX. TOPOGRAFIA',
                        'VIGIA',
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    StaffEquipment(
                      title: "Efetivo Direto",
                      selectedItems: selectedDirectStaff,
                      predefinedItems: const [
                        'AUX. FERREIRO',
                        'AUX. BOMBEIRO',
                        'AUX. PINTOR',
                        'BOMBEIRO HIDR.',
                        'ENG. AMBIENTAL',
                        'ARQUEÓLOGO',
                        'CARPINTEIRO',
                        'ELETRICISTA',
                        'APONTADOR',
                        'ENCARREGADO',
                        'MESTRE DE OBRAS',
                        'MOTORISTA (PIPA)',
                        'OP. ESCAV. HIDR.',
                        'OP. RETROESCAV.',
                        'OP. POLITRIZ',
                        'OP. AUTO BETON.',
                        'OP. BOB CAT',
                        'OP. MOTONIVELADORA',
                        'OP. ROLO COMPACTADOR',
                        'AUX. SERV. GERAIS',
                        'PEDREIRO',
                        'SERVENTE',
                        'SERRALHEIRO',
                        'AUX. ELETRICISTA',
                        'MOT. BASCULANTE',
                        'MECÂNICO',
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    StaffEquipment(
                      title: "Equipamentos",
                      selectedItems: selectedEquipment,
                      predefinedItems: const [
                        'AUTO BETONEIRA',
                        'RETROESCAVADEIRA',
                        'ROLO COMPAC. LISO',
                        'MOTO NIVELADORA',
                        'CAMINHÃO MUNCK',
                        'ESCAVADEIRA HIDR.',
                        'CAMINHÃO PIPA',
                        'EMPILHADEIRA',
                        'BETONEIRA',
                        'BOBCAT',
                        'ROLO PARA VALAS',
                        'CAMINHÃO BASC.',
                        'MELOSA',
                        'TRATOR AGRICOLA',
                        'R. PÉ DE CARNEIRO',
                        'PLATAFORMA ELEVATÓRIA',
                      ],
                    ),
                  ]),
                )),
                SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        StatusSelector(
                          initialStatus: selectedStatus,
                          onChanged: (newDescription) {
                            setState(() {
                              status_1 = newDescription;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            CustomIconButton(
                              onPressed: selectImage,
                              icon: Icons.photo_library_outlined,
                              defaultIconColor: selectedImages.isNotEmpty
                                  ? Colors.green
                                  : isDarkMode(context)
                                      ? Colors.white70
                                      : Colors.black,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            CustomIconButton(
                              onPressed: takePicture,
                              icon: Icons.photo_camera_outlined,
                              defaultIconColor: selectedImages.isNotEmpty
                                  ? Colors.green
                                  : isDarkMode(context)
                                      ? Colors.white70
                                      : Colors.black,
                            ),
                          ],
                        ),
                        const Divider(height: 15, thickness: 1),
                        StatusSelector(
                          initialStatus: selectedStatus,
                          onChanged: (newDescription) {
                            setState(() {
                              status_2 = newDescription;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            CustomIconButton(
                              onPressed: selectImage,
                              icon: Icons.photo_library_outlined,
                              defaultIconColor: selectedImages.isNotEmpty
                                  ? Colors.green
                                  : isDarkMode(context)
                                      ? Colors.white70
                                      : Colors.black,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            CustomIconButton(
                              onPressed: takePicture,
                              icon: Icons.photo_camera_outlined,
                              defaultIconColor: selectedImages.isNotEmpty
                                  ? Colors.green
                                  : isDarkMode(context)
                                      ? Colors.white70
                                      : Colors.black,
                            ),
                          ],
                        ),
                        const Divider(height: 15, thickness: 1),
                        StatusSelector(
                          initialStatus: selectedStatus,
                          onChanged: (newDescription) {
                            setState(() {
                              status_3 = newDescription;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            CustomIconButton(
                              onPressed: selectImage,
                              icon: Icons.photo_library_outlined,
                              defaultIconColor: selectedImages.isNotEmpty
                                  ? Colors.green
                                  : isDarkMode(context)
                                      ? Colors.white70
                                      : Colors.black,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            CustomIconButton(
                              onPressed: takePicture,
                              icon: Icons.photo_camera_outlined,
                              defaultIconColor: selectedImages.isNotEmpty
                                  ? Colors.green
                                  : isDarkMode(context)
                                      ? Colors.white70
                                      : Colors.black,
                            ),
                          ],
                        ),
                        const Divider(height: 15, thickness: 1),
                        StatusSelector(
                          initialStatus: selectedStatus,
                          onChanged: (newDescription) {
                            setState(() {
                              status_4 = newDescription;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            CustomIconButton(
                              onPressed: selectImage,
                              icon: Icons.photo_library_outlined,
                              defaultIconColor: selectedImages.isNotEmpty
                                  ? Colors.green
                                  : isDarkMode(context)
                                      ? Colors.white70
                                      : Colors.black,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            CustomIconButton(
                              onPressed: takePicture,
                              icon: Icons.photo_camera_outlined,
                              defaultIconColor: selectedImages.isNotEmpty
                                  ? Colors.green
                                  : isDarkMode(context)
                                      ? Colors.white70
                                      : Colors.black,
                            ),
                          ],
                        ),
                        const Divider(height: 15, thickness: 1),
                        StatusSelector(
                          initialStatus: selectedStatus,
                          onChanged: (newDescription) {
                            setState(() {
                              status_5 = newDescription;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            CustomIconButton(
                              onPressed: selectImage,
                              icon: Icons.photo_library_outlined,
                              defaultIconColor: selectedImages.isNotEmpty
                                  ? Colors.green
                                  : isDarkMode(context)
                                      ? Colors.white70
                                      : Colors.black,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            CustomIconButton(
                              onPressed: takePicture,
                              icon: Icons.photo_camera_outlined,
                              defaultIconColor: selectedImages.isNotEmpty
                                  ? Colors.green
                                  : isDarkMode(context)
                                      ? Colors.white70
                                      : Colors.black,
                            ),
                          ],
                        ),
                        const Divider(height: 15, thickness: 1),
                        StatusSelector(
                          initialStatus: selectedStatus,
                          onChanged: (newDescription) {
                            setState(() {
                              status_6 = newDescription;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            CustomIconButton(
                              onPressed: selectImage,
                              icon: Icons.photo_library_outlined,
                              defaultIconColor: selectedImages.isNotEmpty
                                  ? Colors.green
                                  : isDarkMode(context)
                                      ? Colors.white70
                                      : Colors.black,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            CustomIconButton(
                              onPressed: takePicture,
                              icon: Icons.photo_camera_outlined,
                              defaultIconColor: selectedImages.isNotEmpty
                                  ? Colors.green
                                  : isDarkMode(context)
                                      ? Colors.white70
                                      : Colors.black,
                            ),
                          ],
                        ),
                        const Divider(height: 15, thickness: 1),
                        StatusSelector(
                          initialStatus: selectedStatus,
                          onChanged: (newDescription) {
                            setState(() {
                              status_7 = newDescription;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            CustomIconButton(
                              onPressed: selectImage,
                              icon: Icons.photo_library_outlined,
                              defaultIconColor: selectedImages.isNotEmpty
                                  ? Colors.green
                                  : isDarkMode(context)
                                      ? Colors.white70
                                      : Colors.black,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            CustomIconButton(
                              onPressed: takePicture,
                              icon: Icons.photo_camera_outlined,
                              defaultIconColor: selectedImages.isNotEmpty
                                  ? Colors.green
                                  : isDarkMode(context)
                                      ? Colors.white70
                                      : Colors.black,
                            ),
                          ],
                        ),
                        const Divider(height: 15, thickness: 1),
                        StatusSelector(
                          initialStatus: selectedStatus,
                          onChanged: (newDescription) {
                            setState(() {
                              status_8 = newDescription;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            CustomIconButton(
                              onPressed: selectImage,
                              icon: Icons.photo_library_outlined,
                              defaultIconColor: selectedImages.isNotEmpty
                                  ? Colors.green
                                  : isDarkMode(context)
                                      ? Colors.white70
                                      : Colors.black,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            CustomIconButton(
                              onPressed: takePicture,
                              icon: Icons.photo_camera_outlined,
                              defaultIconColor: selectedImages.isNotEmpty
                                  ? Colors.green
                                  : isDarkMode(context)
                                      ? Colors.white70
                                      : Colors.black,
                            ),
                          ],
                        ),
                        const Divider(height: 15, thickness: 1),
                        StatusSelector(
                          initialStatus: selectedStatus,
                          onChanged: (newDescription) {
                            setState(() {
                              status_9 = newDescription;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            CustomIconButton(
                              onPressed: selectImage,
                              icon: Icons.photo_library_outlined,
                              defaultIconColor: selectedImages.isNotEmpty
                                  ? Colors.green
                                  : isDarkMode(context)
                                      ? Colors.white70
                                      : Colors.black,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            CustomIconButton(
                              onPressed: takePicture,
                              icon: Icons.photo_camera_outlined,
                              defaultIconColor: selectedImages.isNotEmpty
                                  ? Colors.green
                                  : isDarkMode(context)
                                      ? Colors.white70
                                      : Colors.black,
                            ),
                          ],
                        ),
                        const Divider(height: 15, thickness: 1),
                        StatusSelector(
                          initialStatus: selectedStatus,
                          onChanged: (newDescription) {
                            setState(() {
                              status_10 = newDescription;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            CustomIconButton(
                              onPressed: selectImage,
                              icon: Icons.photo_library_outlined,
                              defaultIconColor: selectedImages.isNotEmpty
                                  ? Colors.green
                                  : isDarkMode(context)
                                      ? Colors.white70
                                      : Colors.black,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            CustomIconButton(
                              onPressed: takePicture,
                              icon: Icons.photo_camera_outlined,
                              defaultIconColor: selectedImages.isNotEmpty
                                  ? Colors.green
                                  : isDarkMode(context)
                                      ? Colors.white70
                                      : Colors.black,
                            ),
                          ],
                        ),
                      ]),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        "OBSERVAÇÕES DA SUPERVISORA",
                        style: textStyle,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDarkMode(context)
                                ? Colors.white54
                                : Colors.black87,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: _obsController,
                          maxLines: 15,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(20)),
                        ),
                      )
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Relatório Finalizado!",
                        style: TextStyle(fontSize: 25),
                      ),
                      const Text(
                        "Visualize, crie novos relatórios ou compartilhe com terceiros.",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              RawMaterialButton(
                                onPressed: () async { 
                                  final formattedDateSave = DateFormat('dd-MM-yyyy').format(selectedDate);
                                  final directory =
                                      await getExternalStorageDirectory();
                                  final filePath =
                                      '${directory!.path}/relatorio_${formattedDateSave}_${selectedSingleObra?.label ?? 'Nenhuma Obra Informada'}.pdf';
                                  Share.shareFiles([filePath],
                                      text: 'Confira este relatório');
                                },
                                elevation: 2.0,
                                fillColor:
                                    const Color.fromARGB(255, 32, 96, 184),
                                padding: const EdgeInsets.all(15.0),
                                shape: const CircleBorder(),
                                child: const FaIcon(FontAwesomeIcons.share,
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text("Compartilhe"),
                            ],
                          ),
                          Column(
                            children: [
                              RawMaterialButton(
                                onPressed: generatePDF,
                                elevation: 2.0,
                                fillColor:
                                    const Color.fromARGB(255, 32, 96, 184),
                                padding: const EdgeInsets.all(15.0),
                                shape: const CircleBorder(),
                                child: const Icon(Icons.picture_as_pdf,
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text("Visualize"),
                            ],
                          ),
                          Column(
                            children: [
                              RawMaterialButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                      PageAnimationTransition(
                                          page: const Criar(),
                                          pageAnimationType:
                                              FadeAnimationTransition()));
                                },
                                elevation: 2.0,
                                fillColor:
                                    const Color.fromARGB(255, 32, 96, 184),
                                padding: const EdgeInsets.all(15.0),
                                shape: const CircleBorder(),
                                child:
                                    const Icon(Icons.add, color: Colors.white),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text("Novo"),
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        color:
                            isDarkMode(context) ? Colors.white54 : Colors.black,
                        height: 80,
                      ),
                      const Column(
                        children: [
                          Text(
                            "Dados mais Seguros!",
                            style: TextStyle(fontSize: 25),
                          ),
                          Text(
                            "Guarde-os com segurança para evitar qualquer possibilidade de perder os arquivos.",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                      Row(
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
                              const Text("Selecione"),
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
                              const Text("Upload"),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      buildProgress(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Container(
                    width: 12.0,
                    height: 12.0,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPageIndex == index
                          ? Colors.blue
                          : Colors.grey,
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: showFloatingButton,
        child: FloatingActionButton(
          onPressed: generatePDF,
          child: const Icon(Icons.picture_as_pdf),
        ),
      ),
    );
  }
}

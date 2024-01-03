import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'firebase_options.dart';
import 'routes.dart';
import 'utils/date_provider.dart';
import 'utils/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting("pt_BR", "pt_BR");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(ChangeNotifierProvider(
    create: (context) => DateSelectionProvider(),
    child: const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: DoubleBackToCloseApp(
          snackBar: SnackBar(
            content: Text('Pressione novamente para sair'),
            behavior: SnackBarBehavior.floating,
            dismissDirection: DismissDirection.horizontal,
          ),
          child: MyApp(),
        ),
      ),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            routes: Routes.routes,
            initialRoute: Routes.initialRoute,
            theme:
                themeNotifier.isDarkMode ? ThemeData.dark() : ThemeData.light(),
          );
        },
      ),
    );
  }
}

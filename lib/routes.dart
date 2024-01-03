import 'package:diario_obra/pages/middleware.dart'; 
import 'package:flutter/cupertino.dart';

class Routes {
  static Map<String, Widget Function(BuildContext context)> routes = <String, WidgetBuilder>{
    '/checagem': (context) => const ChecagemPage(),  
  };

  static String initialRoute = '/checagem';
}
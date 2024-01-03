import 'package:diario_obra/pages/settings/settings.dart';
import 'package:diario_obra/utils/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:provider/provider.dart';

class Appearence extends StatefulWidget {
  const Appearence({super.key});

  @override
  State<Appearence> createState() => _AppearenceState();
}

class _AppearenceState extends State<Appearence> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;
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
            'Aparência',
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge!.color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Personalize Sua Experiência Visual.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Tema',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  FlutterSwitch(
                    valueFontSize: 16.0,
                    toggleSize: 30.0,
                    value: isDarkMode,
                    borderRadius: 30.0,
                    padding: 4.0,
                    showOnOff: false,
                    activeToggleColor: Colors.blue[700],
                    activeColor: Colors.grey,
                    onToggle: (value) {
                      setState(() {
                        themeNotifier.toggleTheme();
                      });
                    },
                    inactiveIcon: Icon(
                      Icons.wb_sunny,
                      color: Colors.yellow[700],
                      size: 24.0,
                    ),
                    activeIcon: const Icon(
                      Icons.nightlight_round,
                      color: Colors.white,
                      size: 24.0,
                    ),
                  ),
                ],
              ),
            ])));
  }
}

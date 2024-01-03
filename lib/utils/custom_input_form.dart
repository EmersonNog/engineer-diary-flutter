import 'package:flutter/material.dart';

class CustomInputForm extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final Icon? prefixIcon;

  const CustomInputForm({
    super.key,
    required this.controller,
    required this.labelText,
    this.prefixIcon,
  });

  bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(
              color: isDarkMode(context) ? Colors.white54 : Colors.black45,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: prefixIcon,
            ),
            filled: true,
            fillColor: isDarkMode(context)
                ? Colors.grey[800]
                : const Color.fromARGB(255, 247, 247, 247),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}

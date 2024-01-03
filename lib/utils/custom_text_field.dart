// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final String label;
  final bool isPassword;
  final TextEditingController? controller;

  const CustomInputField({
    Key? key,
    required this.label,
    this.isPassword = false,
    this.controller,
  }) : super(key: key);

  @override
  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late TextEditingController _controller;
  bool _showCheckIcon = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    
    _controller.addListener(() {
      setState(() {
        _showCheckIcon = _controller.text.length > 10;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      obscureText: widget.isPassword ? _obscureText : false,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 161, 161, 161)),
        filled: true,
        fillColor: const Color.fromARGB(87, 233, 233, 233),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
              )
            : _showCheckIcon
                ? const Icon(
                    Icons.check,
                    color: Colors.green,
                  )
                : null,
      ),
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }
}

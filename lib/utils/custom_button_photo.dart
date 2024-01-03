// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class CustomIconButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color defaultIconColor;

  const CustomIconButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.defaultIconColor = Colors.black,
  }) : super(key: key);

  @override
  _CustomIconButtonState createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  late Color iconColor;

  @override
  void initState() {
    super.initState();
    iconColor = widget.defaultIconColor;
  }

  void updateIconColor(Color color, {bool resetColor = false}) {
    setState(() {
      iconColor = resetColor ? widget.defaultIconColor : color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 0, color: Colors.grey.shade300),
      ),
      child: IconButton(
        onPressed: () {
          widget.onPressed();
          if (iconColor == Colors.green) {
            updateIconColor(iconColor, resetColor: true);
          } else {
            updateIconColor(Colors.green);
          }
        },
        icon: Icon(
          widget.icon,
          color: iconColor,
        ),
      ),
    );
  }
}

// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomListAnimated extends StatefulWidget {
  final IconData icon;
  final Color colorIcon; 
  final Color colorText;
  final String text;
  final Color? colorShine;
  final Color? colorBorder;

  const CustomListAnimated({
    Key? key,
    required this.icon,
    required this.colorIcon, 
    required this.colorText,
    required this.text, 
    this.colorShine, 
    this.colorBorder,
  }) : super(key: key);

  @override
  _CustomListAnimatedState createState() => _CustomListAnimatedState();
}

class _CustomListAnimatedState extends State<CustomListAnimated> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        shape: StadiumBorder(
          side: BorderSide(
            color: widget.colorBorder ??const Color.fromARGB(115, 218, 211, 211),
          ),
        ), 
        leading: Icon(
          widget.icon,
          color: widget.colorIcon,
        ),
        title: Shimmer.fromColors(
          baseColor: widget.colorText,
          highlightColor: widget.colorShine ?? Colors.grey.shade300, 
          child: Text(widget.text),
        ),
      ),
    );
  }
}

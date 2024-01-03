import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final double width;
  final bool hasBorder;
  final Color borderColor;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final String buttonText;
  final VoidCallback onPressed;

  const CustomTextButton({
    Key? key,
    required this.width,
    this.hasBorder = false,
    this.borderColor = Colors.white,
    this.backgroundColor,
    this.textColor,
    this.icon,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: hasBorder
                ? Border.all(
                    color: borderColor,
                    width: 2.0,
                  )
                : null,
            color: !hasBorder && backgroundColor != null
                ? backgroundColor
                : null,
          ),
          child: TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null)
                  Icon(
                    icon,
                    color: textColor ?? Colors.white,
                  ),
                if (icon != null && buttonText.isNotEmpty)
                  const SizedBox(width: 8),
                Text(
                  buttonText,
                  style: TextStyle(
                    fontFamily: 'YuseiMagic',
                    color: textColor ?? Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

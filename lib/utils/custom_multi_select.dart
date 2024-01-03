import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class MultiSelectField extends StatelessWidget {
  final String title;
  final String buttonText;
  final String cancelText;
  final List<MultiSelectItem> items;
  final MultiSelectListType listType;
  final Function(List<dynamic>?) onConfirm;
  final Function? chipDisplay;

  const MultiSelectField({super.key, 
    required this.title,
    required this.buttonText,
    required this.cancelText,
    required this.items,
    required this.listType,
    required this.onConfirm, 
    this.chipDisplay,
  });

  @override
  Widget build(BuildContext context) {
    return MultiSelectDialogField(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 10,
          color: Colors.transparent,
        )
      ),
      title: Text(title),
      buttonIcon: const Icon(Icons.arrow_drop_down_sharp),
      buttonText: Text(buttonText),
      cancelText: Text(cancelText),
      items: items,
      listType: listType,
      onConfirm: onConfirm,
    );
  }
}
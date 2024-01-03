// ignore_for_file: unnecessary_null_comparison, library_private_types_in_public_api

import 'package:flutter/material.dart';

class StatusSelector extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String? initialStatus;

  const StatusSelector(
      {super.key, required this.onChanged, this.initialStatus});

  @override
  _StatusSelectorState createState() => _StatusSelectorState();
}

class _StatusSelectorState extends State<StatusSelector> {
  String? selectedStatus;
  TextEditingController serviceController = TextEditingController();

  final List<String> statusOptions = [
    "Informe",
    "A iniciar",
    "Concluído",
    "Em Andamento",
    "Paralisado"
  ];

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.initialStatus ?? "Informe";
  }

  bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: serviceController,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    widget.onChanged(
                        "DESCRIÇÃO: $value - STATUS: $selectedStatus");
                  } else {
                    widget.onChanged("");
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  labelStyle: TextStyle(
                      color: isDarkMode(context)
                          ? Colors.white70
                          : Colors.black45),
                  prefixIcon: Icons.content_paste_search_rounded != null
                      ? const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Icon(Icons.content_paste_search_rounded),
                        )
                      : null,
                  filled: true,
                  fillColor: isDarkMode(context)
                      ? Colors.grey.shade800
                      : Colors.grey[200],
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 50,
            ),
            DropdownButton<String>(
              value: selectedStatus,
              onChanged: (String? newValue) {
                if (serviceController.text.isNotEmpty &&
                    newValue != "Informe") {
                  setState(() {
                    selectedStatus = newValue;
                    widget.onChanged(
                      "DESCRIÇÃO: ${serviceController.text} - STATUS: $selectedStatus\n",
                    );
                  });
                } else {
                  widget.onChanged("");
                }
              },
              items:
                  statusOptions.map<DropdownMenuItem<String>>((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(
                    status,
                    style: TextStyle(
                      color: status == "Informe"
                          ? Colors.grey
                          : isDarkMode(context)
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                );
              }).toList(),
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              underline: Container(
                height: 0,
                color: Colors.transparent,
              ),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

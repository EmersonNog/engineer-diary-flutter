// ignore_for_file: library_private_types_in_public_api, unnecessary_null_comparison

import 'package:diario_obra/utils/upper_case_formatter_class.dart';
import 'package:flutter/material.dart';

class StaffEquipment extends StatefulWidget {
  final String title;
  final Map<String, int> selectedItems;
  final List<String> predefinedItems;

  const StaffEquipment({
    Key? key, // Fixing the constructor signature
    required this.title,
    required this.selectedItems,
    required this.predefinedItems,
  }) : super(key: key);

  @override
  _StaffEquipmentState createState() => _StaffEquipmentState();
}

class _StaffEquipmentState extends State<StaffEquipment> {
  TextEditingController itemQuantityController = TextEditingController();
  TextEditingController newItemController = TextEditingController();
  String? selectedDropdownItem;
  bool showNewItemInput = false;

  void removeSelectedItem(String itemName) {
    setState(() {
      if (widget.selectedItems.containsKey(itemName)) {
        widget.selectedItems.remove(itemName);
      }
    });
  }

  bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode(context) ? Colors.grey.shade800 : Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: <Widget>[
          Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton<String>(
                value: selectedDropdownItem,
                onChanged: (newValue) {
                  setState(() {
                    selectedDropdownItem = newValue;
                  });
                },
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text(
                      'Selecione o item',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  ...widget.predefinedItems.map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: TextStyle(
                          color: isDarkMode(context)
                              ? Colors.white70
                              : Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
              SizedBox(
                width: 102,
                height: 50,
                child: TextFormField(
                  controller: itemQuantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantidade',
                    labelStyle: TextStyle(
                      color:
                          isDarkMode(context) ? Colors.white70 : Colors.black45,
                      fontSize: 13,
                      letterSpacing: 1,
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 140,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Checkbox(
                    value: showNewItemInput,
                    onChanged: (value) {
                      setState(() {
                        showNewItemInput = value!;
                        if (!showNewItemInput) {
                          newItemController.clear();
                        }
                      });
                    },
                  ),
                ),
                const Text("Não possui item?"),
              ],
            ),
          ),
          Visibility(
            visible: showNewItemInput,
            child: SizedBox(
              height: 55,
              child: TextFormField(
                controller: newItemController,
                inputFormatters: [UpperCaseTextFormatter()],
                decoration: InputDecoration(
                  labelText: 'Novo Item',
                  labelStyle: TextStyle(
                    color:
                        isDarkMode(context) ? Colors.white70 : Colors.black45,
                    fontSize: 13,
                    letterSpacing: 1,
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.green[400],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                final itemName = selectedDropdownItem ?? newItemController.text;
                final quantity = int.tryParse(itemQuantityController.text) ?? 0;
                if (itemName != null && itemName.isNotEmpty && quantity > 0) {
                  setState(() {
                    if (widget.selectedItems.containsKey(itemName)) {
                      widget.selectedItems[itemName] =
                          (widget.selectedItems[itemName] ?? 0) + quantity;
                    } else {
                      widget.selectedItems[itemName] = quantity;
                    }
                  });
                  itemQuantityController.clear();
                  newItemController.clear();
                  selectedDropdownItem = null;
                }
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              tooltip: "Adicionar",
            ),
          ),
          const Divider(color: Color.fromARGB(255, 196, 196, 196), height: 25),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 196, 196, 196)),
                      borderRadius: BorderRadius.circular(15)),
              child: Scrollbar(
                thumbVisibility: true,
                trackVisibility: true,
                interactive: true,
                thickness: 2,
                radius: const Radius.circular(12),
                child: ListView(
                  children: widget.selectedItems.entries.map((entry) {
                    return Dismissible(
                      key: Key(entry.key),
                      onDismissed: (direction) {
                        removeSelectedItem(entry.key);
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: ListTile(
                          key: Key(entry.key),
                          title: Text(
                            '${entry.key}: ${entry.value}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDarkMode(context)
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          trailing: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete, size: 20),
                              Text(
                                "Arraste para apagar",
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

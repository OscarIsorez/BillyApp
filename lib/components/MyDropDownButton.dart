import 'package:billy/constant.dart';
import 'package:billy/templates/ConvTheme.dart';
import 'package:flutter/material.dart';

class MyDropdownButton extends StatefulWidget {
  final List<String> themes;
  final ValueChanged<String> onValueChanged;

  MyDropdownButton({required this.themes, required this.onValueChanged});

  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  ConvTheme dropdownValue = Constants.convThemes[0];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue.toString(),
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = ConvTheme.fromString(newValue!);
        });

        widget.onValueChanged(newValue!);
      },
      items: widget.themes.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

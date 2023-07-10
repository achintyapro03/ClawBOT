import 'package:flutter/material.dart';

const List<Widget> icons = <Widget>[
  Icon(Icons.power),
  Icon(Icons.power_off),
];

class MyToggleButton extends StatefulWidget {
  const MyToggleButton({super.key, required this.num});

  final int num;
  @override
  State<MyToggleButton> createState() => _MyToggleButtonState();
}

class _MyToggleButtonState extends State<MyToggleButton> {
  final List<bool> _selectedWeather = <bool>[false, true];
  bool vertical = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const SizedBox(width: 71),
          Text(
            widget.num.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 30),
          ToggleButtons(
            direction: Axis.vertical,
            onPressed: (int index) {
              setState(() {
                // The button that is tapped is set to true, and the others to false.
                for (int i = 0; i < _selectedWeather.length; i++) {
                  _selectedWeather[i] = i == index;
                }
              });
            },
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            selectedBorderColor: Colors.amber[700],
            selectedColor: const Color.fromARGB(208, 0, 4, 14),
            fillColor: Colors.amber[200],
            color: Colors.amber[400],
            borderColor: Colors.amber,
            isSelected: _selectedWeather,
            children: icons,
          ),
        ],
      ),
    );
  }
}

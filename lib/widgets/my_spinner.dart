import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

var col = [
  const Color.fromARGB(208, 0, 4, 14),
  const Color.fromARGB(195, 0, 4, 14),
  const Color.fromARGB(255, 255, 193, 7),
  const Color.fromARGB(255, 255, 255, 255),
  const Color.fromARGB(255, 69, 71, 80),
];

class MySpinner extends StatefulWidget {
  MySpinner({super.key, required this.seconds});

  var seconds;
  @override
  State<MySpinner> createState() => MySpinnerState();
}

class MySpinnerState extends State<MySpinner> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: col[4],
        width: 40,
        height: 146,
        child: SpinBox(
          min: 0,
          max: 50,
          value: 0,
          spacing: 1,
          direction: Axis.vertical,
          textStyle: const TextStyle(
              fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
          incrementIcon: const Icon(
            Icons.keyboard_arrow_up,
            size: 25,
            color: Colors.white,
          ),
          decrementIcon: const Icon(
            Icons.keyboard_arrow_down,
            size: 25,
            color: Colors.white,
          ),
          onChanged: (value) {
            // setState(() {
            widget.seconds.value = value.round();
            // });
          },
          // iconColor: Colors.black,

          decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 4, color: Colors.white), //<-- SEE HERE
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
    );
  }
}

import "package:controller_app/widgets/my_spinner.dart";
import "package:controller_app/widgets/my_switch.dart";
import "package:flutter/material.dart";
// import "package:flutter/cupertino.dart";

var col = [
  const Color.fromARGB(208, 0, 4, 14),
  const Color.fromARGB(195, 0, 4, 14),
  const Color.fromARGB(255, 255, 193, 7),
  const Color.fromARGB(255, 255, 255, 255),
  const Color.fromARGB(255, 69, 71, 80)
];

class StepQuery extends StatefulWidget {
  const StepQuery({super.key, required this.num});

  final int num;
  @override
  State<StepQuery> createState() => _StepQueryState();
}

class _StepQueryState extends State<StepQuery> {
  bool val = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 146,
              width: 10,
              color: Colors.amber[200],
              child: Text(widget.num.toString()),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Container(
                width: 146,
                color: col[4],
                child: const MySwitch(),
              ),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Container(
                width: 146,
                color: col[4],
                child: const MySwitch(),
              ),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Container(
                width: 146,
                color: col[4],
                child: const MySwitch(),
              ),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Container(
                width: 146,
                color: col[4],
                child: const MySwitch(),
              ),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Container(
                width: 146,
                color: col[4],
                child: const MySwitch(),
              ),
            ),
            Container(
              width: 15,
              height: 146,
              color: col[4],
            ),
            const MySpinner(),
            Container(
              width: 13,
              height: 146,
              color: col[4],
            ),
          ],
        ),
      ),
    );
  }
}

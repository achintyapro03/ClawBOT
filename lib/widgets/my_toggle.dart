import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const List<Widget> icons = <Widget>[
  Icon(Icons.power),
  Icon(Icons.power_off),
];

class MyToggleButtonHook extends HookWidget {
  MyToggleButtonHook({Key? key, required this.nums, required this.tc})
      : super(key: key);

  final int nums;
  var tc;

  // final List<bool> selectedState = <bool>[false, true];

  @override
  Widget build(BuildContext context) {
    final s1 = useState(false);
    final s2 = useState(true);

    // useEffect(() {
    //   tc.value = true;
    //   return null;
    // }, [s1.value]);
    return Container(
      child: Column(
        children: [
          const SizedBox(width: 71),
          Text(
            nums.toString(),
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
              if (index == 0) {
                s1.value = true;
                s2.value = false;
                tc.value = true;
              } else {
                s2.value = true;
                s1.value = false;
                tc.value = false;
              }
            },
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            selectedBorderColor: Colors.amber[700],
            selectedColor: const Color.fromARGB(208, 0, 4, 14),
            fillColor: Colors.amber[200],
            color: Colors.amber[400],
            borderColor: Colors.amber,
            isSelected: [s1.value, s2.value],
            children: icons,
          ),
        ],
      ),
    );
  }
}

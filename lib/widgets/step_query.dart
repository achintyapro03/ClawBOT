import "package:controller_app/widgets/hook_switch.dart";
import "package:controller_app/widgets/my_spinner.dart";
import "package:controller_app/widgets/my_switch.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
// import "package:flutter/cupertino.dart";

var col = [
  const Color.fromARGB(208, 0, 4, 14),
  const Color.fromARGB(195, 0, 4, 14),
  const Color.fromARGB(255, 255, 193, 7),
  const Color.fromARGB(255, 255, 255, 255),
  const Color.fromARGB(255, 69, 71, 80)
];

class StepQueryHook extends HookWidget {
  const StepQueryHook({Key? key, required this.nums, required this.lights})
      : super(key: key);

  // const StepQueryHook({super.key, required this.num});
  final int nums;
  final lights;

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
              child: Text(nums.toString()),
            ),
            // RotatedBox(
            //   quarterTurns: 3,
            //   child: Container(
            //     width: 146,
            //     color: col[4],
            //     child: SwitchHook(light: lights[0]),
            //   ),
            // ),

            for (int i = 0; i < 5; i++) ...[
              RotatedBox(
                quarterTurns: 3,
                child: Container(
                  width: 146,
                  color: col[4],
                  child: SwitchHook(light: lights[i]),
                ),
              ),
            ],
            // RotatedBox(
            //   quarterTurns: 3,
            //   child: Container(
            //     width: 146,
            //     color: col[4],
            //     child: MySwitch(light: lights[1]),
            //   ),
            // ),
            // RotatedBox(
            //   quarterTurns: 3,
            //   child: Container(
            //     width: 146,
            //     color: col[4],
            //     child: MySwitch(light: lights[2]),
            //   ),
            // ),
            // RotatedBox(
            //   quarterTurns: 3,
            //   child: Container(
            //     width: 146,
            //     color: col[4],
            //     child: MySwitch(light: lights[3]),
            //   ),
            // ),
            // RotatedBox(
            //   quarterTurns: 3,
            //   child: Container(
            //     width: 146,
            //     color: col[4],
            //     child: MySwitch(light: lights[4]),
            //   ),
            // ),
            // Container(
            //   width: 15,
            //   height: 146,
            //   color: col[4],
            // ),
            // const MySpinner(),
            // Container(
            //   width: 13,
            //   height: 146,
            //   color: col[4],
            // ),
          ],
        ),
      ),
    );
  }
}

// class StepQueryHook extends HookWidget {
//   const StepQueryHook({Key? key, required this.nums, required this.lights})
//       : super(key: key);

//   // const StepQueryHook({super.key, required this.num});
//   final int nums;
//   final lights;

//   @override
//   Widget build(BuildContext context) {
//     return Material(child: Text("kkk"));
//   }
// }

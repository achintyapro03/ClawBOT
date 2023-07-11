import "package:flutter/material.dart";
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import '../widgets/step_query.dart';

// import "../widgets/my_toggle.dart";

var col = [
  const Color.fromARGB(208, 0, 4, 14),
  const Color.fromARGB(195, 0, 4, 14),
  const Color.fromARGB(255, 255, 193, 7),
  const Color.fromARGB(255, 255, 255, 255),
  const Color.fromARGB(255, 69, 71, 80),
];

// class CustomPage extends StatefulWidget {
//   const CustomPage({super.key});

//   @override
//   State<CustomPage> createState() => _CustomPageState();
// }

class CustomPageHook extends HookWidget {
  CustomPageHook(
      {Key? key,
      required this.stepQueryState,
      required this.secondsState,
      required this.isPlaying})
      : super(key: key);

  // final _formKey = GlobalKey<FormState>();
  var stepQueryState;
  var secondsState;
  var isPlaying;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    final intOfSteps = useState(0);
    final myScrollController = ScrollController();
    return Material(
      child: Container(
        height: 500,
        color: col[0],
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
              width: 500,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.videogame_asset_outlined,
                  color: col[2],
                  size: 50,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  "Controller",
                  style: TextStyle(
                    color: col[3],
                    fontSize: 22,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
              width: 500,
            ),
            AbsorbPointer(
              absorbing: isPlaying.value,
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  color: col[4],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "No of Steps :",
                      style: TextStyle(
                        color: col[3],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: SpinBox(
                        min: 0,
                        max: 50,
                        value: 0,
                        spacing: 1,
                        direction: Axis.horizontal,
                        textStyle: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
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
                          intOfSteps.value = value.round();
                        },
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 4,
                              color: Colors.white,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 30),
                        ),
                      ),
                    ),
                  ],
                ),
                // const SizedBox(width: 60),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              "     1           2           3           4           5         seconds",
              style: TextStyle(
                color: col[3],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            AbsorbPointer(
              absorbing: isPlaying.value,
              child: Container(
                height: 160,
                width: 310,
                decoration: BoxDecoration(
                  color: col[4],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Scrollbar(
                  controller: myScrollController,

                  thumbVisibility: true, //always show scrollbar
                  thickness: 2, //width of scrollbar
                  scrollbarOrientation:
                      ScrollbarOrientation.right, //which side to show scrollbar

                  child: SingleChildScrollView(
                    controller: myScrollController,
                    child: Container(
                      color: col[4],
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10),
                      child: Column(
                        children: [
                          for (int i = 0; i < intOfSteps.value; i++) ...[
                            StepQueryHook(
                              nums: i + 1,
                              lights: stepQueryState[i],
                              seconds: secondsState[i],
                            )
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Scroll ",
                  style: TextStyle(
                    color: col[3],
                  ),
                ),
                Icon(
                  Icons.arrow_downward,
                  color: col[3],
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[200],
                  ),
                  onPressed: () {
                    isPlaying.value = !isPlaying.value;
                    // Handle button press
                  },
                  child: Row(
                    children: [
                      (isPlaying.value)
                          ? Icon(
                              Icons.stop,
                              color: col[1],
                            )
                          : Icon(
                              Icons.play_arrow,
                              color: col[1],
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        (!isPlaying.value) ? "Start" : "Stop",
                        style: TextStyle(
                          color: col[0],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

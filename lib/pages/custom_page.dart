import "package:flutter/material.dart";
import 'package:flutter_hooks/flutter_hooks.dart';
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
  CustomPageHook({Key? key, required this.stepQueryState}) : super(key: key);

  // final _formKey = GlobalKey<FormState>();
  var stepQueryState;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    stepQueryState =
        List.generate(15, (_) => List.generate(5, (_) => useState(false)));
    // void addStepQuery(int numOfSteps) {
    //   print("ola1");
    //   // stepQueryState = List.generate(
    //   //     numOfSteps, (_) => List.generate(5, (_) => useState(false)));

    //   stepQueryState.clear();

    //   for (int i = 0; i < numOfSteps; i++) {
    //     var li = [];
    //     for (int j = 0; j < 5; j++) {
    //       print("in");
    //       li.add(useState(false));
    //     }
    //     stepQueryState.add(li);
    //   }
    //   print("ola2");

    //   print(stepQueryState);
    // }

    final isPlaying = useState(false);
    final numberOfSteps = useState("0");
    final intOfSteps = useState(0);
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
            Form(
              key: _formKey,
              child: Container(
                width: 300,
                height: 70,
                decoration: BoxDecoration(
                  color: col[4],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) {
                          print(int.parse(value));
                          numberOfSteps.value = value;
                          print("olololol ${numberOfSteps.value} ");
                        },
                        // initialValue: "0",
                        cursorColor: col[1],
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Enter num of steps",
                          labelText: "Total Steps",
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ), // Add some spacing between the text field and the button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[200],
                      ),
                      onPressed: () {
                        // addStepQuery(int.parse(numberOfSteps.value));
                        intOfSteps.value = int.parse(numberOfSteps.value);
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: col[0],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                  ],
                ),
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
            Container(
              height: 160,
              width: 300,
              decoration: BoxDecoration(
                color: col[4],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Scrollbar(
                thumbVisibility: true, //always show scrollbar
                thickness: 2, //width of scrollbar
                scrollbarOrientation:
                    ScrollbarOrientation.right, //which side to show scrollbar

                child: SingleChildScrollView(
                  child: Container(
                    color: col[4],
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10),
                    child: Column(
                      children: [
                        for (int i = 0; i <= intOfSteps.value; i++) ...[
                          StepQueryHook(
                            nums: i + 1,
                            lights: stepQueryState[i],
                          )
                        ],
                      ],
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

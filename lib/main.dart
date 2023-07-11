import "package:controller_app/pages/custom_page.dart";
import "package:controller_app/pages/standard_page.dart";
import "package:controller_app/widgets/hook_switch.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

// import "widgets/my_switch.dart";
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(const MyApp());
}

var col = [
  const Color.fromARGB(208, 0, 4, 14),
  const Color.fromARGB(195, 0, 4, 14),
  const Color.fromARGB(255, 255, 193, 7),
  const Color.fromARGB(255, 255, 255, 255),
  const Color.fromARGB(255, 69, 71, 80)
];

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.lato().fontFamily,
      ),
      home: HomePageHook(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePageHook extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final page = useState(0);
    final power = useState(0.0);
    final onOff = useState(false);
    final lockPos = useState(false);
    final isPlaying = useState(false);

    var stepQueryState =
        List.generate(15, (_) => List.generate(5, (_) => useState(false)));

    final List<bool> stdState = <bool>[false, true];

    useEffect(() {
      print("power changed to ${power.value}");
      return null;
    }, [power.value]);

    useEffect(() {
      print("page changed to ${page.value}");
      return null;
    }, [page.value]);

    useEffect(() {
      print("onoff changed to ${onOff.value}");
      return null;
    }, [onOff.value]);

    useEffect(() {
      print("lockPos changed to ${lockPos.value}");
      return null;
    }, [lockPos.value]);

    useEffect(() {
      if (isPlaying.value == true) {
        print("yeah boi now playing");
        print(stepQueryState);
      }
      print("Play / pause mode - ${isPlaying.value}");

      return null;
    }, [isPlaying.value]);
    // useEffect(() {
    //   print("page changed to ${page.value}");
    //   return null;
    // }, [page.value]);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: col[0],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "ClawBot  -  ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: col[2],
              ),
            ),
            (page.value == 0)
                ? Text(
                    "Std Mode",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: col[3],
                    ),
                  )
                : Text(
                    "Custom Mode",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: col[3],
                    ),
                  ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            page.value = 1 - page.value;
          },
          icon: Icon(
            Icons.autorenew_rounded,
            size: 25,
            color: col[3],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                color: col[1],
                child: Column(
                  children: [
                    // MySwitch(),
                    const SizedBox(width: 500, height: 20),
                    Text(
                      "Power : ${power.value.round()}%",
                      style: TextStyle(
                        color: col[3],
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Slider(
                      min: 0,
                      max: 100,
                      value: power.value,
                      thumbColor: Colors.amber,
                      activeColor: Colors.amber[200],
                      inactiveColor: col[3],
                      onChanged: (value) {
                        power.value = value;
                      },
                    ),
                    const SizedBox(width: 500, height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SwitchHook(
                          light: onOff,
                        ),
                        const SizedBox(width: 140),
                        SwitchHook(
                          light: lockPos,
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("On/Off", style: TextStyle(color: col[3])),
                        const SizedBox(width: 150),
                        Text("Lock Pos", style: TextStyle(color: col[3])),
                      ],
                    ),
                    const SizedBox(
                      width: 500,
                      height: 25,
                    ),
                  ],
                ),
              ),
              Material(
                child: (page.value == 0)
                    ? const StandardPage()
                    : CustomPageHook(
                        stepQueryState: stepQueryState,
                        isPlaying: isPlaying,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   final butKey = GlobalKey<_MyHomePageState>();

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // title: 'Toggle Buttons Demo',
//       // theme: ThemeData(
//       //   primarySwatch: Colors.blue,
//       // ),
//       // home: MyHomePage(key: butKey),

//       home: Scaffold(
//         // appBar: AppBar(
//         //   title: Text('Toggle Buttons Demo'),
//         // ),
//         body: MyHomePage(key: butKey),
//         floatingActionButton: FloatingActionButton(
//           child: Text("Press"),
//           onPressed: () {
//             final b = butKey.currentState!.buttonStates;

//             int t = 0;
//             int f = 0;
//             for (var i in b) {
//               if (i)
//                 t++;
//               else
//                 f++;
//             }

//             print("t = $t, f = $f");
//           },
//         ),
//       ),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int numberOfButtons = 0;
//   List<bool> buttonStates = [];

//   void createButtons() {
//     buttonStates = List<bool>.filled(numberOfButtons, false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Toggle Buttons Demo'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             TextField(
//               keyboardType: TextInputType.number,
//               onChanged: (value) {
//                 setState(() {
//                   numberOfButtons = int.tryParse(value) ?? 0;
//                   createButtons();
//                 });
//               },
//             ),
//             SizedBox(height: 20),
//             Wrap(
//               children: List<Widget>.generate(numberOfButtons, (index) {
//                 return Padding(
//                   padding: EdgeInsets.all(5),
//                   child: ToggleButton(
//                     index: index,
//                     isPressed: buttonStates[index],
//                     onPressed: () {
//                       setState(() {
//                         buttonStates[index] = !buttonStates[index];
//                       });
//                     },
//                   ),
//                 );
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ToggleButton extends StatelessWidget {
//   final int index;
//   final bool isPressed;
//   final Function onPressed;

//   ToggleButton(
//       {required this.index, required this.isPressed, required this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         primary: isPressed ? Colors.blue : Colors.grey,
//         padding: EdgeInsets.all(16),
//       ),
//       onPressed: () => onPressed(),
//       child: Text(
//         'Button $index',
//         style: TextStyle(color: Colors.white),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';




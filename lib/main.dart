import "package:controller_app/pages/custom_page.dart";
import "package:controller_app/pages/standard_page.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "widgets/my_switch.dart";

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
  int page = 0;
  double power = 0;

  List<int> fingerNum = [1, 2, 3, 4, 5];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // themeMode: ThemeMode.light,
      // color: Colors.white,
      theme: ThemeData(
        // scaffoldBackgroundColor: Color.fromARGB(37, 106, 124, 170),

        useMaterial3: true,
        fontFamily: GoogleFonts.lato().fontFamily,
        // primaryColor: Colors.amber,
      ),
      debugShowCheckedModeBanner: false,
      // initialRoute: MyRoutes.stdRoute,

      // routes: {
      //   MyRoutes.stdRoute: (context) => StandardPage(),
      //   MyRoutes.cusRoute: (context) => const CustomPage(),
      // },

      home: Scaffold(
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
              (page == 0)
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
              setState(() {
                page = 1 - page;
              });
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
                        "Power : ${power.round()}%",
                        style: TextStyle(
                          color: col[3],
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Slider(
                        min: 0,
                        max: 100,
                        value: power,
                        thumbColor: Colors.amber,
                        activeColor: Colors.amber[200],
                        inactiveColor: col[3],
                        onChanged: (value) {
                          setState(
                            () {
                              power = value;
                            },
                          );
                        },
                      ),
                      const SizedBox(width: 500, height: 15),

                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MySwitch(),
                          SizedBox(width: 140),
                          MySwitch(),
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
                  child:
                      (page == 0) ? const StandardPage() : const CustomPage(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

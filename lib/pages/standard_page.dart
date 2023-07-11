import "package:flutter/material.dart";
import "../widgets/my_toggle.dart";

var col = [
  const Color.fromARGB(208, 0, 4, 14),
  const Color.fromARGB(195, 0, 4, 14),
  const Color.fromARGB(255, 255, 193, 7),
  const Color.fromARGB(255, 255, 255, 255),
  const Color.fromARGB(255, 69, 71, 80)
];

class StandardPage extends StatefulWidget {
  const StandardPage({Key? key}) : super(key: key);

  @override
  State<StandardPage> createState() => _StandardPageState();
}

class _StandardPageState extends State<StandardPage> {
  // final toggleKeyList = List<GlobalKey<MyToggleButtonState>>.filled(
  //   5,
  //   new GlobalKey<MyToggleButtonState>(),
  // );

  void createButtons() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      color: col[0],
      height: 500,
      child: Column(
        children: [
          // MySwitch(),
          const SizedBox(width: 500, height: 15),
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
          const SizedBox(height: 15),
          Container(
            width: 360,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: const Color.fromARGB(255, 69, 71, 80),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    for (int i = 0; i < 5; i++) ...[
                      MyToggleButton(num: i + 1),
                    ]
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

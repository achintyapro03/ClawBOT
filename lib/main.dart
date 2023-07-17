import "package:claw_bot/pages/custom_page.dart";
import "package:claw_bot/pages/standard_page.dart";
import "package:claw_bot/widgets/hook_switch.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import "dart:math";

import 'widgets/widgets.dart';

// void main() {
//   runApp(const MyApp());
// }

void main() {
  if (Platform.isAndroid) {
    WidgetsFlutterBinding.ensureInitialized();
    [
      Permission.location,
      Permission.storage,
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan
    ].request().then((status) {
      runApp(const FlutterBlueApp());
    });
  } else {
    runApp(const FlutterBlueApp());
  }
}

class FlutterBlueApp extends StatelessWidget {
  const FlutterBlueApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.lato().fontFamily,
      ),
      debugShowCheckedModeBanner: false,
      // color: Colors.lightBlue,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBluePlus.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return const FindDevicesScreen();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .titleSmall
                  ?.copyWith(color: Colors.white),
            ),
            ElevatedButton(
              onPressed: Platform.isAndroid
                  ? () => FlutterBluePlus.instance.turnOn()
                  : null,
              child: const Text('TURN ON'),
            ),
          ],
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatelessWidget {
  const FindDevicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.fromLTRB(10, 45, 10, 20),
        child: RefreshIndicator(
          onRefresh: () => FlutterBluePlus.instance
              .startScan(timeout: const Duration(seconds: 1)),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                StreamBuilder<List<BluetoothDevice>>(
                  stream: Stream.periodic(const Duration(seconds: 1)).asyncMap(
                      (_) => FlutterBluePlus.instance.connectedDevices),
                  initialData: const [],
                  builder: (c, snapshot) => Column(
                    children: [
                      Container(
                        color: col[0],
                        width: 250,
                        height: 60,
                        child: const Center(
                          child: Text(
                            "Find device",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.amber,
                              // backgroundColor: col[0],
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: snapshot.data!
                            .map((d) => ListTile(
                                  title: Text(d.name),
                                  subtitle: Text(d.id.toString()),
                                  trailing: StreamBuilder<BluetoothDeviceState>(
                                    stream: d.state,
                                    initialData:
                                        BluetoothDeviceState.disconnected,
                                    builder: (c, snapshot) {
                                      if (snapshot.data ==
                                          BluetoothDeviceState.connected) {
                                        return ElevatedButton(
                                          child: const Text('OPEN'),
                                          onPressed: () => Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      DeviceScreen(
                                                        device: d,
                                                        services: [],
                                                      ))),
                                        );
                                      }
                                      return Text(snapshot.data.toString());
                                    },
                                  ),
                                ))
                            .toList(),
                      )
                    ],
                  ),
                ),
                StreamBuilder<List<ScanResult>>(
                  stream: FlutterBluePlus.instance.scanResults,
                  initialData: const [],
                  builder: (c, snapshot) => Column(
                    children: snapshot.data!
                        .map(
                          (r) => ScanResultTile(
                            result: r,
                            onTap: () async {
                              await r.device.connect();

                              List<BluetoothService> services =
                                  await r.device.discoverServices();

                              // writeToBLE(
                              //     services, "connection successful 123456!!\n");

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return DeviceScreen(
                                      device: r.device,
                                      services: services,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBluePlus.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              onPressed: () => FlutterBluePlus.instance.stopScan(),
              backgroundColor: Colors.red,
              child: const Icon(Icons.stop),
            );
          } else {
            return FloatingActionButton(
                child: const Icon(Icons.search),
                onPressed: () => FlutterBluePlus.instance
                    .startScan(timeout: const Duration(seconds: 1)));
          }
        },
      ),
    );
  }
}

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({Key? key, required this.device, required this.services})
      : super(key: key);

  final List<BluetoothService> services;
  final BluetoothDevice device;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          leading: const BackButton(
            color: Colors.amber, // <-- SEE HERE
          ),
          backgroundColor: col[0],
          title: Text(
            device.name,
            style: TextStyle(color: col[3], fontSize: 20),
          ),
          actions: <Widget>[
            StreamBuilder<BluetoothDeviceState>(
              stream: device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (c, snapshot) {
                VoidCallback? onPressed;
                String text;
                switch (snapshot.data) {
                  case BluetoothDeviceState.connected:
                    onPressed = () => device.disconnect();
                    text = 'DISCONNECT';
                    break;
                  case BluetoothDeviceState.disconnected:
                    onPressed = () => device.connect();
                    text = 'CONNECT';
                    break;
                  default:
                    onPressed = null;
                    text = snapshot.data.toString().substring(21).toUpperCase();
                    break;
                }
                return TextButton(
                    onPressed: onPressed,
                    child: Text(
                      text,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .labelLarge
                          ?.copyWith(color: Colors.white),
                    ));
              },
            )
          ],
        ),
      ),
      body: HomePageHook(services: services),
    );
  }

  Stream<int> rssiStream() async* {
    var isConnected = true;
    final subscription = device.state.listen((state) {
      isConnected = state == BluetoothDeviceState.connected;
    });
    while (isConnected) {
      yield await device.readRssi();
      await Future.delayed(const Duration(seconds: 10));
    }
    subscription.cancel();
    // Device disconnected, stopping RSSI stream
  }
}

var col = [
  const Color.fromARGB(208, 0, 4, 14),
  const Color.fromARGB(195, 0, 4, 14),
  const Color.fromARGB(255, 255, 193, 7),
  const Color.fromARGB(255, 255, 255, 255),
  const Color.fromARGB(255, 69, 71, 80)
];

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         useMaterial3: true,
//         fontFamily: GoogleFonts.lato().fontFamily,
//       ),
//       home: const HomePageHook(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

class HomePageHook extends HookWidget {
  const HomePageHook({super.key, required this.services});

  final List<BluetoothService> services;

  @override
  Widget build(BuildContext context) {
    void writeToBLE(List<BluetoothService> services, String instruction) async {
      services.forEach(
        (service) async {
          var characteristics = service.characteristics;
          for (BluetoothCharacteristic c in characteristics) {
            await c.write(utf8.encode(instruction));
            break;
          }
        },
      );
    }

    final page = useState(0);
    final power = useState(0.0);
    final powerInt = useState(0);
    final onOff = useState(false);
    final lockPos = useState(false);
    final isPlaying = useState(false);
    final intOfSteps = useState(1);

    // final toggleChange = useState(false);

    var stepQueryState =
        List.generate(15, (_) => List.generate(5, (_) => useState(false)));

    var secondsState = List.generate(15, (_) => useState(0));

    var toggleChangeStates = [
      useState(false),
      useState(false),
      useState(false),
      useState(false),
      useState(false),
    ];

    // ISA
    // op codes
    // 01# - power value
    // 02# - page number
    // 03# - onOff state
    // 04# - lock state
    // 05# - play

    useEffect(() {
      powerInt.value = power.value.toInt();
      return null;
    }, [power.value]);
    useEffect(() {
      writeToBLE(services, "1#${powerInt.value}#\n");
      return null;
    }, [powerInt.value]);

    useEffect(() {
      writeToBLE(services, "2#${page.value}#\n");
      return null;
    }, [page.value]);

    useEffect(() {
      writeToBLE(services, "3#${(onOff.value == true) ? 1 : 0}#\n");
      return null;
    }, [onOff.value]);

    useEffect(() {
      writeToBLE(services, "4#${(lockPos.value == true) ? 1 : 0}#\n");

      return null;
    }, [lockPos.value]);

    useEffect(() {
      if (isPlaying.value == true) {
        String inst = "5#${intOfSteps.value}#1#";
        for (int i = 0; i < 15; i++) {
          int sum = 0;
          for (int j = 0; j < 5; j++) {
            sum = sum +
                (((stepQueryState[i][j].value) ? 1 : 0) * pow(2, j)).toInt();
          }
          inst = "$inst$sum#";
        }

        for (int i = 0; i < 15; i++) {
          inst = "$inst${secondsState[i].value}#";
        }

        inst = "$inst\n";

        print("isplaying");
        // print(inst);

        writeToBLE(services, inst);
      } else {
        String inst = "5#${intOfSteps.value}#0#\n";
        writeToBLE(services, inst);
      }

      return null;
    }, [isPlaying.value]);

    useEffect(() {
      // print("yeah boi change");
      // print([
      //   toggleChangeStates[0].value,
      //   toggleChangeStates[1].value,
      //   toggleChangeStates[2].value,
      //   toggleChangeStates[3].value,
      //   toggleChangeStates[4].value,
      // ]);

      String inst = "6#";
      for (int i = 0; i < 5; i++) {
        inst = "$inst${(toggleChangeStates[i].value) ? "1" : "0"}#";
      }

      inst = "$inst\n";
      writeToBLE(services, inst);
      return null;
    }, [
      toggleChangeStates[0].value,
      toggleChangeStates[1].value,
      toggleChangeStates[2].value,
      toggleChangeStates[3].value,
      toggleChangeStates[4].value,
    ]);

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
                        // power.value = value;
                      },
                      onChangeEnd: (value) {
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
                    ? StandardPageHook(toggleChangeStates: toggleChangeStates)
                    : CustomPageHook(
                        stepQueryState: stepQueryState,
                        isPlaying: isPlaying,
                        secondsState: secondsState,
                        intOfSteps: intOfSteps,
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




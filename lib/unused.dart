// import 'package:english_words/english_words.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'dart:async';
// import 'dart:math';

// import 'package:terra_flutter_rt/terra_flutter_rt.dart';
// import 'package:terra_flutter_rt/types.dart';
// import 'package:terra_flutter_rt/ios_controller.dart';

// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:tflite_flutter/tflite_flutter.dart';

// void main() async {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => MyAppState(),
//       child: MaterialApp(
//         title: 'Heart Rate forecasting App',
//         theme: ThemeData(
//           useMaterial3: true,
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
//         ),
//         home: MyHomePage(),
//       ),
//     );
//   }
// }

// class MyAppState extends ChangeNotifier {
//   var current = WordPair.random();

//   void getNext() {
//     current = WordPair.random();
//     notifyListeners();
//   }

//   var favorites = <WordPair>[];

//   void toggleFavorite() {
//     if (favorites.contains(current)) {
//       favorites.remove(current);
//     } else {
//       favorites.add(current);
//     }
//     notifyListeners();
//   }

//   List<TimeSeriesData> timeSeriesData = [];
//   List<TimeSeriesData> predictions = [];

//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlatformState() async {
//     const apiKey = 'MgSktcsVv188jn8gppDGfalX2SIsv4Wg4TznEunu';
//     const devId = 'leoapp-A8lrK0JoMR';
//     var headers = {'x-api-key': apiKey, 'dev-id': devId};
//     const connection = Connection.ble;
//     const datatypes = [DataType.heartRate];

//     // Initialise the library
//     await TerraFlutterRt.init(devId, "reference_id_flutter");

//     // Need to run this once only to register the device with Terra
//     // sdk token (DO THIS IN YOUR BACKEND)
//     var sdktoken = '';
//     var sdkrequest = http.Request(
//         'POST', Uri.parse('https://api.tryterra.co/v2/auth/generateAuthToken'));
//     sdkrequest.headers.addAll(headers);
//     http.StreamedResponse sdkresponse = await sdkrequest.send();
//     if (sdkresponse.statusCode == 200) {
//       sdktoken = json.decode(await sdkresponse.stream.bytesToString())['token'];
//     }
//     await TerraFlutterRt.initConnection(sdktoken);

//     // For BLE or WearOS connection, pull scanning widget to select a device
//     if (connection == Connection.ble ||
//         connection == Connection.wearOs ||
//         connection == Connection.ant ||
//         connection == Connection.allDevices) {
//       await TerraFlutterRt.startDeviceScan(connection, useCache: false);
//     }

//     // Start streaming either to server (using token) or locally (using callback)
//     await TerraFlutterRt.startRealtimeToApp(
//         connection, datatypes, dataCallback);
//     // await TerraFlutterRt.startRealtimeToServer(
//     //     connection, datatypes, websockettoken);

//     // After 15 seconds stop streaming and disconnect
//     //await Future.delayed(const Duration(seconds: 15));
//     //await TerraFlutterRt.stopRealtime(connection);
//     //await TerraFlutterRt.disconnect(connection);
//   }

//   int counter = 0;
//   void dataCallback(Update data) {
//     // print("Got data in app");
//     // print(data.ts);
//     // print(data.type.datatypeString);
//     // print(data.val);
//     // print(data.d);

//     int value;
//     if (data.val != null) {
//       value = data.val!.toInt();
//     } else {
//       value = -1;
//     }

//     // If timeSeriesData already has 120 elements, remove the first one
//     if (timeSeriesData.length == 120) {
//       timeSeriesData.removeAt(0);
//     }

//     timeSeriesData.add(TimeSeriesData(counter, value));
//     print(timeSeriesData.length);
//     counter++;
//     notifyListeners();
//   }

//   Interpreter? _interpreter;

//   Future<void> loadModel() async {
//     try {
//       _interpreter = await Interpreter.fromAsset("assets/baseline.tflite");
//       print('Model loaded successfully');
//     } catch (e) {
//       print("Failed to load model.");
//       print(e);
//     }
//   }

//   MyAppState() {
//     loadModel();
//     // create a variable as an input to the model which is a 1D array of length 120
//     var input = List.filled(120, 4.0);
//     // create a variable to store the output of the model
//     var output = List.filled(30, 0.0);

//     // run the model
//     _interpreter?.run(input, output);

//     // print the output
//     print(output);

//     initPlatformState();
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   var selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     Widget page;
//     switch (selectedIndex) {
//       case 0:
//         page = GeneratorPage();
//         break;
//       case 1:
//         page = TimeSeriesPage();
//         break;
//       default:
//         throw UnimplementedError('no widget for $selectedIndex');
//     }

//     return LayoutBuilder(builder: (context, constraints) {
//       return Scaffold(
//         body: Row(
//           children: [
//             SafeArea(
//               child: NavigationRail(
//                 extended: false,
//                 destinations: [
//                   NavigationRailDestination(
//                     icon: Icon(Icons.home),
//                     label: Text('Home'),
//                   ),
//                   NavigationRailDestination(
//                     icon: Icon(Icons.favorite),
//                     label: Text('Favorites'),
//                   ),
//                 ],
//                 selectedIndex: selectedIndex,
//                 onDestinationSelected: (value) {
//                   setState(() {
//                     selectedIndex = value;
//                   });
//                 },
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 color: Theme.of(context).colorScheme.primaryContainer,
//                 child: page,
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }

// class GeneratorPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();
//     var pair = appState.current;

//     IconData icon;
//     if (appState.favorites.contains(pair)) {
//       icon = Icons.favorite;
//     } else {
//       icon = Icons.favorite_border;
//     }

//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           BigCard(pair: pair),
//           SizedBox(height: 10),
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: () {
//                   appState.toggleFavorite();
//                 },
//                 icon: Icon(icon),
//                 label: Text('Like'),
//               ),
//               SizedBox(width: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   appState.getNext();
//                 },
//                 child: Text('Next'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class BigCard extends StatelessWidget {
//   const BigCard({
//     super.key,
//     required this.pair,
//   });

//   final WordPair pair;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final style = theme.textTheme.displayMedium!.copyWith(
//       color: theme.colorScheme.onPrimary,
//     );

//     return Card(
//       color: theme.colorScheme.primary,
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Text(
//           pair.asLowerCase,
//           style: style,
//           semanticsLabel: "${pair.first} ${pair.second}",
//         ),
//       ),
//     );
//   }
// }

// class TimeSeriesPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();

//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.only(top: 50),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(30.0),
//               child: SfCartesianChart(
//                   title: ChartTitle(text: "Heart Rate Data"),
//                   series: <ChartSeries>[
//                     LineSeries<TimeSeriesData, int>(
//                         dataSource: appState.timeSeriesData,
//                         xValueMapper: (TimeSeriesData hr, _) => hr.x,
//                         yValueMapper: (TimeSeriesData hr, _) => hr.y)
//                   ]),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(30.0),
//               child: SfCartesianChart(
//                   title: ChartTitle(text: "Predictions"),
//                   series: <ChartSeries>[
//                     LineSeries<TimeSeriesData, int>(
//                         dataSource: appState.timeSeriesData,
//                         xValueMapper: (TimeSeriesData hr, _) => hr.x,
//                         yValueMapper: (TimeSeriesData hr, _) => hr.y,
//                         color: Colors.orange)
//                   ]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class TimeSeriesData {
//   TimeSeriesData(this.x, this.y);
//   final int x;
//   final int y;
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:provider/provider.dart';
// import '../lib/app_state.dart';
// import '../lib/survey_page.dart';

// void main() {
//   group('SurveyPage', () {
//     late MyAppState myAppState;

//     setUp(() {
//       myAppState =
//           MyAppState(); // Assuming MyAppState has a default constructor
//     });

//     testWidgets('renders correctly', (WidgetTester tester) async {
//       await tester.pumpWidget(
//         ChangeNotifierProvider<MyAppState>.value(
//           value: myAppState,
//           child: MaterialApp(
//             home: SurveyPage(),
//           ),
//         ),
//       );

//       // Verifies the form elements and labels
//       expect(find.text('Enter your age'), findsOneWidget);
//       expect(find.text('Select your gender'), findsOneWidget);
//       expect(find.text('Submit'), findsOneWidget);
//     });

//     testWidgets('validates age input correctly', (WidgetTester tester) async {
//       await tester.pumpWidget(
//         ChangeNotifierProvider<MyAppState>.value(
//           value: myAppState,
//           child: MaterialApp(
//             home: SurveyPage(),
//           ),
//         ),
//       );

//       await tester.enterText(find.byType(TextFormField), '');
//       await tester.tap(find.text('Submit'));
//       await tester.pump();

//       // Checks for validation message
//       expect(find.text('Please enter your age'), findsOneWidget);

//       // Enter valid age
//       await tester.enterText(find.byType(TextFormField), '25');
//       await tester.tap(find.text('Submit'));
//       await tester.pump();

//       // Validation message should disappear
//       expect(find.text('Please enter your age'), findsNothing);
//     });

//     testWidgets('validates gender dropdown correctly',
//         (WidgetTester tester) async {
//       await tester.pumpWidget(
//         ChangeNotifierProvider<MyAppState>.value(
//           value: myAppState,
//           child: MaterialApp(
//             home: SurveyPage(),
//           ),
//         ),
//       );

//       // Select gender dropdown
//       await tester.tap(find.byType(DropdownButtonFormField));
//       await tester.pumpAndSettle();

//       // Select a gender
//       await tester.tap(find.text('Male').last);
//       await tester.pumpAndSettle();

//       // Verify the selection
//       expect(find.text('Male'), findsWidgets);
//     });
//   });

//   group('HRmax', () {
//     late MyAppState myAppState;

//     setUp(() {
//       myAppState =
//           MyAppState(); // Assuming MyAppState has a default constructor
//     });

//     testWidgets('renders correctly', (WidgetTester tester) async {
//       await tester.pumpWidget(
//         ChangeNotifierProvider<MyAppState>.value(
//           value: myAppState,
//           child: MaterialApp(
//             home: HRmax(),
//           ),
//         ),
//       );

//       // Verifies the HRmax text appears
//       expect(find.text('HR'), findsOneWidget);
//       expect(find.text('max'), findsOneWidget);
//     });

//     testWidgets('displays correct HRmax value', (WidgetTester tester) async {
//       myAppState.mhr = 150; // Assuming you have a setter for mhr in MyAppState

//       await tester.pumpWidget(
//         ChangeNotifierProvider<MyAppState>.value(
//           value: myAppState,
//           child: MaterialApp(
//             home: HRmax(),
//           ),
//         ),
//       );

//       // Verifies the HRmax value appears
//       expect(find.text(': 150'), findsOneWidget);
//     });
//   });
// }

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../lib/app_state.dart'; // Change to your main.dart file path
import '../lib/home_page.dart';
import '../lib/time_series_page.dart';

void main() {
  group('HomePage Widget Tests', () {
    testWidgets('HomePage Renders Correctly', (WidgetTester tester) async {
      // Wrap your HomePage in a ChangeNotifierProvider for the MyAppState
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => MyAppState(),
          child: MaterialApp(
            home: HomePage(),
          ),
        ),
      );

      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(BigCard), findsOneWidget);
    });

    testWidgets('BigCard Renders Correctly', (WidgetTester tester) async {
      // Provide some dummy data for BigCard
      final predictions = [
        TimeSeriesData(70, 70),
        TimeSeriesData(71, 70),
      ];

      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => MyAppState(),
          child: MaterialApp(
            home: BigCard(predictions: predictions),
          ),
        ),
      );

      expect(find.byType(BigCard), findsOneWidget);
    });
  });
}

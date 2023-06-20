import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../lib/app_state.dart';
import '../lib/time_series_page.dart';

void main() {
  group('TimeSeriesPage', () {
    testWidgets('renders correctly with provided data',
        (WidgetTester tester) async {
      // Given
      final timeSeriesData = [
        TimeSeriesData(1, 60),
        TimeSeriesData(2, 62),
        TimeSeriesData(3, 65),
      ];
      final predictionsData = [
        TimeSeriesData(1, 63),
        TimeSeriesData(2, 64),
        TimeSeriesData(3, 66),
      ];
      final appState = MyAppState()
        ..timeSeriesData = timeSeriesData
        ..predictions = predictionsData;

      // When
      await tester.pumpWidget(
        ChangeNotifierProvider<MyAppState>.value(
          value: appState,
          child: MaterialApp(home: TimeSeriesPage()),
        ),
      );

      // Then
      expect(find.byType(TimeSeriesPage), findsOneWidget);
      expect(find.byType(SfCartesianChart), findsNWidgets(2));

      final titleFinder = find.text('Heart Rate Data');
      expect(titleFinder, findsOneWidget);

      final predictionTitleFinder = find.text('Predictions');
      expect(predictionTitleFinder, findsOneWidget);
    });
  });
}

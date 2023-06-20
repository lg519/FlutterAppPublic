import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/home_page.dart';
import '../lib/survey_page.dart';
import '../lib/time_series_page.dart';
import '../lib/navigation_page.dart';
import '../lib/app_state.dart';
import '../lib/main.dart';
import 'package:provider/provider.dart';

void main() {
  group('NavigationPage Widget Tests', () {
    testWidgets('HomePage is displayed when first loaded',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<MyAppState>(
          create: (_) => MyAppState(),
          child: MaterialApp(home: NavigationPage()),
        ),
      );

      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(TimeSeriesPage), findsNothing);
      expect(find.byType(SurveyPage), findsNothing);
    });

    // testWidgets('TimeSeriesPage is displayed when second item is selected',
    //     (WidgetTester tester) async {
    //   await tester.pumpWidget(
    //     ChangeNotifierProvider<MyAppState>(
    //       create: (_) => MyAppState(),
    //       child: MaterialApp(home: NavigationPage()),
    //     ),
    //   );

    //   await tester.tap(find.text('Favorites'));
    //   await tester.pumpAndSettle();

    //   expect(find.byType(HomePage), findsNothing);
    //   expect(find.byType(TimeSeriesPage), findsOneWidget);
    //   expect(find.byType(SurveyPage), findsNothing);
    // });

    testWidgets('SurveyPage is displayed when third item is selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<MyAppState>(
          create: (_) => MyAppState(),
          child: MaterialApp(home: NavigationPage()),
        ),
      );

      await tester.tap(find.text('Survey'));
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsNothing);
      expect(find.byType(TimeSeriesPage), findsNothing);
      expect(find.byType(SurveyPage), findsOneWidget);
    });
  });
}

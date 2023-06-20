import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'app_state.dart';

class TimeSeriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: SfCartesianChart(
                  title: ChartTitle(text: "Heart Rate Data"),
                  primaryXAxis:
                      NumericAxis(title: AxisTitle(text: 'Time (seconds)')),
                  primaryYAxis: NumericAxis(title: AxisTitle(text: 'Bpm')),
                  series: <ChartSeries>[
                    LineSeries<TimeSeriesData, int>(
                        dataSource: appState.timeSeriesData,
                        xValueMapper: (TimeSeriesData hr, _) => hr.x,
                        yValueMapper: (TimeSeriesData hr, _) => hr.y)
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: SfCartesianChart(
                  title: ChartTitle(text: "Predictions"),
                  primaryXAxis:
                      NumericAxis(title: AxisTitle(text: 'Time (seconds)')),
                  primaryYAxis: NumericAxis(title: AxisTitle(text: 'Bpm')),
                  series: <ChartSeries>[
                    LineSeries<TimeSeriesData, int>(
                        dataSource: appState.predictions,
                        xValueMapper: (TimeSeriesData hr, _) => hr.x,
                        yValueMapper: (TimeSeriesData hr, _) => hr.y,
                        color: Colors.orange)
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeSeriesData {
  TimeSeriesData(this.x, this.y);
  final int x;
  final int y;
}

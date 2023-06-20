import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:english_words/english_words.dart';

import 'time_series_page.dart';
import 'app_state.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var predictions = appState.predictions;

    IconData icon = Icons.favorite;
    // if (appState.favorites.contains(pair)) {
    //   icon = Icons.favorite;
    // } else {
    //   icon = Icons.favorite_border;
    // }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(predictions: predictions),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  print("pressed Like button");
                },
                icon: Icon(icon),
                label: Text(predictions.isNotEmpty
                    ? predictions[0].y.toString()
                    : "initializing..."),
              ),
              SizedBox(width: 10),
              // ElevatedButton.icon(
              //   onPressed: () {
              //     print("pressed Guidance button");
              //   },
              //   icon: Icon(Icons.fitness_center),
              //   label: Text("Guidance"), // Passing an empty container
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    Key? key,
    required this.predictions,
  }) : super(key: key);

  final List<TimeSeriesData> predictions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    var appState = Provider.of<MyAppState>(context, listen: true);
    int lowerHeartRate = (appState.mhr * 0.7).toInt();
    int upperHeartRate = (appState.mhr * 0.8).toInt();
    print("lowerHeartRate: $lowerHeartRate");
    print("upperHeartRate: $upperHeartRate");

    String displayText = "loading...";

    if (predictions.isNotEmpty) {
      for (var prediction in predictions) {
        if (prediction.y < lowerHeartRate) {
          displayText = "Faster!";
          break;
        } else if (prediction.y > upperHeartRate) {
          displayText = "Slow down!";
          break;
        } else {
          displayText = prediction.y.toString();
        }
      }
    }

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          displayText,
          style: style,
        ),
      ),
    );
  }
}

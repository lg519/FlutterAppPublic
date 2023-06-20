import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

import 'package:terra_flutter_rt/types.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'time_series_page.dart';
import 'terraAPI_service.dart';
import 'tflite_service.dart';

import 'minmaxscaler.dart';

class MyAppState extends ChangeNotifier {
  // Handle Survey state
  int userAge = 0;
  String? userGender;
  int mhr = 0;

  void setUserAge(int value) {
    userAge = value;
    notifyListeners();
  }

  void setUserGender(String? value) {
    userGender = value;
    notifyListeners();
  }

  // Initialize lists for time series data and predictions
  List<TimeSeriesData> timeSeriesData = [];
  List<int> timeSeriesDataForModelPrediction = [];
  List<TimeSeriesData> predictions = [];

  // Initialize interpreter and model output shape
  var modelOutput = List.filled(1 * 30 * 1, 0.0).reshape([1, 30, 1]);
  Interpreter? interpreter;
  bool isInterpreterLoaded = false;

  int counter = 0;
  void dataCallback(Update data) async {
    // print("Got data in app");
    // print(data.ts);
    // print(data.type.datatypeString);
    // print(data.val);
    // print(data.d);

    // Load model if it hasn't been loaded yet
    if (!isInterpreterLoaded) {
      interpreter = await loadModel();
      isInterpreterLoaded = true;
    }

    int heartRateValue;
    if (data.val != null) {
      heartRateValue = data.val!.toInt();
    } else {
      heartRateValue = -1;
    }

    // If timeSeriesData already has 120 elements, remove the first one
    if (timeSeriesData.length == 120) {
      timeSeriesData.removeAt(0);
    }

    // If timeSeriesDataForModelPrediction already has 120 elements,
    // perform inference and add the result to predictions.
    // Then remove the first element from timeSeriesDataForModelPrediction.
    if (timeSeriesDataForModelPrediction.length == 120) {
      // print("Performing inference");
      // Scale the data
      var scaledData = minMaxScaler(timeSeriesDataForModelPrediction, 20, 240);
      var modelInput = scaledData.reshape([1, 120, 1]);
      interpreter?.run(modelInput, modelOutput);
      var reshapedModelOutput = modelOutput.reshape([30]);
      // Apply inverse transform
      var scaledModelOutput = minMaxInverse(reshapedModelOutput, 20, 240);

      // print("Model input not preprocessed");
      // print(scaledData);
      // print("Model input:");
      // print(modelInput);
      // print("Model output:");
      // print(scaledModelOutput);

      // Store the predicted data
      predictions.clear();
      for (int i = 0; i < scaledModelOutput.length; i++) {
        predictions
            .add(TimeSeriesData(counter + i + 1, scaledModelOutput[i].toInt()));
      }

      timeSeriesDataForModelPrediction.removeAt(0);
    }

    timeSeriesData.add(TimeSeriesData(counter, heartRateValue));
    timeSeriesDataForModelPrediction.add(heartRateValue);
    counter++;
    notifyListeners();
  }

  MyAppState() {
    initPlatformState(dataCallback);
  }
}

import 'package:tflite_flutter/tflite_flutter.dart';

Future<Interpreter> loadModel() async {
  print("Trying to load model");
  Interpreter? interpreter; // Define interpreter outside the try-catch block

  try {
    // interpreter = await Interpreter.fromAsset("assets/baseline.tflite");
    // interpreter = await Interpreter.fromAsset("assets/LSTM.tflite");
    interpreter =
        await Interpreter.fromAsset("assets/LSTM_autoregressive.tflite");
    print('Model loaded successfully');
  } catch (e) {
    print("Failed to load model.");
    print(e);
  }

  if (interpreter == null) {
    throw Exception(
        "Model was not loaded successfully"); // Throw an exception if model wasn't loaded
  }

  return interpreter;

  // create a variable as an input to the model which is a 1D array of length 120
  // var input = List.filled(120, 4.0).reshape([1, 120, 1]);

  // // create list of shape [1,30,1] to store output
  // var output = List.filled(1 * 30 * 1, 0.0).reshape([1, 30, 1]);

  // // run the model
  // interpreter?.run(input, output);
  // output = output.reshape([30]);
  // print(output);
}

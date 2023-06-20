List<double> minMaxScaler(List<int> data, int min, int max) {
  List<double> scaledData = [];

  for (int val in data) {
    scaledData.add((val - min) / (max - min).toDouble());
  }

  return scaledData;
}

List<int> minMaxInverse(List<dynamic> scaledData, int min, int max) {
  List<int> originalData = [];

  for (double val in scaledData) {
    originalData.add(((val * (max - min)) + min).round());
  }

  return originalData;
}

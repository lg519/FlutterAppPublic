import 'package:flutter_test/flutter_test.dart';
import '../lib/minmaxscaler.dart';

void main() {
  group('minMaxScaler and minMaxInverse functions tests', () {
    test('minMaxScaler scales correctly', () {
      var data = [0, 1, 2, 3, 4, 5];
      var scaledData = minMaxScaler(data, 0, 5);

      expect(scaledData, [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]);
    });

    test('minMaxInverse inverses correctly', () {
      var scaledData = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0];
      var originalData = minMaxInverse(scaledData, 0, 5);

      expect(originalData, [0, 1, 2, 3, 4, 5]);
    });

    test('minMaxInverse reverses minMaxScaler correctly', () {
      var data = [0, 1, 2, 3, 4, 5];
      var scaledData = minMaxScaler(data, 0, 5);
      var originalData = minMaxInverse(scaledData, 0, 5);

      expect(originalData, data);
    });
  });
}

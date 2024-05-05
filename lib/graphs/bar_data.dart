import 'individual_bar.dart';
import 'dart:math';

class BarData {
  List<IndividualBar> barData = [];

  void initializeBarData(List<double> weeklySummary) {
    for (int i = 0; i < weeklySummary.length; i++) {
      barData.add(IndividualBar(x: i, y: weeklySummary[i] ++));
    }
  }
}
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class BarChartSample8 extends StatefulWidget {
  final double totalRevenue;

  BarChartSample8({required this.totalRevenue, Key? key}) : super(key: key);

  final Color barBackgroundColor = AppColors.contentColorWhite.withOpacity(0.3);
  final Color barColor = AppColors.contentColorWhite;

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample8> {
  double _totalRevenue = 0; // Inicialize com 0

  @override
  void initState() {
    super.initState();
    _totalRevenue = widget.totalRevenue;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const SizedBox(
              height: 32,
            ),
            BarChart(
              revenueData(_totalRevenue),
            ),
          ],
        ),
      ),
    );
  }

  BarChartData revenueData(double totalRevenue) {
    return BarChartData(
      maxY: totalRevenue + 10,
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: const FlTitlesData(
        show: true,
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 30,
            showTitles: true,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: [
        makeGroupData(0, totalRevenue),
      ],
      gridData: const FlGridData(show: false),
    );
  }

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.green,
          borderRadius: const BorderRadius.all(Radius.zero),
          width: 22,
        ),
      ],
    );
  }
}

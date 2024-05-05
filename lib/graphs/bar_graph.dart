import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'bar_data.dart';
import 'individual_bar.dart';

class BarGraph extends StatefulWidget {
  final List<double> weeklySummary;
  final List<DateTime> weeklyDates;
  final String selectedDuration;
  const BarGraph(
      {Key? key,
      required this.weeklySummary,
      required this.weeklyDates,
      required this.selectedDuration})
      : super(key: key);

  @override
  State<BarGraph> createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  @override
  Widget build(BuildContext context) {
    List<IndividualBar> barData = [];

    if (widget.selectedDuration == 'Hoje' ||
        widget.selectedDuration == 'Ultimos 6 dias' ||
        widget.selectedDuration == 'Ultimos 3 meses') {
      BarData semanaBarData = BarData();
      semanaBarData.initializeBarData(widget.weeklySummary);
      barData = semanaBarData.barData;
    }

    Widget getHoje(double value, TitleMeta meta) {
      const style = TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );

      if (widget.weeklyDates.isNotEmpty) {
        int index = value.toInt() % widget.weeklyDates.length;
        String formattedDate =
            DateFormat('HH:mm').format(widget.weeklyDates[index]);
        return Text(
          formattedDate,
          style: style,
        );
      } else {
        return Container();
      }
    }

    Widget getUltimaSemana(double value, TitleMeta meta) {
      const style = TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );

      if (widget.weeklyDates.isNotEmpty) {
        int index = value.toInt() % widget.weeklyDates.length;
        String formattedDate =
            DateFormat('dd/MM').format(widget.weeklyDates[index]);
        return Text(
          formattedDate,
          style: style,
        );
      } else {
        return Container();
      }
    }

    double maiorValor = 0;
    for (IndividualBar bar in barData) {
      if (bar.y > maiorValor) {
        setState(() {
          maiorValor = bar.y;
        });
      }
    }

    return BarChart(BarChartData(
      maxY: maiorValor * 1.1,
      minY: 0,
      barGroups: barData
          .map(
            (data) => BarChartGroupData(
              barRods: [
                BarChartRodData(
                  toY: data.y,
                  color: Colors.blueAccent,
                  width: maiorValor > 1000 ? 20 : 40,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
              ],
              x: data.x,
            ),
          )
          .toList(),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget:
                widget.selectedDuration == 'Hoje' ? getHoje : getUltimaSemana,
            reservedSize: 38,
          ),
        ),
        show: true,
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 30,
            showTitles: false,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 40,
            showTitles: true,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
      ),
      gridData: FlGridData(drawVerticalLine: false),
    ));
  }
}

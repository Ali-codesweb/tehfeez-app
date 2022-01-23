import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

// ignore: must_be_immutable
class CustomChart extends StatelessWidget {
  Map<String, double> dataMap;
  String title;
  CustomChart(this.dataMap,this.title);

  @override
  Widget build(BuildContext context) {
    final List<Color> colorList = [Theme.of(context).primaryColor, Colors.grey];
    return PieChart(
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 1000),
      // chartLegendSpacing: 12,

      chartRadius: MediaQuery.of(context).size.width / 2.8,
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: ChartType.ring,
      ringStrokeWidth: 17,
      centerText: title,
      legendOptions: LegendOptions(
        showLegends: false,
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: false,
        showChartValues: true,
        showChartValuesInPercentage: true,
        showChartValuesOutside: false,
        decimalPlaces: 0,
      ),
    );
  }
}

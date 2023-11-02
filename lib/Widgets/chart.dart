import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

Color hexToColor(String hexCode) {
  return Color(int.parse(hexCode, radix: 16) + 0xFF000000);
} //!colors

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <SplineSeries<SalesData, String>>[
          SplineSeries<SalesData, String>(
            color: hexToColor("FFD700"),
            width: 3,
            dataSource: <SalesData>[
              SalesData(100, "Mon"),
              SalesData(20, "Tue"),
              SalesData(40, "Wed"),
              SalesData(50, "Thu"),
              SalesData(15, "Sat"),
            ],
            xValueMapper: (SalesData sales, _) => sales.year,
            yValueMapper: (SalesData sales, _) => sales.sales,
          )
        ],
      ),
    );
  }
}

class SalesData {
  SalesData(this.sales, this.year);
  final String year;
  final int sales;
}

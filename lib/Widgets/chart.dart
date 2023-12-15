import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

Color hexToColor(String hexCode) {
  return Color(int.parse(hexCode, radix: 16) + 0xFF000000);
}

class DayAndWeekInfo {
  final String dayName;
  final int weekNumber;

  DayAndWeekInfo(this.dayName, this.weekNumber);
}

int getCurrentWeekNumber() {
  DateTime now = DateTime.now();
  DateTime beginningOfYear = DateTime(now.year, 1, 1);
  int days = now.difference(beginningOfYear).inDays;
  int currentWeekNumber = (days / 7).ceil();
  return currentWeekNumber;
}

int getWeekNumber(DateTime date) {
  // Find the first day of the year
  DateTime firstDayOfYear = DateTime(date.year, 1, 1);

  // Calculate the difference in days
  int days = date.difference(firstDayOfYear).inDays;

  // Calculate the week number
  int weekNumber = (days / 7).ceil();
  return weekNumber;
}

DayAndWeekInfo getDayAndWeekNumberFromTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  String dayName = DateFormat('EEEE').format(dateTime);
  int weekNumber = getWeekNumber(dateTime);

  return DayAndWeekInfo(dayName, weekNumber);
}

class Chart extends StatefulWidget {
  final List<QueryDocumentSnapshot>? transactions;
  int accountState;

  Chart({required this.transactions, required this.accountState, Key? key})
      : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  Widget build(BuildContext context) {
    LinearGradient seriesGradient = LinearGradient(
      colors: [
        widget.accountState == 0 ? hexToColor("FFD700") : Colors.blue,
        widget.accountState == 0 ? hexToColor("FFD700") : Colors.blue,
      ],
      stops: [0.0, 1.0],
    );

    int currentWeekNumber = getCurrentWeekNumber();

    List<SalesData> salesDataList = daysOfWeek.map((day) {
      var transactionsForDay = widget.transactions!
          .where((transaction) =>
              !transaction['buy'] &&
              getDayAndWeekNumberFromTimestamp(transaction['date']).dayName ==
                  day)
          .toList();

      double totalAmount = transactionsForDay.fold(0.0, (sum, transaction) {
        return sum + (transaction['amount'] ?? 0.0);
      });

      int weekNumber = 0;

      // Check if transactionsForDay is not empty before accessing its first element
      if (transactionsForDay.isNotEmpty) {
        weekNumber =
            getDayAndWeekNumberFromTimestamp(transactionsForDay.first['date'])
                .weekNumber;
      }

      return SalesData(
        day,
        totalAmount,
        weekNumber,
      );
    }).toList();

    return Container(
      width: MediaQuery.of(context).size.width - 10,
      height: 300,
      child: SfCartesianChart(
        enableAxisAnimation: true,
        primaryXAxis: CategoryAxis(
          labelRotation: 45,
          labelPlacement: LabelPlacement.betweenTicks,
          majorTickLines: MajorTickLines(size: 0),
          minorGridLines: MinorGridLines(width: 0),
          majorGridLines: MajorGridLines(width: 0.2),
          interval: 1,
        ),
        series: <ColumnSeries<SalesData, String>>[
          ColumnSeries<SalesData, String>(
            gradient: seriesGradient,
            animationDelay: 1,
            borderColor: Colors.black,
            borderWidth: 2,
            dataSource: salesDataList,
            xValueMapper: (SalesData sales, _) => sales.day,
            yValueMapper: (SalesData sales, _) => sales.sales,
            dataLabelSettings: DataLabelSettings(
              textStyle: TextStyle(color: Colors.grey),
              isVisible: false,
            ),
          )
        ],
      ),
    );
  }
}

class SalesData {
  SalesData(this.day, this.sales, this.weekNumber);
  final String day;
  final double sales;
  final int weekNumber;
}

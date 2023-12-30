import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

Color hexToColor(String hexCode) {
  return Color(int.parse(hexCode, radix: 16) + 0xFF000000);
}

class MonthInfo {
  final String monthName;
  final int year;

  MonthInfo(this.monthName, this.year);
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
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  TextEditingController yearController = TextEditingController();

  late int currentYear;
  late List<SalesData> salesDataList;

  @override
  void initState() {
    super.initState();
    currentYear = DateTime.now().year;
    yearController.text = currentYear.toString();
    salesDataList = updateSalesDataList(currentYear);
  }

  @override
  Widget build(BuildContext context) {
    LinearGradient seriesGradient = LinearGradient(
      colors: [
        widget.accountState == 0 ? hexToColor("FFD700") : Colors.blue,
        widget.accountState == 0 ? hexToColor("FFD700") : Colors.blue,
      ],
      stops: [0.0, 1.0],
    );

    return Container(
      width: MediaQuery.of(context).size.width - 10,
      height: 350,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    currentYear--;
                    yearController.text = currentYear.toString();
                    salesDataList = updateSalesDataList(currentYear);
                  });
                },
              ),
              SizedBox(
                width: 70,
                child: TextField(
                  controller: yearController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      currentYear = int.parse(value);
                      salesDataList = updateSalesDataList(currentYear);
                    });
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward, color: Colors.white),
                onPressed: () {
                  setState(() {
                    currentYear++;
                    yearController.text = currentYear.toString();
                    salesDataList = updateSalesDataList(currentYear);
                  });
                },
              ),
            ],
          ),
          SfCartesianChart(
            enableAxisAnimation: true,
            primaryXAxis: CategoryAxis(
              labelPlacement: LabelPlacement.betweenTicks,
              majorGridLines: MajorGridLines(width: 0.2),
              labelRotation: -45,
            ),
            series: <ColumnSeries<SalesData, String>>[
              ColumnSeries<SalesData, String>(
                gradient: seriesGradient,
                animationDelay: 1,
                borderColor: Colors.black,
                borderWidth: 2,
                dataSource: salesDataList,
                xValueMapper: (SalesData sales, _) => sales.month,
                yValueMapper: (SalesData sales, _) => sales.sales,
                dataLabelSettings: DataLabelSettings(
                  textStyle: TextStyle(color: Colors.grey),
                  isVisible: true,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  List<SalesData> updateSalesDataList(int year) {
    return months.map((month) {
      var transactionsForMonth = widget.transactions!
          .where((transaction) =>
              !transaction['buy'] &&
              getDayAndMonthNumberFromTimestamp(transaction['date'])
                      .monthName ==
                  month &&
              getDayAndMonthNumberFromTimestamp(transaction['date']).year ==
                  year)
          .toList();

      double totalAmount = transactionsForMonth.fold(0.0, (sum, transaction) {
        return sum + (transaction['amount'] ?? 0.0);
      });

      return SalesData(
        month,
        totalAmount,
        year,
      );
    }).toList();
  }

  MonthInfo getDayAndMonthNumberFromTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String monthName = DateFormat('MMMM').format(dateTime);
    int year = dateTime.year;

    return MonthInfo(monthName, year);
  }
}

class SalesData {
  SalesData(this.month, this.sales, this.year);
  final String month;
  final double sales;
  final int year;
}

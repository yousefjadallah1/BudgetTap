import 'package:budgettap/Widgets/bottomNavi.dart';
import 'package:budgettap/pages/loading_page.dart';
import 'package:budgettap/pages/signup_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../Widgets/auth_controller.dart';

Color hexToColor(String hexCode) {
  return Color(int.parse(hexCode, radix: 16) + 0xFF000000);
} //!colors

class SalaryPage extends StatefulWidget {
  const SalaryPage({Key? key}) : super(key: key);

  @override
  State<SalaryPage> createState() => _SalaryPageState();
}

class _SalaryPageState extends State<SalaryPage> {
  AuthController authController = Get.find();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController salaryController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData = {};
  List<String> accounts = ["Current", "Saving"];
  int accountState = 0;
  String selectedFrequency = "Monthly";
  double salaryAmount = 0.0;
  DateTime selectedStartDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Salary ",
          style: GoogleFonts.abel(
            fontSize: 35,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 20,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    accountState == 0 ? hexToColor("FFD700") : Colors.blue,
                    Colors.black,
                    // Colors.black,
                    // Colors.black,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20),
                  child: Text(
                    "Select Frequency:",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25, right: 10, left: 80),
                  child: DropdownButton<String>(
                    value: selectedFrequency,
                    onChanged: (value) {
                      setState(() {
                        selectedFrequency = value!;
                      });
                    },
                    items: ["Daily", "Monthly", "Weekly", "Yearly"]
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    dropdownColor: Colors.grey[900],
                  ),
                ),
              ],
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 20, left: 20),
            //   child: Text(
            //     "Enter Salary Amount:",
            //     style: TextStyle(color: Colors.white, fontSize: 18),
            //   ),
            // ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    salaryAmount = double.parse(value);
                  });
                },
                controller: salaryController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Salary Amount',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20),
              child: Text(
                "Select Start Date:",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedStartDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101), // Some arbitrary future date
                  );

                  if (picked != null && picked != selectedStartDate) {
                    setState(() {
                      selectedStartDate = picked;
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    '${selectedStartDate.day}/${selectedStartDate.month}/${selectedStartDate.year}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  await saveSalaryToFirestore();
                },
                child: Container(
                  width: double.infinity,
                  height: 35,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        10.0), // Adjust the radius as needed
                    color:
                        accountState == 0 ? hexToColor("FFD700") : Colors.blue,
                  ),
                  child: Text(
                    'Save Salary',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            //   child: ElevatedButton(
            //     onPressed: () async {
            //       // Save salary information to Firestore or perform necessary actions
            //       await saveSalaryToFirestore();
            //     },
            //     child: Text('Save Salary'),
            //   ),
            // ),
            Container(
              padding: EdgeInsets.only(top: 70),
              child: Center(
                child: Lottie.asset(
                  "assets/animation/salary.json",
                  width: 250,
                  height: 250,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveSalaryToFirestore() async {
    // Save salary details to Firestore
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .update({
      "Salary": {
        "Frequency": selectedFrequency,
        "Amount": salaryAmount,
        "StartDate": selectedStartDate,
      },
    });

    // Update balance based on salary frequency
    await updateBalance();
  }

  Future<void> updateBalance() async {
    DateTime currentDate = DateTime.now();
    DateTime nextSalaryDate = selectedStartDate;
    double amountToAdd = salaryAmount;

    while (nextSalaryDate.isBefore(currentDate)) {
      switch (selectedFrequency) {
        case "Daily":
          // If the frequency is daily, add salary every day
          await addSalaryToBalance(amountToAdd);
          nextSalaryDate = nextSalaryDate.add(Duration(days: 1));
          break;

        case "Weekly":
          // If the frequency is weekly, add salary every week
          await addSalaryToBalance(amountToAdd);
          nextSalaryDate = nextSalaryDate.add(Duration(days: 7));
          break;

        case "Monthly":
          // If the frequency is monthly, add salary every month
          await addSalaryToBalance(amountToAdd);
          nextSalaryDate = DateTime(nextSalaryDate.year,
              nextSalaryDate.month + 1, nextSalaryDate.day);
          break;

        case "Yearly":
          // If the frequency is yearly, add salary every year
          await addSalaryToBalance(amountToAdd);
          nextSalaryDate = DateTime(nextSalaryDate.year + 1,
              nextSalaryDate.month, nextSalaryDate.day);
          break;
      }
    }
    salaryController.clear();
    Navigator.pop(context);
    Get.to(BottomNavi());
  }

  Future<void> addSalaryToBalance(double amount) async {
    // Fetch the current balance
    var snapshot = await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .get();

    if (snapshot.exists) {
      double currentBalance =
          snapshot.data()?["Balance of Checking Account"] ?? 0.0;

      // Update the balance by adding the salary amount
      double newBalance = currentBalance + amount;

      // Update the Firestore document with the new balance
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser!.email)
          .update({
        "Balance of Checking Account": newBalance,
      });
    }
  }
}

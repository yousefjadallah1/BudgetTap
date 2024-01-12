import 'package:budgettap/Widgets/bottomNavi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
  // void initState() {
  //   //super.initState();
  //   updateBalance();
  // }

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
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    salaryAmount = double.tryParse(value) ?? 0.0;
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
                    lastDate: DateTime(2101),
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
                    borderRadius: BorderRadius.circular(10.0),
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

  Future<void> removeSalary() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .update({
      "NextSalaryDate": FieldValue.delete(),
      "NextUpdateDate": FieldValue.delete(),
      "Salary": {
        "Frequency": "None",
        "Amount": 0.0,
        //"StartDate": DateTime.now(),
      },
    });
  }

  Future<void> saveSalaryToFirestore() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          content: Center(
            child: LoadingAnimationWidget.discreteCircle(
              color: Colors.white,
              secondRingColor: hexToColor("FFD700"),
              thirdRingColor: Colors.blue,
              size: 80,
            ),
          ),
        );
      },
    );
    removeSalary();
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

    DateTime nextUpdateDate =
        calculateNextSalaryDate(selectedStartDate, selectedFrequency);

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .update({
      "NextUpdateDate": nextUpdateDate,
    });

    // Update balance based on salary frequency
    await updateBalance();
    salaryController.clear();
    Navigator.pop(context);
    Get.to(BottomNavi());
  }

  DateTime calculateNextSalaryDate(DateTime current, String frequency) {
    switch (frequency) {
      case "Daily":
        return current.add(Duration(days: 1));
      case "Weekly":
        return current.add(Duration(days: 7));
      case "Monthly":
        return DateTime(current.year, current.month + 1, current.day);
      case "Yearly":
        return DateTime(current.year + 1, current.month, current.day);
      default:
        return current; // none
    }
  }

  Future<void> updateBalance() async {
    DateTime currentDate = DateTime.now();
    DateTime nextSalaryDate = selectedStartDate;
    double amountToAdd = salaryAmount;

    // Retrieve the stored next update date from Firestore
    var snapshot = await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .get();

    if (snapshot.exists && snapshot.data()?["NextUpdateDate"] != null) {
      nextSalaryDate = snapshot.data()?["NextUpdateDate"].toDate();
    } else {
      nextSalaryDate = selectedStartDate;
    }

    // Check if the next update date has passed
    if (nextSalaryDate.isBefore(currentDate)) {
      await addSalaryToBalance(amountToAdd);

      // Calculate and store the next update date
      switch (selectedFrequency) {
        case "Daily":
          nextSalaryDate = nextSalaryDate.add(Duration(days: 1));
          break;
        case "Weekly":
          nextSalaryDate = nextSalaryDate.add(Duration(days: 7));
          break;
        case "Monthly":
          nextSalaryDate = DateTime(nextSalaryDate.year,
              nextSalaryDate.month + 1, nextSalaryDate.day);
          break;
        case "Yearly":
          nextSalaryDate = DateTime(nextSalaryDate.year + 1,
              nextSalaryDate.month, nextSalaryDate.day);
          break;
      }

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser!.email)
          .update({
        "NextUpdateDate": nextSalaryDate,
      });
    }
    salaryController.clear();
    Navigator.pop(context);
    Get.to(BottomNavi());
  }

  Future<void> addSalaryToBalance(double amount) async {
    var snapshot = await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .get();

    if (snapshot.exists) {
      double currentBalance =
          snapshot.data()?["Balance of Checking Account"] ?? 0.0;

      // Update the balance by adding the salary amount
      double newBalance = currentBalance + amount;

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser!.email)
          .update({
        "Balance of Checking Account": newBalance,
      });
    }
  }
}

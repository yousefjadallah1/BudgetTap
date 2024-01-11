// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:budgettap/pages/loading_page.dart';
import 'package:budgettap/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:budgettap/Widgets/auth_controller.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Color hexToColor(String hexCode) {
  return Color(int.parse(hexCode, radix: 16) + 0xFF000000);
} //!colors

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//!--------------------------------------------------------------------
class _MyHomePageState extends State<MyHomePage> {
  AuthController authController = Get.find();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final currentUser = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData = {};
  List accounts = ["Current", "Saving"];
  int accountState = 0;
  void signout() {
    authController.logout();
  }

  void goToProfilePage() {
    Navigator.pop(context);
    Get.to(() => ProfilePage());
  }

  void goToHome() {
    Navigator.pop(context);
  }

  Future<void> updateBalance(DateTime nextSalaryDate, double amountToAdd,
      String selectedFrequency) async {
    DateTime currentDate = DateTime.now();

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

  Future<void> updateBalanceFromSalary() async {
    // Get user data from Firestore
    var snapshot = await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;

      // Check if there is a salary start date
      DateTime? salaryStartDate = userData['Salary']['StartDate']?.toDate();

      if (salaryStartDate != null) {
        // Calculate the next salary date based on the frequency
        DateTime nextSalaryDate = salaryStartDate;

        // Update balance based on salary frequency
        await updateBalance(nextSalaryDate, userData['Salary']['Amount'],
            userData['Salary']['Frequency']);
      }
    }
  }

  Future<void> checkAndDeductOverdueBillsOnAppLaunch() async {
    DateTime currentDate = DateTime.now();

    var snapshot = await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      List<Map<String, dynamic>> bills = (userData['Bills'] as List<dynamic>?)
              ?.cast<Map<String, dynamic>>()
              .toList() ??
          [];

      // check if any bills is overdue
      for (var bill in bills) {
        Timestamp dueDateTimestamp = bill['dueDate'];
        DateTime dueDate = dueDateTimestamp.toDate();

        // Check if the bill is overdue
        if (!bill['deducted'] && currentDate.isAfter(dueDate)) {
          String selectedAccount = bill['account'];
          double amount = bill['amount'];

          await FirebaseFirestore.instance
              .collection("Users")
              .doc(currentUser?.email)
              .update({
            selectedAccount == "Current"
                ? "Balance of Checking Account"
                : "Balance of Saving Account": FieldValue.increment(-amount),
          });

          await FirebaseFirestore.instance
              .collection("Users")
              .doc(currentUser?.email)
              .update({
            "Bills": FieldValue.arrayRemove([bill]),
          });

          await FirebaseFirestore.instance
              .collection("Users")
              .doc(currentUser?.email)
              .update({
            "Bills": FieldValue.arrayUnion([
              {
                ...bill,
                'deducted': true,
              },
            ]),
          });
        }
      }
    }
  }

  Widget buildHeader() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 95,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Colors.black,
                Colors.black,
                Colors.black,
                accountState == 0 ? hexToColor("FFD700") : Colors.blue,
              ],
              begin: Alignment.center,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Stack(
            children: [
              
              Padding(
                padding: EdgeInsets.only(top: h * 0.035, left: w * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "BudgetTap",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontFamily: "Billabong"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ...List.generate(2, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      accountState = index;
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: accountState == index
                          ? index == 0
                              ? hexToColor("FFD700")
                              : Colors.blue
                          : Colors.grey,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      accounts[index],
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              })
            ],
          ),
        ),
      ],
    );
  }

  Widget buildCreditCardSection() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Positioned(
      top: h * 0.195,
      left: w * 0.05,
      right: w * 0.05,
      child: Container(
        width: 370,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          gradient: LinearGradient(
            colors: [
              Colors.black,
              hexToColor("FFD700"),
              Colors.black,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12.0,
              offset: Offset(0, 5),
              spreadRadius: 6,
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
                top: 30,
                left: 20,
                child: Text(
                  'Total Balance', 
                  style: TextStyle(color: Colors.white, fontSize: 17),
                )),
            Positioned(
                //!total balance
                top: 50,
                left: 20,
                child: Text(
                  '\$ ${userData?['Balance of Checking Account']?.toStringAsFixed(1)}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                )),
            Positioned(
              bottom: 20,
              left: 20,
              child: Text(
                userData?['Name'],
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Image.asset(
                'assets/img/visa.png', 
                width: 60,
                height: 30,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCreditCardSectionSaving() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Positioned(
      top: h * 0.195,
      left: w * 0.05,
      right: w * 0.05,
      child: Container(
        width: 370,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Colors.blue,
              Colors.black,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12.0,
              offset: Offset(0, 5),
              spreadRadius: 6,
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
                top: 30,
                left: 20,
                child: Text(
                  'Total Balance', // Your Visa logo asset
                  style: TextStyle(color: Colors.white, fontSize: 17),
                )),
            Positioned(
                //!total balance
                top: 50,
                left: 20,
                child: Text(
                  '\$ ${userData?['Balance of Saving Account']}', // Your Visa logo asset
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                )),
            Positioned(
              bottom: 20,
              left: 20,
              child: Text(
                userData?['Name'],
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Image.asset(
                'assets/img/visa.png', // Your Visa logo asset
                width: 60,
                height: 30,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTransactions() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          //!transaction
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accountState == 0 ? hexToColor("FFD700") : Colors.blue,
                  Colors.black,
                  Colors.black,
                  Colors.black,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.center,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Transactions",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(currentUser!.email)
              .collection(
                  accountState == 0 ? "Transactions" : "Transactions Saving")
              .orderBy('createdAt', descending: true)
              .limit(5)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<QueryDocumentSnapshot> transactions = snapshot.data!.docs;

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    var transaction =
                        transactions[index].data() as Map<String, dynamic>;

                    return ListTile(
                      leading: Image.asset(
                        "assets/addings/${transaction['name']}.png",
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        transaction['name'],
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        formatTransactionDate(transaction['date'].toDate()),
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Text(
                        "\$ ${transaction['amount'].toString()}",
                        style: TextStyle(
                          color: transaction['buy'] ? Colors.green : Colors.red,
                          fontSize: 19,
                        ),
                      ),
                    );
                  },
                  childCount: transactions.length,
                ),
              );
            } else if (snapshot.hasError) {
              return SliverToBoxAdapter(
                child: Center(
                  child: Text('Error ${snapshot.error.toString()}'),
                ),
              );
            } else {
              return SliverToBoxAdapter(
                child: AlertDialog(
                  backgroundColor: Colors.black,
                  elevation: 0.0,
                  content: Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: accountState == 0
                          ? hexToColor("FFD700")
                          : Colors.blue,
                      size: 50,
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  String formatTransactionDate(DateTime transactionDate) {
    DateTime now = DateTime.now();
    DateTime yesterday = DateTime.now().subtract(Duration(days: 1));

    if (transactionDate.year == now.year &&
        transactionDate.month == now.month &&
        transactionDate.day == now.day) {
      return 'Today';
    } else if (transactionDate.year == yesterday.year &&
        transactionDate.month == yesterday.month &&
        transactionDate.day == yesterday.day) {
      return 'Yesterday';
    } else {
      return '${transactionDate.year} / ${transactionDate.month} / ${transactionDate.day}';
    }
  }

  @override
  void initState() {
    super.initState();

    checkAndDeductOverdueBillsOnAppLaunch();
    FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;

        DateTime? salaryStartDate = userData['Salary']['StartDate']?.toDate();

        if (salaryStartDate != null) {
          DateTime nextSalaryDate = salaryStartDate;

          if (nextSalaryDate.isAfter(DateTime.now())) {
            await updateBalance(nextSalaryDate, userData['Salary']['Amount'],
                userData['Salary']['Frequency']);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // double w = MediaQuery.of(context).size.width;
    // double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: hexToColor("000000"),
      key: scaffoldKey,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser?.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //loading screen
            return LoadingScreen();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error ${snapshot.error.toString()}'),
            );
          } else if (snapshot.hasData && snapshot.data!.exists) {
            userData = snapshot.data!.data() as Map<String, dynamic>;
            return SafeArea(
              child: Stack(
                children: [
                  buildHeader(),
                  SizedBox(
                    height: 20,
                  ),
                  accountState == 0
                      ? buildCreditCardSection()
                      : buildCreditCardSectionSaving(),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.45,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: buildTransactions(),
                  ),
                ],
              ),
            );
          } else {
            return LoadingScreen();
          }
        },
      ),
    );
  }
}

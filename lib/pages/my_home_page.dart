// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:budgettap/Widgets/drawer.dart';
import 'package:budgettap/pages/loading_page.dart';
import 'package:budgettap/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:budgettap/Widgets/auth_controller.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  //final userName = FirebaseFirestore.instance.collection("Users").doc(currentUser!.email).
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
              Positioned(
                top: h * 0.039,
                left: w * 0.84,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Container(
                    //! settings
                    width: 40,
                    height: 40,
                    color: Colors.transparent,
                    child: IconButton(
                      icon: Icon(
                        Icons.notifications,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        scaffoldKey.currentState?.openEndDrawer();
                      },
                    ),
                  ),
                ),
              ),
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
                  'Total Balance', // Your Visa logo asset
                  style: TextStyle(color: Colors.white, fontSize: 17),
                )),
            Positioned(
                //!total balance
                top: 50,
                left: 20,
                child: Text(
                  '\$ ${userData?['Balance of Checking Account']}', // Your Visa logo asset
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
    //double w = MediaQuery.of(context).size.width;
    //double h = MediaQuery.of(context).size.height;

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
                child: Center(child: CircularProgressIndicator()),
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
      // It's today
      return 'Today';
    } else if (transactionDate.year == yesterday.year &&
        transactionDate.month == yesterday.month &&
        transactionDate.day == yesterday.day) {
      // It's yesterday
      return 'Yesterday';
    } else {
      // It's a different day, format it as 'yyyy/MM/dd'
      return '${transactionDate.year} / ${transactionDate.month} / ${transactionDate.day}';
    }
  }

  @override
  Widget build(BuildContext context) {
    // double w = MediaQuery.of(context).size.width;
    // double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: hexToColor("000000"),
      key: scaffoldKey,
      endDrawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSingOutTap: signout,
        onHomePageTap: goToHome,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser?.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading screen while waiting for data
            return LoadingScreen();
          } else if (snapshot.hasError) {
            // Handle error
            return Center(
              child: Text('Error ${snapshot.error.toString()}'),
            );
          } else if (snapshot.hasData && snapshot.data!.exists) {
            // Check if the document exists before accessing its fields
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
            // Handle the case where there is no data or some fields are missing
            return LoadingScreen();
          }
        },
      ),
    );
  }
}

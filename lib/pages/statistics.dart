// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:budgettap/Widgets/auth_controller.dart';
import 'package:budgettap/Widgets/chart.dart';
import 'package:budgettap/Widgets/money_data.dart';
import 'package:budgettap/pages/loading_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

Color hexToColor(String hexCode) {
  return Color(int.parse(hexCode, radix: 16) + 0xFF000000);
} //!colors

String getDayNameFromTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  String dayName =
      DateFormat('EEEE').format(dateTime); // EEEE gives the full day name
  return dayName;
}

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

ValueNotifier kj = ValueNotifier(0);

class _StatisticsState extends State<Statistics> {
  AuthController authController = Get.find();
  List accounts = ["Current", "Saving"];

  final currentUser = FirebaseAuth.instance.currentUser;
  //final userName = FirebaseFirestore.instance.collection("Users").doc(currentUser!.email).
  Map<String, dynamic> userData = {};
  Map<String, dynamic> transaction = {};
  List day = ['Week', 'Month', 'Year'];
  int index_color = 0;
  int accountState = 0;
  List<QueryDocumentSnapshot>? transactions;
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(currentUser!.email)
              .collection(
                  accountState == 0 ? "Transactions" : "Transactions Saving")
              .orderBy('amount', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              transactions = snapshot.data!.docs;
              return SafeArea(
                  child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text("Statistics",
                            style: GoogleFonts.abel(
                              color: Colors.white,
                              fontSize: 40,
                            )),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: double.infinity,
                          height: 30,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                accountState == 0
                                    ? hexToColor("FFD700")
                                    : Colors.blue,
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
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 18,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ...List.generate(2, (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          accountState = index;
                                        });
                                      },
                                      child: Container(
                                        height: 45,
                                        width: 180,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: accountState == index
                                              ? index == 0
                                                  ? hexToColor("FFD700")
                                                  : Colors.blue
                                              : Colors.grey,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          accounts[index],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    );
                                  })
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 18,
                            ),
                          ],
                        ),

                        // SizedBox(height: 20),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 15),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     children: [
                        //       Container(
                        //         width: 120,
                        //         height: 40,
                        //         decoration: BoxDecoration(
                        //             borderRadius: BorderRadius.circular(10),
                        //             border: Border.all(
                        //                 color: hexToColor("FFD700"),
                        //                 width: 1.5)),
                        //         child: Row(
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceAround,
                        //           children: [
                        //             Text(
                        //               "Expense",
                        //               style: TextStyle(
                        //                   color: Colors.grey,
                        //                   fontSize: 16,
                        //                   fontWeight: FontWeight.w500),
                        //             ),
                        //             Icon(
                        //               Icons.arrow_downward_sharp,
                        //               color: Colors.grey,
                        //             )
                        //           ],
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        Chart(
                          transactions: transactions,
                          accountState: accountState,
                        ),

                        //! chart
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Top Spendings",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                              // Icon(
                              //   Icons.swap_vert,
                              //   color: Colors.grey,
                              //   size: 25,
                              // )
                            ],
                          ),
                        )
                      ], //!end
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      // Check if transactions is not null and index is within the valid range
                      if (transactions != null &&
                          index < transactions!.length) {
                        transaction =
                            transactions![index].data() as Map<String, dynamic>;
                        if (transaction['buy'] == false) {
                          return ListTile(
                            leading: Image.asset(
                              "assets/addings/${transaction['name']}.png",
                              width: 60, // Set your desired width
                              height: 60, // Set your desired height
                              fit: BoxFit.cover,
                            ),
                            title: Text(
                              transaction['name'],
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formatTransactionDate(
                                      transaction['date'].toDate()),
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  transaction['explain'].toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            trailing: Text(
                              transaction['amount'].toString(),
                              style: TextStyle(
                                color: transaction['buy']
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 19,
                              ),
                            ),
                            isThreeLine: true,
                          );
                        }
                      }
                      return SizedBox.shrink();
                    },
                    childCount: (transactions?.length ?? 0) > 5
                        ? 5
                        : (transactions?.length ?? 0),
                  )),
                ],
              ));
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error ${snapshot.error.toString()}'),
              );
            }
            return LoadingScreen();
          }),
    );
  }
}

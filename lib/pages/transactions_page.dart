import 'package:budgettap/pages/loading_page.dart';
import 'package:budgettap/pages/signup_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Widgets/auth_controller.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  AuthController authController = Get.find();
  final currentUser = FirebaseAuth.instance.currentUser;
  //final userName = FirebaseFirestore.instance.collection("Users").doc(currentUser!.email).
  Map<String, dynamic> userData = {};
  List accounts = ["Current", "Saving"];
  int accountState = 0;
  String selectedSortOption = 'Sort by Date';
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
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser!.email)
            .snapshots(),
        builder: (context, snapshot) {
          //get user data
          if (snapshot.hasData) {
            userData = snapshot.data!.data() as Map<String, dynamic>;

            return SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Transactions",
                          style: GoogleFonts.abel(
                            color: Colors.white,
                            fontSize: 40,
                          ),
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
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 18,
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
                                    height: 45,
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
                  ),
                  SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 180,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[950],
                            border: Border.all(
                              color:
                                  Colors.white, // Set the desired border color
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              padding: EdgeInsets.only(left: 10),
                              value: selectedSortOption,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedSortOption = newValue!;
                                  // Add logic to handle the selected sort option
                                  // For example, you can update the UI or trigger a callback
                                });
                              },
                              items: [
                                DropdownMenuItem<String>(
                                  value: 'Sort by Date',
                                  child: Text('Sort by Date',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white)),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'Sort by Most Recent',
                                  child: Text('Sort by Most Recent',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white)),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'Sort by Expenses',
                                  child: Text('Expenses',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white)),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'Sort by Revenue',
                                  child: Text('Revenues',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white)),
                                ),
                              ],
                              hint: Text(
                                selectedSortOption
                                    .toString(), // Display the selected value
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors
                                      .white), // Text style for the selected item
                              icon: Icon(Icons.arrow_drop_down,
                                  color: Colors.white), // Icon for the dropdown
                              iconSize: 24, // Size of the dropdown icon
                              isExpanded:
                                  true, // Make the dropdown button take the full width
                              dropdownColor: Colors
                                  .black, // Background color of the dropdown
                              elevation: 5, // Elevation of the dropdown
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Users")
                        .doc(currentUser!.email)
                        .collection(accountState == 0
                            ? "Transactions"
                            : "Transactions Saving")
                        .orderBy(
                          selectedSortOption == "Sort by Date"
                              ? 'date'
                              : selectedSortOption == 'Sort by Most Recent'
                                  ? 'createdAt'
                                  : 'date', 
                          descending: true,
                        )
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        transactions = snapshot.data!.docs;

                        // Filter transactions based on the selectedSortOption
                        transactions = transactions?.where((transaction) {
                          bool isExpense = !transaction['buy'];
                          bool isRevenue = transaction['buy'];

                          if (selectedSortOption == 'Sort by Expenses') {
                            return isExpense;
                          } else if (selectedSortOption == 'Sort by Revenue') {
                            return isRevenue;
                          } else {
                            return true; // Include all transactions for other sorting options
                          }
                        }).toList();

                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              var transaction = transactions?[index].data()
                                  as Map<String, dynamic>;
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
                                  "\$ ${transaction['amount'].toString()}",
                                  style: TextStyle(
                                    color: transaction['buy']
                                        ? Colors.green
                                        : Colors.red,
                                    fontSize: 19,
                                  ),
                                ),
                                isThreeLine: true,
                              );
                            },
                            childCount: transactions?.length,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return SliverToBoxAdapter(
                          child: Center(
                            child: Text('Error ${snapshot.error.toString()}'),
                          ),
                        );
                      } else {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: LoadingScreen(),
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error ${snapshot.error.toString()}'),
            );
          }
          return LoadingScreen();
        },
      ),
    );
  }
}

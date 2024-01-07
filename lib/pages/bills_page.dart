// ignore_for_file: prefer_const_constructors
import 'package:budgettap/pages/signup_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../Widgets/auth_controller.dart';

class Bills extends StatefulWidget {
  const Bills({super.key});

  @override
  State<Bills> createState() => _BillsState();
}

class _BillsState extends State<Bills> {
  TextEditingController billNameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  DateTime selectedDate = DateTime.now().add(Duration(days: 1));
  AuthController authController = Get.find();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final currentUser = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData = {};
  List accounts = ["Current", "Saving"];
  int accountState = 0;
  List<Map<String, dynamic>> bills = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101), // Some arbitrary future date
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> checkAndDeductOverdueBills() async {
    // Get the current date
    DateTime currentDate = DateTime.now();

    // Iterate through bills and check if any is overdue
    for (var bill in bills) {
      Timestamp dueDateTimestamp = bill['dueDate'];
      DateTime dueDate = dueDateTimestamp.toDate();

      // Check if the bill is overdue and not yet deducted
      if (!bill['deducted'] && currentDate.isAfter(dueDate)) {
        // Deduct the amount from the respective account balance
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

        // Update the bill to mark it as deducted
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

        // Fetch updated bills from Firestore
        await fetchBills();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text(
          "Bills",
          style: GoogleFonts.abel(fontSize: 35, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Column(
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
                                fontSize: 16, fontWeight: FontWeight.w600),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: billNameController,
                    decoration: InputDecoration(
                      labelText: 'Bill Name',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  TextFormField(
                    controller: amountController,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // ElevatedButton(
                  //   onPressed: () => _selectDate(context),
                  //   child: Text('Select Due Date'),
                  // ),
                  GestureDetector(
                    onTap: () async {
                      _selectDate(context);
                    },
                    child: Container(
                      width: 290,
                      height: 35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the radius as needed
                          color: Colors.white),
                      child: Text(
                        'Select Due Date',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      FocusScope.of(context).unfocus();

                      await addBillToFirestore();
                    },
                    child: Container(
                      width: 90,
                      height: 35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            10.0), // Adjust the radius as needed
                        color: accountState == 0
                            ? hexToColor("FFD700")
                            : Colors.blue,
                      ),
                      child: Text(
                        'Add Bill',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
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
                    "My Bills",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      Text(
                        "Paid  ",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "/",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "  Not",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: bills.length,
              itemBuilder: (context, index) {
                var bill = bills[index];
                Timestamp dueDateTimestamp = bill['dueDate'];
                DateTime dueDate = dueDateTimestamp.toDate();
                bool isDueDatePassed = DateTime.now().isAfter(dueDate);

                if ((accountState == 0 && bill['account'] == 'Current') ||
                    (accountState != 0 && bill['account'] == 'Saving')) {
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) async {
                      // Handle bill removal from Firestore
                      await removeBill(bill);
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 16),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        bill['name'],
                        style: TextStyle(
                          color: isDueDatePassed ? Colors.green : Colors.red,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Account: ${bill['account']}',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Date: ${DateFormat('MMMM d, y').format(dueDate)}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      trailing: Text(
                        "\$ ${bill['amount']}",
                        style: TextStyle(
                          color: isDueDatePassed ? Colors.green : Colors.red,
                          fontSize: 19,
                        ),
                      ),
                      isThreeLine: true,
                    ),
                  );
                } else {
                  // Return an empty container for items that should be hidden
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> addBillToFirestore() async {
    String billName = billNameController.text;
    double amount = double.parse(amountController.text);
    String selectedAccount = accounts[accountState];
    DateTime dueDate = selectedDate;

    // Check if the due date is in the past
    bool isDueDatePassed = DateTime.now().isAfter(dueDate);

    if (isDueDatePassed) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser?.email)
          .update({
        accountState == 0
            ? "Balance of Checking Account"
            : "Balance of Saving Account": FieldValue.increment(-amount),
      });
    }

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .update({
      "Bills": FieldValue.arrayUnion([
        {
          "name": billName,
          "amount": amount,
          "account": selectedAccount,
          "dueDate": dueDate,
          "deducted": isDueDatePassed,
        },
      ]),
    });

    // Fetch bills from Firestore after updating the document
    await fetchBills();

    // Clear the form after adding the bill
    billNameController.clear();
    amountController.clear();
  }

  @override
  void initState() {
    super.initState();
    fetchBills();
    checkAndDeductOverdueBills();
  }

  Future<void> fetchBills() async {
    try {
      // Retrieve bills from Firestore
      var snapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser?.email)
          .get();

      if (snapshot.exists) {
        userData = snapshot.data() as Map<String, dynamic>;
        if (userData!['Bills'] != null) {
          setState(() {
            bills = List<Map<String, dynamic>>.from(userData!['Bills']);
          });
        } else {
          // No bills found, handle this scenario (e.g., show a message)
          // For example, you could set bills to an empty list:
          setState(() {
            bills = [];
          });
        }
      }
    } catch (e) {
      // Handle exceptions, e.g., print the error
      print("Error fetching bills: $e");
    }
  }

  removeBill(Map<String, dynamic> bill) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .update({
      "Bills": FieldValue.arrayRemove([bill]),
    });
  }
}

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers, sort_child_properties_last

import 'package:budgettap/Widgets/auth_controller.dart';
import 'package:budgettap/Widgets/bottomNavi.dart';
import 'package:budgettap/pages/loading_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Color hexToColor(String hexCode) {
  return Color(int.parse(hexCode, radix: 16) + 0xFF000000);
} //!colors

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddState();
}

class _AddState extends State<AddPage> {
  AuthController authController = Get.find();
  final currentUser = FirebaseAuth.instance.currentUser;
  Map<String, dynamic> userData = {}; //! userData here
  Map<String, dynamic> transData = {}; //! transData here
  Map<String, dynamic> transDataForOtherAccount =
      {}; //! this for trans to other account

  String? selectedItem;
  String? selectedItem2;
  String? selectedItem3;
  bool? buy;
  DateTime date = DateTime.now();
  String? formattedDate;

  final TextEditingController explainController = TextEditingController();
  FocusNode exp = FocusNode();
  final TextEditingController amountController = TextEditingController();
  FocusNode _amount = FocusNode();
  final List<String> _item = [
    "Transfer between accounts",
    "Food",
    "Gas",
    "Gym",
    "Clothes",
    "Transfer",
    "Coffee",
    "Gift",
    "Grocerys",
    "Laundry",
    "Transportation",
    "Water and Electricity",
    "Others",
  ];
  final List<String> _item2 = [
    "revenue",
    "expenses",
  ];
  final List<String> _item3 = [
    "Current",
    "Saving",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    exp.addListener(() {
      setState(() {});
    });
    _amount.addListener(() {
      setState(() {});
    });
  }

  void _saveTransaction() async {
    // Validate if all required fields are filled
    if (selectedItem == null ||
        selectedItem2 == null ||
        amountController.text.isEmpty) {
      // You might want to show an error message or handle this case differently
      return;
    }

    if (buy == null) {
      buy = false;
    }

    // Prepare the transaction data
    transData = {
      'name': selectedItem,
      'how': selectedItem2,
      'explain': explainController.text,
      'amount': double.parse(amountController.text),
      'date': Timestamp.fromDate(date),
      'buy': buy,
      'createdAt': FieldValue.serverTimestamp(),
    };

    // Show loading screen while saving
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Center(
            child: LoadingAnimationWidget.flickr(
              leftDotColor: Colors.white,
              rightDotColor: hexToColor("FFD700"),
              size: 100,
            ),
          ),
        );
      },
    );
    //String? currentBalanceString = userData['Balance of Checking Account'];
    double currentBalance = selectedItem3 == "Current"
        ? userData['Balance of Checking Account']
        : userData['Balance of Saving Account'];

    double transferdAccountBalance = selectedItem3 == "Current"
        ? userData['Balance of Saving Account']
        : userData['Balance of Checking Account'];

    if (buy == true) {
      double transactionAmount = double.parse(amountController.text);
      currentBalance += transactionAmount;
    } else {
      double transactionAmount = double.parse(amountController.text);
      currentBalance -= transactionAmount;
    }
    //?? this is for the transfer between accounts
    if (selectedItem == "Transfer between accounts") {
      if (buy == true) {
        double transferAmount = double.parse(amountController.text);
        transferdAccountBalance -= transferAmount;
        //update the balance fot account that got the transaction
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser!.email)
            .update(selectedItem3 == "Current"
                ? {'Balance of Saving Account': transferdAccountBalance}
                : {'Balance of Checking Account': transferdAccountBalance});
        // add transaction
        transDataForOtherAccount = {
          'name': selectedItem,
          'how': "revenue",
          'explain': explainController.text,
          'amount': double.parse(amountController.text),
          'date': Timestamp.fromDate(date),
          'buy': !buy!,
          'createdAt': FieldValue.serverTimestamp(),
        };
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser!.email)
            .collection(selectedItem3 == "Current"
                ? "Transactions Saving"
                : "Transactions")
            .add(transDataForOtherAccount);
      } else {
        double transactionAmount = double.parse(amountController.text);
        transferdAccountBalance += transactionAmount;
        //update the balance fot account that got the transaction
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser!.email)
            .update(selectedItem3 == "Current"
                ? {'Balance of Saving Account': transferdAccountBalance}
                : {'Balance of Checking Account': transferdAccountBalance});
        // add transaction
        transDataForOtherAccount = {
          'name': selectedItem,
          'how': "revenue",
          'explain': explainController.text,
          'amount': double.parse(amountController.text),
          'date': Timestamp.fromDate(date),
          'buy': !buy!,
          'createdAt': FieldValue.serverTimestamp(),
        };
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser!.email)
            .collection(selectedItem3 == "Current"
                ? "Transactions Saving"
                : "Transactions")
            .add(transDataForOtherAccount);
      }
    }

    // Update Firestore with the transaction data
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .collection(
            selectedItem3 == "Current" ? "Transactions" : "Transactions Saving")
        .add(transData);

    // Update the balance in Firestore
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .update(selectedItem3 == "Current"
            ? {'Balance of Checking Account': currentBalance}
            : {'Balance of Saving Account': currentBalance});

    setState(() {
      selectedItem = null;
      selectedItem2 = null;
      explainController.clear();
      amountController.clear();
    });

    Get.to(BottomNavi());
  }

  @override
  Widget build(BuildContext context) {
    selectedItem3 ??= "Current";
    selectedItem2 ??= "expenses";
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
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    backgroundContainer(context),
                    Positioned(
                      top: 130,
                      child: mainContainer(),
                    )
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error ${snapshot.error.toString()}'),
              );
            }
            return LoadingScreen();
          }),
    );
  }

  Container mainContainer() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(255, 31, 31, 31).withOpacity(0.9)),
      height: 610,
      width: 350,
      child: Column(
        children: [
          SizedBox(height: 50),
          account(),
          SizedBox(height: 30),
          name(),
          SizedBox(height: 30),
          explain(),
          SizedBox(height: 30),
          amount(),
          SizedBox(height: 30),
          how(),
          SizedBox(height: 30),
          date_time(),
          SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              _saveTransaction();
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: selectedItem3 == "Current"
                    ? hexToColor("FFD700")
                    : Colors.blue,
              ),
              width: 120,
              height: 50,
              child: Text(
                "Save",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding account() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: Colors.white),
        ),
        child: DropdownButton<String>(
          underline: Container(),
          value: selectedItem3,
          items: _item3
              .map((e) => DropdownMenuItem(
                    child: Container(
                      child: Row(children: [
                        Container(
                          width: 40,
                          child: Image.asset("assets/img/$e.png"),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(e,
                            style: TextStyle(color: Colors.white, fontSize: 18))
                      ]),
                    ),
                    value: e,
                  ))
              .toList(),
          selectedItemBuilder: (BuildContext context) => _item3
              .map((e) => Row(
                    children: [
                      Container(
                        width: 42,
                        child: Image.asset("assets/img/$e.png"),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(e,
                          style: TextStyle(color: Colors.white, fontSize: 18))
                    ],
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedItem3 = value!;
              if (selectedItem3.toString() == 'revenue') {
                buy = true;
              } else {
                buy = false;
              }
            });
          },
          hint: Text(
            'Account',
            style: TextStyle(color: Colors.white),
          ),
          dropdownColor: Color.fromARGB(255, 31, 31, 31).withOpacity(0.9),
          isExpanded: true,
        ),
      ),
    );
  }

  Container date_time() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 2, color: Colors.white),
      ),
      width: 300,
      child: TextButton(
        onPressed: () async {
          DateTime? newdate = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
          );
          if (newdate != null) {
            setState(() {
              date = newdate;
              formattedDate = "${date.year} / ${date.month} / ${date.day}";
            });
          }
        },
        child: Text(
          "Date: ${date.year} / ${date.month} / ${date.day}",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Padding how() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: Colors.white),
        ),
        child: DropdownButton<String>(
          underline: Container(),
          value: selectedItem2,
          items: _item2
              .map((e) => DropdownMenuItem(
                    child: Container(
                      child: Row(children: [
                        Text(e,
                            style: TextStyle(color: Colors.white, fontSize: 18))
                      ]),
                    ),
                    value: e,
                  ))
              .toList(),
          selectedItemBuilder: (BuildContext context) => _item2
              .map((e) => Row(
                    children: [
                      Text(e,
                          style: TextStyle(color: Colors.white, fontSize: 18))
                    ],
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedItem2 = value!;
              if (selectedItem2.toString() == 'revenue') {
                buy = true;
              } else {
                buy = false;
              }
            });
          },
          hint: Text(
            'Source',
            style: TextStyle(color: Colors.white),
          ),
          dropdownColor: Color.fromARGB(255, 31, 31, 31).withOpacity(0.9),
          isExpanded: true,
        ),
      ),
    );
  }

  Padding amount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: 300,
        child: TextField(
          style: TextStyle(color: Colors.white),
          keyboardType: TextInputType.number,
          focusNode: _amount,
          controller: amountController,
          decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              labelText: 'Amount',
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 2, color: Colors.white)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 2, color: Colors.white))),
        ),
      ),
    );
  }

  Padding explain() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: 300,
        child: TextField(
          style: TextStyle(color: Colors.white),
          focusNode: exp,
          controller: explainController,
          decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              labelText: 'Note',
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 2, color: Colors.white)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 2, color: Colors.white))),
        ),
      ),
    );
  }

  Padding name() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: Colors.white),
        ),
        child: DropdownButton<String>(
          underline: Container(),
          value: selectedItem,
          items: _item
              .map((e) => DropdownMenuItem(
                    child: Container(
                      child: Row(children: [
                        Container(
                          width: 40,
                          child: Image.asset("assets/addings/$e.png"),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(e,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    selectedItem == "Transfer between accounts"
                                        ? 13
                                        : 16))
                      ]),
                    ),
                    value: e,
                  ))
              .toList(),
          selectedItemBuilder: (BuildContext context) => _item
              .map((e) => Row(
                    children: [
                      Container(
                        width: 42,
                        child: Image.asset("assets/addings/$e.png"),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(e,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  selectedItem == "Transfer between accounts"
                                      ? 13
                                      : 16))
                    ],
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedItem = value!;
            });
          },
          hint: Text(
            'Name',
            style: TextStyle(color: Colors.white),
          ),
          dropdownColor: Color.fromARGB(255, 31, 31, 31).withOpacity(0.9),
          isExpanded: true,
        ),
      ),
    );
  }

  Container backgroundContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          colors: [
            Colors.black,
            selectedItem3 == "Current" ? hexToColor("FFD700") : Colors.blue,
            Colors.black,
          ],
          begin: Alignment.center,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            //height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      Text("Adding",
                          style: GoogleFonts.abel(
                            color: Colors.white,
                            fontSize: 35,
                          )),
                      Icon(
                        Icons.attach_file,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

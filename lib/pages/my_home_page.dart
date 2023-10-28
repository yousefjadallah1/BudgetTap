// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:debit_credit_card_widget/debit_credit_card_widget.dart';
import 'package:budgettap/Widgets/drawer.dart';
import 'package:budgettap/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:budgettap/Widgets/auth_controller.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Color hexToColor(String hexCode) {
  return Color(int.parse(hexCode, radix: 16) + 0xFF000000);
}

class MyHomePage extends StatefulWidget {
  final String uid;

  MyHomePage({Key? key, required this.uid}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AuthController authController = Get.find();
  final currentUser = FirebaseAuth.instance.currentUser;
  //final userName = FirebaseFirestore.instance.collection("Users").doc(currentUser!.email).

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

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: hexToColor("000000"),
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   backgroundColor: Colors.transparent,
      //   centerTitle: true,
      //   title: Text("BudgetTap",
      //       style: TextStyle(fontSize: 35, fontFamily: 'Billabong')),
      //   actions: [],
      //   leading: Builder(
      //     builder: (BuildContext context) {
      //       return IconButton(
      //         icon: Icon(Icons.menu),
      //         onPressed: () {
      //           Scaffold.of(context).openDrawer(); // Open the drawer
      //         },
      //       );
      //     },
      //   ),
      // ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSingOutTap: signout,
        onHomePageTap: goToHome,
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(currentUser!.email)
              .snapshots(),
          builder: (context, snapshot) {
            //get user data
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;

              return SafeArea(
                  child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 240,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black,
                              Colors.black,
                              hexToColor("FFD700"),
                            ],
                            begin: Alignment.center,
                            end: Alignment.bottomCenter,
                          ),
                          //color: hexToColor("C2A400"),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
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
                                  width: 40,
                                  height: 40,
                                  color: Colors.transparent,
                                  child: Icon(
                                    Icons.notifications_outlined,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: h * 0.035, left: w * 0.02),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "BudgetTap",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontFamily: "Billabong"),
                                  ),
                                  // Text(
                                  //   userData['Name'],
                                  //   style: TextStyle(
                                  //       color: Colors.grey[100], fontSize: 20),
                                  // ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                      //! card
                      top: h * 0.16,
                      left: w * 0.08,
                      right: w * 0.08,
                      child: Container(
                        width: 350,
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
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17),
                                )),
                            Positioned(
                                //!total balance
                                top: 50,
                                left: 20,
                                child: Text(
                                  '\$ 1,924', // Your Visa logo asset
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                )),
                            Positioned(
                              bottom: 20,
                              left: 20,
                              child: Text(
                                userData['Name'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
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
                      ))
                ],
              )); //! end
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error ${snapshot.error.toString()}'),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}

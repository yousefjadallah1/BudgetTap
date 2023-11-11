// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:budgettap/Widgets/bottomNavi.dart';
import 'package:budgettap/Widgets/drawer.dart';
import 'package:budgettap/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:budgettap/Widgets/auth_controller.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:budgettap/pages/transactions_page.dart';

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
  final currentUser = FirebaseAuth.instance.currentUser;
  //final userName = FirebaseFirestore.instance.collection("Users").doc(currentUser!.email).
  Map<String, dynamic> userData = {}; // Declare userData here
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
                hexToColor("FFD700"),
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
                    //! notification
                    width: 40,
                    height: 40,
                    color: Colors.transparent,
                    child: GestureDetector(
                      onTap: () => signout(),
                      child: Icon(
                        Icons.logout,
                        size: 30,
                        color: Colors.white,
                      ),
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
      ],
    );
  }

  Widget buildCreditCardSection() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Positioned(
      top: h * 0.135,
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
                  '\$ ${userData['Balance of Checking Account']}', // Your Visa logo asset
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                )),
            Positioned(
              bottom: 20,
              left: 20,
              child: Text(
                userData['Name'],
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
                  hexToColor("FFD700"),
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
                    "Transactions History",
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
              .collection("Transactions")
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
                          "assets/addings/${transaction['name']}.png"),
                      title: Text(
                        transaction['name'],
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        transaction['date'].toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Text(
                        transaction['amount'].toString(),
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

  @override
  Widget build(BuildContext context) {
    // double w = MediaQuery.of(context).size.width;
    // double h = MediaQuery.of(context).size.height;

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
              .doc(currentUser?.email)
              .snapshots(),
          builder: (context, snapshot) {
            //get user data
            if (snapshot.hasData) {
              userData = snapshot.data?.data() as Map<String, dynamic>;
              return SafeArea(
                child: Stack(
                  children: [
                    buildHeader(),
                    buildCreditCardSection(),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.39,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: buildTransactions(),
                    ),
                  ],
                ),
              ); //! end
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

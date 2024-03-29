import 'package:budgettap/Widgets/auth_controller.dart';
import 'package:budgettap/Widgets/bottomNavi.dart';
import 'package:budgettap/Widgets/drawer.dart';
import 'package:budgettap/Widgets/textBoxSalary.dart';
import 'package:budgettap/Widgets/textbox_noEdit.dart';
import 'package:budgettap/Widgets/textbox_widget.dart';
import 'package:budgettap/pages/bills_page.dart';
import 'package:budgettap/pages/loading_page.dart';
import 'package:budgettap/pages/salary_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Color hexToColor(String hexCode) {
  return Color(int.parse(hexCode, radix: 16) + 0xFF000000);
} //!colors

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final currentUser = FirebaseAuth.instance.currentUser;
  AuthController authController = Get.find();
  final userCollections = FirebaseFirestore.instance.collection("Users");

  void signout() {
    authController.logout();
  }

  void goToBillsPage() {
    Get.to(() => Bills());
  }

  void goToHome() {
    Get.off(() => BottomNavi());
  }

  void goToSalaryPage() {
    Get.to(() => SalaryPage());
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

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              20.0), // Adjust the circular border radius here
        ),
        title: Text(
          "Edit $field",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        content: TextField(
          style: TextStyle(
            color: Colors.white,
          ),
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          //cancel
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(newValue);
            },
            child: Text("Save", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
    if (newValue.trim().length > 0) {
      await userCollections.doc(currentUser!.email).update({field: newValue});
    }
  }

  Future<void> editFieldDouble(String field) async {
    double newValue = 0.0;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              20.0), // Adjust the circular border radius here
        ),
        title: Text(
          "Edit $field",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        content: TextField(
          style: TextStyle(
            color: Colors.white,
          ),
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              try {
                // Attempt to parse the value as a double
                double parsedValue = double.parse(value);

                // Use the parsed value for further processing
                newValue = parsedValue;
              } catch (e) {
                // Handle the case where parsing fails (e.g., invalid input)
                print('Error parsing double: $e');
              }
            } else {
              // Handle the case where the value is empty
              print('Input is empty');
            }
          },
        ),
        actions: [
          //cancel
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(newValue);
            },
            child: Text("Save", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
    if (newValue > -900000000) {
      await userCollections.doc(currentUser!.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    //double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: Text("Profile page"),
      //   centerTitle: true,
      //   backgroundColor: Colors.grey[900],
      // ),
      key: scaffoldKey,
      endDrawer: MyDrawer(
        onBillsTap: goToBillsPage,
        onSingOutTap: signout,
        onSalaryTap: goToSalaryPage,
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
              var salaryData = userData!['Salary'];
              return ListView(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Text("Profile",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.abel(
                                  color: Colors.white,
                                  fontSize: 40,
                                )),
                          ],
                        ),
                      ),
                      Container(
                        //! settings
                        width: 40,
                        height: 40,
                        color: Colors.transparent,
                        margin: EdgeInsets.only(right: 20),
                        child: IconButton(
                          icon: Icon(
                            Icons.menu,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            scaffoldKey.currentState?.openEndDrawer();
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: 20,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          hexToColor("FFD700"),
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
                  SizedBox(
                    height: 30,
                  ),

                  //!user detial
                  Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: Text(
                      "Personal Details",
                      style: TextStyle(color: Colors.grey[300], fontSize: 17),
                    ),
                  ),

                  //Name
                  MyTextBox(
                    text: userData['Name'],
                    sectionName: "Name",
                    onPressed: () => editField("Name"),
                  ),
                  //email
                  MyTextBoxNoEdit(
                    text: currentUser!.email!,
                    sectionName: "Email",
                  ),
                  //Username
                  MyTextBox(
                    text: userData['Username'],
                    sectionName: "Username",
                    onPressed: () => editField("Username"),
                  ),
                  //! Balance Info
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: Text(
                      "Financial Details",
                      style: TextStyle(color: Colors.grey[300], fontSize: 17),
                    ),
                  ),
                  // balance
                  MyTextBox(
                    text: userData['Balance of Checking Account'].toString(),
                    sectionName: "Balance of Checking Account",
                    onPressed: () =>
                        editFieldDouble("Balance of Checking Account"),
                  ),
                  MyTextBox(
                    text: userData['Balance of Saving Account'].toString(),
                    sectionName: "Balance of Saving Account",
                    onPressed: () =>
                        editFieldDouble("Balance of Saving Account"),
                  ),
                  MyTextBoxSalary(
                    text: salaryData['Amount'].toString(),
                    sectionName: "Salary",
                    onPressed: () {
                      removeSalary();
                    },
                  ),
                  SizedBox(height: 20),
                ],
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
}

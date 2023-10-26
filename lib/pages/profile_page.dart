import 'package:budgettap/Widgets/auth_controller.dart';
import 'package:budgettap/Widgets/drawer.dart';
import 'package:budgettap/Widgets/textbox_widget.dart';
import 'package:budgettap/pages/my_home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  AuthController authController = Get.find();
  final userCollections = FirebaseFirestore.instance.collection("Users");

  void signout() {
    authController.logout();
  }

  void goToProfilePage() {
    Navigator.pop(context);
    //Get.to(() => ProfilePage());
  }

  void goToHome() {
    Get.off(() => MyHomePage(
          uid: currentUser!.uid,
        ));
  }

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text("Profile page"),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
      ),
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

              return ListView(
                children: [
                  //profile pic
                  const SizedBox(
                    height: 50,
                  ),
                  Icon(
                    Icons.person,
                    size: 72,
                  ),
                  SizedBox(height: 10),
                  //user email
                  Text(
                    currentUser!.email!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  SizedBox(height: 50),
                  //!user detial
                  Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: Text(
                      "Personal Details",
                      style: TextStyle(color: Colors.grey[600], fontSize: 15),
                    ),
                  ),
                  //username
                  MyTextBox(
                    text: userData['Name'],
                    sectionName: "Name",
                    onPressed: () => editField("Name"),
                  ),
                  //name
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
                      style: TextStyle(color: Colors.grey[600], fontSize: 15),
                    ),
                  ),
                  // balance
                  MyTextBox(
                    text: userData['Balance of Checking Account'],
                    sectionName: "Balance of Checking Account",
                    onPressed: () => editField("balance for Checking Account"),
                  ),
                  MyTextBox(
                    text: userData['Balance of Saving Account'],
                    sectionName: "Balance of Saving Account",
                    onPressed: () => editField("balance for Saving Account"),
                  ),
                  MyTextBox(
                    text: userData['Salary per month'],
                    sectionName: "Salary per month",
                    onPressed: () => editField("Salary"),
                  ),
                  SizedBox(height: 20),
                ],
              );
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

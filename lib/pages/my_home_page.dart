// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:budgettap/Widgets/drawer.dart';
import 'package:budgettap/pages/dms_page.dart';
import 'package:budgettap/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_metadata/font_awesome_metadata.dart';
import 'package:budgettap/Widgets/auth_controller.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePage extends StatefulWidget {
  final String uid;

  MyHomePage({Key? key, required this.uid}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AuthController authController = Get.find();

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
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: Text("Budget", style: TextStyle(fontSize: 25)),
        actions: [],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
            );
          },
        ),
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSingOutTap: signout,
        onHomePageTap: goToHome,
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: w,
            height: h * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.transparent,
            ),
            child: Text(widget.uid,
                style: TextStyle(fontSize: 15, color: Colors.black)),
          ),
        ],
      ),
    );
  }
}

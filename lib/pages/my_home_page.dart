// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:budgettap/pages/dms_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_metadata/font_awesome_metadata.dart';
import 'package:budgettap/Widgets/auth_controller.dart';
import 'package:get/get.dart';

class MyHomePage extends StatefulWidget {
  final String email;

  MyHomePage({Key? key, required this.email}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: false,
        title: Text(widget.email, style: TextStyle(fontSize: 25)),
        actions: [
          IconButton(
            //! Notifications
            onPressed: () {},
            icon: const Icon(FontAwesomeIcons.heart),
          ),
          IconButton(
            // ! DMs
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DMsPage()),
              );
            },
            icon: const Icon(Icons.abc),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: w,
            height: h * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.black,
            ),
            child: Text(widget.email,
                style: TextStyle(fontSize: 25, color: Colors.white)),
          ),
          Container(
            width: w,
            height: h * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.black,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                authController.logout();
              },
              child: Container(
                width: w * 0.5,
                height: h * 0.07,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    'Sign out',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

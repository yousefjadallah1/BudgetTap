// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:budgettap/Widgets/auth_controller.dart';
import 'package:budgettap/Widgets/myList_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSingOutTap;
  final void Function()? onHomePageTap;
  MyDrawer(
      {super.key,
      required this.onProfileTap,
      required this.onSingOutTap,
      required this.onHomePageTap});
  final currentUser = FirebaseAuth.instance.currentUser;
  AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //logo
          Column(
            children: [
              DrawerHeader(
                  child: Icon(
                Icons.person,
                color: Colors.white,
                size: 64,
              )),

              //home list
              MyListTile(
                  icon: Icons.home, text: "H O M E", ontap: onHomePageTap),
              //profile
              MyListTile(
                icon: Icons.person,
                text: "P R O F I L E",
                ontap: onProfileTap,
              ),
            ],
          ),
          //signout
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: MyListTile(
              icon: Icons.logout,
              text: "L O G O U T",
              ontap: onSingOutTap,
            ),
          ),
        ],
      ),
    );
  }
}

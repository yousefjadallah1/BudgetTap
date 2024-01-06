// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable
import 'package:budgettap/Widgets/auth_controller.dart';
import 'package:budgettap/Widgets/myList_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onBillsTap;
  final void Function()? onSingOutTap;
  final void Function()? onSalaryTap;
  MyDrawer(
      {super.key,
      required this.onBillsTap,
      required this.onSingOutTap,
      required this.onSalaryTap});
  final currentUser = FirebaseAuth.instance.currentUser;
  AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
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
              // MyListTile(
              //   icon: Icons.home,
              //   text: "H O M E",
              //   ontap: onHomePageTap,
              // ),
              // //profile
              // MyListTile(
              //   icon: Icons.bar_chart_outlined,
              //   text: "S T A T I S T I C S",
              //   ontap: onProfileTap,
              // ),
              // MyListTile(
              //   icon: Icons.swap_horiz,
              //   text: "T R A N S A C T I O N S",
              //   ontap: onProfileTap,
              // ),
              MyListTile(
                icon: Icons.receipt,
                text: "B I L L S",
                ontap: onBillsTap,
              ),
              MyListTile(
                icon: Icons.attach_money,
                text: "S A L A R Y",
                ontap: onSalaryTap,
              ),
            ],
          ),
          //signout

          Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 5),
              //   child: MyListTile(
              //     icon: Icons.settings,
              //     text: "S E T T I N G S",
              //     ontap: onSingOutTap,
              //   ),
              // ),
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
        ],
      ),
    );
  }
}

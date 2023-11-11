import 'package:budgettap/Widgets/auth_controller.dart';
import 'package:budgettap/pages/add_page.dart';
import 'package:budgettap/pages/my_home_page.dart';
import 'package:budgettap/pages/profile_page.dart';
import 'package:budgettap/pages/statistics.dart';
import 'package:budgettap/pages/transactions_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Color hexToColor(String hexCode) {
  return Color(int.parse(hexCode, radix: 16) + 0xFF000000);
} //!colors

class BottomNavi extends StatefulWidget {
  const BottomNavi({super.key});

  @override
  State<BottomNavi> createState() => _BottomNaviState();
}

class _BottomNaviState extends State<BottomNavi> {
  int index_color1 = 0;
  final currentUser = FirebaseAuth.instance.currentUser;
  AuthController authController = Get.find();

  List screens = [MyHomePage(), Statistics(), Transactions(), ProfilePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: screens[index_color1],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddPage());
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: hexToColor("FFD700"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.only(top: 6.5, bottom: 6.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color1 = 0;
                  });
                },
                child: Icon(
                  Icons.home,
                  size: 30,
                  color: index_color1 == 0 ? hexToColor("FFD700") : Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color1 = 1;
                  });
                },
                child: Icon(
                  Icons.bar_chart_outlined,
                  size: 30,
                  color: index_color1 == 1 ? hexToColor("FFD700") : Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color1 = 2;
                  });
                },
                child: Icon(
                  Icons.swap_horiz,
                  size: 30,
                  color: index_color1 == 2 ? hexToColor("FFD700") : Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color1 = 3;
                  });
                },
                child: Icon(
                  Icons.person,
                  size: 30,
                  color: index_color1 == 3 ? hexToColor("FFD700") : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

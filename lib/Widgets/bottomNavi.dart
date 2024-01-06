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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Get.to(() => AddPage());
      //   },
      //   child: Icon(
      //     Icons.add_outlined,
      //     color: Colors.black,
      //   ),
      //   backgroundColor: hexToColor("FFD700"),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
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
                  index_color1 == 0 ? Icons.home : Icons.home_outlined,
                  size: 30,
                  color: index_color1 == 0 ? Colors.white : Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color1 = 1;
                  });
                },
                child: Icon(
                  index_color1 == 1 ? Icons.bar_chart : Icons.bar_chart,
                  size: 30,
                  color: index_color1 == 1 ? Colors.white : Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => AddPage());
                },
                child: Icon(
                  Icons.add_box_outlined,
                  size: 40,
                  color: Colors.white,
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
                  color: index_color1 == 2 ? Colors.white : Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color1 = 3;
                  });
                },
                child: Icon(
                  index_color1 == 3 ? Icons.person : Icons.person_outlined,
                  size: 30,
                  color: index_color1 == 3 ? Colors.white : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

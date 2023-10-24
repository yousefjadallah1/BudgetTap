import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IntroScreen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: h * 0.2),
            child: Center(
              child: Lottie.asset(
                "assets/animation/intro11.json",
                width: w * 0.7,
                height: h * 0.3,
              ),
            ),
          ),
          SizedBox(height: h * 0.08),
          Container(
            child: Center(
              child: Text(
                "Welcome to BudgetTap",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontFamily: GoogleFonts.bebasNeue().fontFamily,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Center(
              child: Text(
                "Seamlessly track your expenses, set financial goals, and achieve financial freedom.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Color hexToColor(String hexCode) {
  return Color(int.parse(hexCode, radix: 16) + 0xFF000000);
}

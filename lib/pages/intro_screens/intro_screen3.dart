import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IntroScreen3 extends StatefulWidget {
  @override
  State<IntroScreen3> createState() => _IntroScreen3State();
}

class _IntroScreen3State extends State<IntroScreen3>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  bool clicked = false;
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
              child: GestureDetector(
                onTap: () {
                  if (clicked == false) {
                    clicked = true;
                    _controller.forward();
                  } else {
                    clicked = false;

                    _controller.reverse();
                  }
                },
                child: Lottie.asset(
                  "assets/animation/intro3.json",
                  width: w * 0.7,
                  height: h * 0.3,
                  controller: _controller,
                ),
              ),
            ),
          ),
          SizedBox(height: h * 0.08),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Center(
              child: Text(
                "Empower Finances.",
                textAlign: TextAlign.center,
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
                "We're here to simplify your budgeting journey. Let's start managing your finances wisely.",
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

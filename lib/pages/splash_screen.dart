import 'package:budgettap/Widgets/logo_widget.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: w,
        height: h,
        color: Colors.black,
        child: Center(
            child: LogoWidget(
          "assets/img/logo.png",
        )),
      ),
    );
  }
}



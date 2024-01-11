import 'package:budgettap/pages/intro_screens/intro_screen1.dart';
import 'package:budgettap/pages/intro_screens/intro_screen2.dart';
import 'package:budgettap/pages/intro_screens/intro_screen3.dart';
import 'package:budgettap/pages/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

Color hexToColor(String hexCode) {
  return Color(int.parse(hexCode, radix: 16) + 0xFF000000);
}

class WelcomePage extends StatefulWidget {
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  PageController _controller = PageController();

  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    // double w = MediaQuery.of(context).size.width;
    // double h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  onLastPage = (index == 2);
                });
              },
              children: [
                IntroScreen1(),
                IntroScreen2(),
                IntroScreen3(),
              ],
            ),
            Container(
                alignment: Alignment(0, 0.75),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      onLastPage
                          ? Text("    ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ))
                          : GestureDetector(
                              onTap: () {
                                _controller.jumpToPage(2);
                              },
                              child: Text("skip",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  )),
                            ),
                      //page Indicator
                      SmoothPageIndicator(
                        controller: _controller,
                        count: 3,
                      ),
                      //next
                      onLastPage
                          ? GestureDetector(
                              onTap: () {
                                Get.off(() => SignInPage());
                              },
                              child: Text("done",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  )),
                            )
                          : GestureDetector(
                              onTap: () {
                                _controller.nextPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeIn);
                              },
                              child: Text("next",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  )),
                            ),
                    ],
                  ),
                ))
          ],
        ));
  }
}

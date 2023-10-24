// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:budgettap/pages/signin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:budgettap/Widgets/logo_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

Color hexToColor(String hexCode) {
  return Color(int.parse(hexCode, radix: 16) + 0xFF000000);
}

class ForgetPassword extends StatefulWidget {
  @override
  State<ForgetPassword> createState() => _SignInPageState();
}

class _SignInPageState extends State<ForgetPassword> {
  var emailController = TextEditingController();

  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Get.snackbar(
        "About reset",
        "reset message",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText:
            const Text("Reset Success", style: TextStyle(color: Colors.white)),
        messageText: Text(
          "Reset password link sent. check your email!",
          style: const TextStyle(color: Colors.white),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      Get.snackbar(
        "About reset",
        "reset message",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText:
            const Text("Reset Failed", style: TextStyle(color: Colors.white)),
        messageText: Text(
          e.message.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    //double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: hexToColor("C9C9C9"),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: w * 0.3,
                child: LogoWidget(
                  "assets/img/logoB_noback.png",
                ),
                //height: h * 0.2,
              ),
              SizedBox(height: 60),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Center(
                  child: Text(
                    "RESET PASSWORD",
                    style: TextStyle(
                      fontSize: 48,
                      color: Colors.black,
                      fontFamily: GoogleFonts.bebasNeue().fontFamily,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.only(left: 18),
                child: Center(
                  child: Text(
                    "Enter your email and we will send you a password rest link",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      // fontFamily: GoogleFonts.bebasNeue().fontFamily,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.only(
                  left: 18.0,
                  right: 18.0,
                ),
                //!email
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.black,
                    ),
                    hintText: 'Email',
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 1.0)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: () => {passwordReset()},
                child: Center(
                  child: Container(
                      margin: EdgeInsets.only(
                        left: 18.0,
                        right: 18.0,
                      ),
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black,
                      ),
                      child: Center(
                        child: Text(
                          'Reset password',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      )),
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Go back",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Get.to(() => SignInPage()),
                    style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

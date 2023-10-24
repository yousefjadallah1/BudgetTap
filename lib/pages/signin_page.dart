// ignore_for_file: prefer_const_constructors

import 'package:budgettap/pages/forget_password_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:budgettap/Widgets/auth_controller.dart';
import 'package:budgettap/Widgets/logo_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'signup_page.dart';

Color hexToColor(String hexCode) {
  return Color(int.parse(hexCode, radix: 16) + 0xFF000000);
}

class SignInPage extends StatefulWidget {
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
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
              SizedBox(height: h * 0.02),
              Text(
                "HELLO AGAIN",
                style: TextStyle(
                  fontSize: 48,
                  color: Colors.white,
                  fontFamily: GoogleFonts.bebasNeue().fontFamily,
                ),
              ),
              Text(
                "Welcome back, sign in to continue",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: h * 0.02),
              Container(
                margin: EdgeInsets.only(
                  left: 18.0,
                  right: 18.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
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
                        borderSide: BorderSide(color: Colors.transparent)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 1.0)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: h * 0.01),
              Container(
                margin: EdgeInsets.only(
                  left: 18.0,
                  right: 18.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.vpn_key, color: Colors.black),
                    hintText: 'Password',
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 1.0)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: h * 0.005),
              GestureDetector(
                onTap: () {
                  Get.to(() => ForgetPassword());
                },
                child: Container(
                  margin: EdgeInsets.only(right: h * 0.02),
                  child: Row(
                    children: [
                      Expanded(child: Container()),
                      Text(
                        "forgot password?",
                        style: TextStyle(
                          fontSize: h * 0.020,
                          color: Colors.blue,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: h * 0.01),
              GestureDetector(
                onTap: () => AuthController.instance.login(
                    emailController.text.trim(),
                    passwordController.text.trim()),
                child: Container(
                  margin: EdgeInsets.only(
                    left: 18.0,
                    right: 18.0,
                  ),
                  height: h * 0.07,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(h * 0.02),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: h * 0.025,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
              SizedBox(height: h * 0.03),
              GestureDetector(
                onTap: () {
                  AuthService().signInWithGoogle(context, (String email) {});
                },
                child: CircleAvatar(
                  radius: 25,
                  // ignore: prefer_interpolation_to_compose_strings
                  backgroundImage: AssetImage('assets/img/google_logo.png'),
                  backgroundColor: Colors.white,
                ),
              ),
              SizedBox(height: h * 0.03),
              RichText(
                text: TextSpan(
                  text: "Don't have an account?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: h * 0.02,
                  ),
                  children: [
                    TextSpan(
                      text: " Create",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.to(() => SignUpPage());
                        },
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: h * 0.022,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:budgettap/pages/signin_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:budgettap/Widgets/auth_controller.dart';
import 'package:budgettap/Widgets/logo_widget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Color hexToColor(String hexCode) {
  return Color(int.parse(hexCode, radix: 16) + 0xFF000000);
}

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final List<String> images = [
    'apple_logo.png',
    'facebook_logo.png',
    'google_logo.png'
  ];

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var reEnterPasswordController = TextEditingController();
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
              SizedBox(height: 10),
              Center(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontFamily: GoogleFonts.bebasNeue().fontFamily,

                    ///fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 15),

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
              SizedBox(height: 5),

              Container(
                //! password
                margin: EdgeInsets.only(
                  left: 18.0,
                  right: 18.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.vpn_key, color: Colors.black),
                    hintText: 'Password',
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 1.0)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 1.0)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                margin: EdgeInsets.only(
                  left: 18.0,
                  right: 18.0,
                ),
                //!reEnterPasswordController
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  obscureText: true,
                  controller: reEnterPasswordController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.vpn_key_outlined,
                      color: Colors.black,
                    ),
                    hintText: 'Re-enter password',
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
                onTap: () {
                  AuthController.instance.register(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                    reEnterPasswordController.text.trim(),
                  );
                },
                child: Center(
                  child: Container(
                      margin: EdgeInsets.only(
                        left: 18.0,
                        right: 18.0,
                      ),
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black),
                        ),
                      )),
                ),
              ),
              SizedBox(height: w * 0.08),
              Center(
                child: Text(
                  "Sign up using one of the following methods",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    //fontWeight: FontWeight.bold
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Center(
                  child: Wrap(
                children: List.generate(3, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                        radius: 25,
                        // backgroundColor: hexToColor("A17639"),
                        child: CircleAvatar(
                          radius: 25,
                          // ignore: prefer_interpolation_to_compose_strings
                          backgroundImage:
                              AssetImage('assets/img/' + images[index]),
                          backgroundColor: Colors.white,
                        )),
                  );
                }),
              )),
              SizedBox(
                height: h * 0.01,
              ),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "already have an account",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Get.to(() => SignInPage()),
                    style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue),
                  ),
                ),
              ),
              // Add other widgets here
              // For example:
              // TextField(controller: emailController),
              // TextField(controller: passwordController),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:budgettap/Widgets/bottomNavi.dart';
import 'package:budgettap/pages/welcome_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  //email. name, password.....
  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    //user will be notified[]
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);
  }

  _initialScreen(User? user) {
    if (user == null) {
      print("Login page");
      Get.off(() => WelcomePage());
    } else {
      Get.off(() => BottomNavi());
    }
  }

  Future<void> register(
    String emailConroller,
    String passwordController,
    String reEnterPassword,
    String nameController,
  ) async {
    if (passwordController != reEnterPassword) {
      // Passwords do not match
      Get.snackbar(
        "Password Mismatch",
        "Please make sure your passwords match.",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text("Error", style: TextStyle(color: Colors.white)),
      );
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailConroller,
        password: passwordController,
      );
      DateTime date = DateTime.now();

      FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'Username': emailConroller.split("@")[0],
        'Name': nameController,
        'Balance of Checking Account': 0.0,
        'Balance of Saving Account': 0.0,
        'Salary': {
          'Amount': 0.0,
          'Frequency': 'Monthly',
          'StartDate': date, // You might want to set a default value here
        },
      });
      // Get the user ID (UID)
      // String uid = userCredential.user!.uid;

      // Navigate to the desired screen after successful registration if needed
    } on FirebaseAuthException catch (e) {
      // Registration failed
      Get.snackbar(
        "Account Creation Failed",
        e.message!,
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text("Error", style: TextStyle(color: Colors.white)),
      );
    }
  }

  Future<void> login(String email, String password) async {
    
    try {
      
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(
          "Error code: ${(e as FirebaseAuthException).code}"); // Add this line for debugging

      late String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = "User not found. Please register first.";
          break;
        case 'wrong-password':
          errorMessage = "Incorrect password. Please try again.";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email address.";
          break;
        default:
          errorMessage = "Login failed. Please try again later.";
      }

      Get.snackbar(
        "About Login",
        "Login message",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText:
            const Text("Login failed", style: TextStyle(color: Colors.white)),
        messageText: Text(
          errorMessage,
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
  }

  Future<void> logout() async {
    await auth.signOut();
  }
}

//!google auth
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle(
      BuildContext context, Function(String) onEmailReceived) async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in process
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      String? userEmail = userCredential.user?.email;
      DateTime date = DateTime.now();

      // Check if the user already exists in Firestore
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(userEmail)
          .get();

      if (!userSnapshot.exists) {
        // User does not exist, create a new document in Firestore
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userEmail)
            .set({
          'Username': userEmail!.split("@")[0],
          'Name': userCredential.user?.displayName ?? '',
          'Balance of Checking Account': 0.0,
          'Balance of Saving Account': 0.0,
          'Salary': {
            'Amount': 0.0,
            'Frequency': 'Monthly',
            'StartDate': date, // You might want to set a default value here
          },
        });
      }

      onEmailReceived(userEmail!);
      //String uid = userCredential.user!.uid;

      // Wait for Firestore operations to complete before navigating
      await Future.delayed(
          Duration(seconds: 2)); // Example delay, adjust as needed
      Get.off(() => BottomNavi());
    } catch (error) {
      print(error.toString());
    }
  }
}

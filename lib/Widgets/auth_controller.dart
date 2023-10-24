import 'package:budgettap/pages/my_home_page.dart';
import 'package:budgettap/pages/welcome_page.dart';
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
      Get.off(() => MyHomePage(email: user.email!));
    }
  }

  Future<void> register(
      String email, String password, String reEnterPassword) async {
    if (password != reEnterPassword) {
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
        email: email,
        password: password,
      );

      // Get the user ID (UID)
      String uid = userCredential.user!.uid;

      // Registration successful
      // You can perform any further actions after successful registration here
      print('User registered: $uid');
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

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle(
      BuildContext context, Function(String) onEmailReceived) async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in process
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Get the user's email address
      String? userEmail = userCredential.user?.displayName;

      // Call the callback function with the email
      onEmailReceived(userEmail!);

      // Navigate to MyHomePage
      Get.off(() => MyHomePage(email: userEmail));
    } catch (error) {
      // Handle sign-in errors here
      print(error.toString());
    }
  }
}

import 'package:budgettap/Widgets/bottomNavi.dart';
import 'package:budgettap/pages/transactions_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:budgettap/Widgets/auth_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => Get.put(AuthController()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override 
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: BottomNavi(),
      getPages: [
        GetPage(name: '/pages/transactions', page: () => Transactions()),
        // Add other pages as needed
      ],
    );
  }
}

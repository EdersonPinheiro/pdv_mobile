import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdv_mobile/controller/auth_controller.dart';
import '../home_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  final AuthController userController = Get.put(AuthController());
  
  @override
  void initState() {
    super.initState();
    navigateToHomePage();
  }

  Future<void> navigateToHomePage() async {
    await Future.delayed(const Duration(seconds: 2)); // Atraso de 3 segundos
    await userController.getUser(); 
    Get.offAll(HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.indigo,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "PDV Mobile",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meu_estoque/page/auth/login_page.dart';
import 'package:meu_estoque/page/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';
import '../../controllers/sync/sync_controller.dart';
import '../../controllers/user_controller.dart';
import '../../model/user.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  final UserController userController = Get.put(UserController());
  final SyncController syncController = Get.put(SyncController());

  @override
  void initState() {
    super.initState();
    checkSession();
  }

  Future<void> checkSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString('userToken') ?? "";

    if (userToken.isNotEmpty) {
      syncController.isConn == true
        ? userController.getUser()
        : userController.getUserOffline();
      Get.offAll(HomePage());
    } else {
      Get.offAll(LoginPage());
    }
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
                "Meu Estoque",
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meu_estoque/page/auth/login_page.dart';
import 'package:meu_estoque/page/product/product_page.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/constants.dart';
import 'controllers/sync/sync_controller.dart';
import 'page/home/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Parse().initialize(
    KeyApplicationId,
    KeyParseServerUrl,
    clientKey: keyClassUser,
    liveQueryUrl: 'wss://mystockcloneapp.b4a.io',
    debug: true,
  );
  Get.put(SyncController());
  runApp(const MyApp());
  checkSession();
}

Future<void> checkSession() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  userToken = prefs.getString('userToken') ?? 'null';

  if (userToken == 'null') {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAll(const LoginPage());
  } else {
    Get.offAll(HomePage());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Meu Estoque',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: false,
      ),
      getPages: [
        GetPage(name: '/products_page', page: () => ProductsPage()),
        // ... outras rotas
      ],
      home: GetBuilder<SyncController>(
        init: SyncController(),
        builder: (_) {
          return LoginPage();
        },
      ),
    );
  }
}

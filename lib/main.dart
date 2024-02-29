import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'constants/constants.dart';
import 'page/splash/splash_screen_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Parse().initialize(
    KeyApplicationId,
    KeyParseServerUrl,
    clientKey: keyClassUser,
    liveQueryUrl: 'wss://mystockcloneapp.b4a.io',
    debug: true,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Meu Estoque',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: false,
        ),
        home: SplashScreenPage());
  }
}
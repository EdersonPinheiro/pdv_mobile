import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pdv_mobile/page/splash/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../constants/constants.dart';
import '../model/user.dart';
import '../page/home_page.dart';

class AuthController {
  User? user;
  final userL = <User>[].obs;

  Future<void> getUser() async {
  try {
    final response = await http.post(
      Uri.parse('$b4a/get-info'),
      headers: {
        'X-Parse-Application-Id': KeyApplicationId,
        'X-Parse-REST-API-Key': KeyClientKey,
        'X-Parse-Session-Token': '${userToken}',
      },
    );

    if (response.statusCode == 200) {
      List<User> users = (jsonDecode(response.body)["result"] as List)
          .map((data) => User.fromJson(data))
          .toList();

      if (users.isNotEmpty) {
        await db.addUser(users[0]);
      }

      userL.value = users;
    } else {
      print(response.body.toString());
    }
  } catch (e) {
    print(e);
  }
}


  Future<void> createAccount(String fullname, String email, String password,
      String cpf, String dataNascimento) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://parseapi.back4app.com/parse/functions/create_account'),
        headers: {
          'X-Parse-Application-Id': KeyApplicationId,
          'X-Parse-REST-API-Key': KeyClientKey,
        },
        body: jsonEncode({
          "fullname": fullname,
          "email": email,
          "password": password,
          "cpf": cpf,
          "dataNascimento": dataNascimento
        }),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body)['result'];
        if (result != null && result.containsKey('token')) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('userToken', result['token']);
          await prefs.setString('fullname', result['fullname']);
          await prefs.setString('setor', result['setor']);
          userToken = result['token'] as String;
          fullname = result['fullname'] as String;
          setor = result['setor'] as String;

          const uuid = Uuid();
          User user = new User(
              localId: uuid.v4(),
              nome: fullname,
              email: email,
              cpfCnpj: cpf,
              dataNascimento: dataNascimento);

          await db.addUser(user);
          Get.off(SplashScreenPage());
        } else {
          print('Token not found in API response');
          // Lógica para lidar com a ausência do campo "token" na resposta
        }
        
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$b4a/login'),
      headers: <String, String>{
        'X-Parse-Application-Id': KeyApplicationId,
        'X-Parse-REST-API-Key': KeyClientKey,
        'Content-Type': 'application/json;charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> result = jsonDecode(response.body);
      print(result); // Add this line to check the structure of the response
      final resultMap = result['result'];
      if (resultMap != null && resultMap.containsKey('token')) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userToken', resultMap['token']);
        await prefs.setString('fullname', resultMap['fullname']);
        userToken = resultMap['token'].toString();
        print('User Token!= $userToken');
        fullname = resultMap['fullname'] as String;
        Get.offAll(HomePage());
      } else {
        print(result);
      }
    } else {
      print('Result key not found in API response');
    }
  }
}

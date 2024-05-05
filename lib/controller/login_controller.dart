import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/constants.dart';
import '../model/user.dart';
import '../page/home_page.dart';

class LoginController {
  User? user;

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

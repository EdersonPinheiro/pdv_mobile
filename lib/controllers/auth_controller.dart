import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meu_estoque/page/splash/splash_screen_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import '../page/auth/login_page.dart';

class AuthController {
  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<bool> login(String email, String password) async {
    try {
      final response = await Dio().post(
        'https://parseapi.back4app.com/parse/functions/login',
        options: Options(
          headers: {
            'X-Parse-Application-Id': KeyApplicationId,
            'X-Parse-REST-API-Key': KeyClientKey ,
          },
        ),
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200) {
        final result = response.data['result'];
        if (result != null && result.containsKey('token')) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('userToken', result['token']);
          await prefs.setString('fullname', result['fullname']);
          await prefs.setString('setor', result['setor']);
          userToken = result['token'] as String;
          fullname = result['fullname'] as String;
          setor = result['setor'] as String;
          return true;
        } else {
          print('Token not found in API response');
          // Lógica para lidar com a ausência do campo "token" na resposta
        }
      } else if (response.statusCode == 141) {
        return false;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<void> createAccount(
      String fullname, String email, String password) async {
    try {
      final response = await Dio().post(
        'https://parseapi.back4app.com/parse/functions/create_account',
        options: Options(
          headers: {
            'X-Parse-Application-Id':
                KeyApplicationId,
            'X-Parse-REST-API-Key': KeyClientKey,
          },
        ),
        data: {"fullname": fullname, "email": email, "password": password},
      );

      if (response.statusCode == 200) {
        final result = response.data['result'];
        if (result != null && result.containsKey('token')) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('userToken', result['token']);
          await prefs.setString('fullname', result['fullname']);
          await prefs.setString('setor', result['setor']);
          userToken = result['token'] as String;
          fullname = result['fullname'] as String;
          setor = result['setor'] as String;
        } else {
          print('Token not found in API response');
          // Lógica para lidar com a ausência do campo "token" na resposta
        }
        Get.off(
          SplashScreenPage());
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      final response = await Dio().post(
        'https://parseapi.back4app.com/parse/functions/reset-password',
        options: Options(
          headers: {
            'X-Parse-Application-Id':
                KeyApplicationId,
            'X-Parse-REST-API-Key': KeyClientKey,
          },
        ),
        data: {"email": email},
      );

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear(); // Limpa os valores do SharedPreferences
        Get.off(const LoginPage());
      }
    } catch (e) {
      print(e);
    }
  }
}

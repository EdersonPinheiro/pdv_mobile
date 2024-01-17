import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import '../model/moviment.dart';
import '../model/user.dart';

class MovimentController {
  final moviments = <Moviment>[].obs;
  final Dio dio = Dio();
  final productIdController = TextEditingController();
  final quantityController = TextEditingController();
  final lastQuantityController = TextEditingController();
  final typeController = TextEditingController();
  final typeMovimentController = TextEditingController();
  final dataMovController = TextEditingController();
  List<Moviment> teste = [];
  late User user;

  Future<void> saveMovimentOffline(Moviment moviment) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> movimentList = prefs.getStringList('offlineMoviments') ?? [];
      movimentList.add(jsonEncode(moviment.toJson()));
      prefs.setStringList('offlineMoviments', movimentList);
    } catch (e) {
      print(e);
    }
  }

  Future<List<Moviment>> getOfflineMoviments() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> movimentList = prefs.getStringList('offlineMoviments') ?? [];

      // Converte a lista de strings para uma lista de objetos Moviment
      List<Moviment> offlineMoviments = movimentList.map((jsonString) {
        Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        return Moviment.fromJson(jsonMap);
      }).toList();

      return offlineMoviments;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<String?> entrada(Moviment moviment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setor = prefs.getString('setor')!;
    userToken = prefs.getString('userToken')!;
    try {
      final response = await Dio().post(
        'https://parseapi.back4app.com/parse/functions/entrada',
        options: Options(
          headers: {
            'X-Parse-Application-Id': KeyApplicationId,
            'X-Parse-REST-API-Key': KeyClientKey,
            'X-Parse-Session-Token': userToken,
          },
        ),
        data: {
          "localId": moviment.localId,
          "type": moviment.type,
          "quantityMov": moviment.quantityMov,
          "dataMov": moviment.dataMov,
          "hourMov": moviment.hourMov,
          "userId": "Teste",
          "setor": setor,
          "userMov": moviment.userMov,
          "product": moviment.product,
          "typeMoviment": moviment.typeMoviment
        },
      );
      String newId = response.data['result'];
      print(newId);

      if (response.statusCode == 200) {
        return newId;
      }

      return "error";
    } catch (e) {
      print(e);
    }
  }

  Future<String?> saida(Moviment moviment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setor = prefs.getString('setor')!;
    userToken = prefs.getString('userToken')!;
    try {
      final response = await Dio().post(
        'https://parseapi.back4app.com/parse/functions/saida',
        options: Options(
          headers: {
            'X-Parse-Application-Id': KeyApplicationId,
            'X-Parse-REST-API-Key': KeyClientKey,
            'X-Parse-Session-Token': userToken,
          },
        ),
        data: {
          "id": moviment.id,
          "localId": moviment.localId,
          "type": moviment.type,
          "quantityMov": moviment.quantityMov,
          "dataMov": moviment.dataMov,
          "hourMov": moviment.hourMov,
          "userId": "Teste",
          "setor": setor,
          "userMov": moviment.userMov,
          "product": moviment.product,
          "typeMoviment": moviment.typeMoviment
        },
      );
      String newId = response.data['result'];
      print(newId);

      if (response.statusCode == 200) {
        return newId;
      }

      return "error";
    } catch (e) {
      print(e);
    }
  }
}

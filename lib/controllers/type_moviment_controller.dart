import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meu_estoque/model/group.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/type_moviment.dart';

class TypeMovimentController extends GetxController {
  final dio = new Dio();
  List typeMoviments = <TypeMoviment>[].obs;
  final id = TextEditingController();
  final localId = TextEditingController();
  final name = TextEditingController();
  final description = TextEditingController();
  final type = TextEditingController();


  Future<void> createTypeMovimentOffline(TypeMoviment typeMoviment) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> typeMovimentList =
          prefs.getStringList('offlineTypeMoviments') ?? [];
      typeMovimentList.add(jsonEncode(typeMoviment.toJson()));
      prefs.setStringList('offlineTypeMoviments', typeMovimentList);

      typeMoviments = typeMovimentList;
    } catch (e) {
      print(e);
    }
  }

  Future<List> getOfflineTypeMoviments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> typeMovimentList =
        prefs.getStringList('offlineTypeMoviments') ?? [];
    typeMoviments = [];

    for (String typeMovimentJsonString in typeMovimentList) {
      Map<String, dynamic> typeMovimentJson =
          jsonDecode(typeMovimentJsonString);
      TypeMoviment typeMoviment = TypeMoviment.fromJson(typeMovimentJson);
      typeMoviments.add(typeMoviment);
    }

    return typeMoviments;
  }

  Future<void> editTypeMovimentOffline(TypeMoviment editedTypeMoviment) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> typeMovimentList =
          prefs.getStringList('offlineTypeMoviments') ?? [];

      for (int i = 0; i < typeMovimentList.length; i++) {
        Map<String, dynamic> typeMovimentJson = jsonDecode(typeMovimentList[i]);
        if (typeMovimentJson['localId'] == editedTypeMoviment.localId) {
          // Atualiza as propriedades do produto com base nas alterações
          typeMovimentJson['name'] = editedTypeMoviment.name;
          typeMovimentJson['desc'] = editedTypeMoviment.desc;
          typeMovimentJson['type'] = editedTypeMoviment.type;

          // Atualiza o produto na lista
          typeMovimentList[i] = jsonEncode(typeMovimentJson);
          break; // Sai do loop, pois encontrou o produto
        }
      }

      // Salva a lista atualizada no shared_preferences
      prefs.setStringList('offlineTypeMoviments', typeMovimentList);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteTypeMovimentOffline(TypeMoviment typeMoviment) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> groupList =
          prefs.getStringList('offlineTypeMoviments') ?? [];

      // Remove o produto da lista offline
      groupList.removeWhere((groupJsonString) {
        Map<String, dynamic> groupJson = jsonDecode(groupJsonString);
        return groupJson['localId'] == typeMoviment.localId;
      });

      prefs.setStringList('offlineTypeMoviments', groupList);
    } catch (e) {
      print(e);
    }
  }
}

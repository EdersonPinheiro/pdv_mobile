import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meu_estoque/model/group.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import '../model/type_moviment.dart';

class TypeMovimentController extends GetxController {
  final dio = new Dio();
  final RxList<TypeMoviment> typeMoviments = <TypeMoviment>[].obs;
  final id = TextEditingController();
  final localId = TextEditingController();
  final name = TextEditingController();
  final description = TextEditingController();
  final type = TextEditingController();

  Future<bool> handleLiveQueryEventCreate(
      LiveQueryEvent event, ParseObject value) async {
    try {
      TypeMoviment typeMoviment = TypeMoviment(
        id: value.get<String>('objectId').toString(),
        localId: value.get<String>('localId').toString(),
        name: value.get<String>('name') ?? '',
        action: value.get<String>('action') ?? '',
        type: value.get<String>('type') ?? '',
        setor: value.get('setor'),
      );

      await db.addTypeMoviment(typeMoviment);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> handleLiveQueryEventUpdate(
      LiveQueryEvent event, ParseObject value) async {
    try {
      TypeMoviment typeMoviment = TypeMoviment(
        id: value.get<String>('objectId').toString(),
        localId: value.get<String>('localId').toString(),
        name: value.get<String>('name') ?? '',
        action: value.get<String>('action') ?? '',
        type: value.get<String>('type') ?? '',
        setor: value.get('setor'),
      );

      print(typeMoviment.toJson());

      await db.updateTypeMovimentDB(typeMoviment);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> handleLiveQueryEventDelete(
      LiveQueryEvent event, ParseObject value) async {
    try {
      TypeMoviment typeMoviment = TypeMoviment(
        id: value.get<String>('objectId').toString(),
        localId: value.get<String>('localId').toString(),
        name: value.get<String>('name') ?? '',
        action: value.get<String>('action') ?? '',
        type: value.get<String>('type') ?? '',
        setor: value.get('setor'),
      );

      print(typeMoviment.toJson());

      await db.deleteTypeMovimentDB(typeMoviment);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> getTypeMovimentDB() async {
    typeMoviments.value = await db.getTypeMovimentDB();
    for (var element in typeMoviments) {
      element.name;
    }
    print(typeMoviments.value);
  }

  Future<List<TypeMoviment>> getTypeMoviment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString('userToken') ?? 'null';
    dio.options.headers = {
      'X-Parse-Application-Id': KeyApplicationId,
      'X-Parse-REST-API-Key': KeyClientKey,
      'X-Parse-Session-Token': userToken,
    };

    try {
      final response = await dio.post('$b4a/get-type-moviment');

      if (response.data["result"] != null) {
        typeMoviments.value = (response.data["result"] as List)
            .map((data) => TypeMoviment.fromJson(data))
            .toList();
      }

      await db.saveTypeMoviment(typeMoviments.value);
    } catch (e) {
      print(e);
    }
    return typeMoviments;
  }

  Future<void> createTypeMoviment(TypeMoviment type) async {
    try {
      final response = await Dio().post(
        'https://parseapi.back4app.com/parse/functions/create-type-moviment',
        options: Options(
          headers: {
            'X-Parse-Application-Id': KeyApplicationId,
            'X-Parse-REST-API-Key': KeyClientKey,
            'X-Parse-Session-Token': '${userToken}',
          },
        ),
        data: {
          "localId": type.localId,
          "name": type.name,
          "description": type.description,
          "type": type.type,
          "action": type.action,
        },
      );

      if (response.statusCode == 200) {
        String objectId = response.data['result'].toString();

        final dbClient = await db;
        await dbClient.updateTypeMovimentDB(type);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> changeTypeMoviment(TypeMoviment type) async {
    try {
      final response = await Dio().post(
          'https://parseapi.back4app.com/parse/functions/edit-type-moviment',
          options: Options(
            headers: {
              'X-Parse-Application-Id': KeyApplicationId,
              'X-Parse-REST-API-Key': KeyClientKey,
              'X-Parse-Session-Token': '${userToken}',
            },
          ),
          data: {
            "id": type.id,
            "name": type.name,
            "desc": type.description,
          });
      TypeMoviment.fromJson(response.data['result']);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteTypeMoviment(TypeMoviment type) async {
    try {
      final response = await Dio().post(
          'https://parseapi.back4app.com/parse/functions/delete-type-moviment',
          options: Options(
            headers: {
              'X-Parse-Application-Id': KeyApplicationId,
              'X-Parse-REST-API-Key': KeyClientKey,
              'X-Parse-Session-Token': userToken,
            },
          ),
          data: {
            "typeMovimentId": type.id,
          });
      TypeMoviment.fromJson(response.data['result']);
    } catch (e) {
      print(e);
    }
  }
}

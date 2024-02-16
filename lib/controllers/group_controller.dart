import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meu_estoque/model/group.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';

class GroupController extends GetxController {
  final dio = new Dio();
  final RxList<Group> groups = <Group>[].obs;
  final RxList<Group> actionGroups = <Group>[].obs;
  final localId = TextEditingController();
  final name = TextEditingController();
  final description = TextEditingController();
  final quantity = TextEditingController();
  final setor = TextEditingController();

  Future<void> getGroupsDB() async {
    groups.value = await db.getGroupDB();
    for (var element in groups) {
      element.name;
    }
    print(groups.value);
   
  }

  Future<bool> handleLiveQueryEventCreate(
      LiveQueryEvent event, dynamic value) async {
    try {
      Group group = Group(
        id: value.get<String>('objectId'),
        localId: value.get<String>('localId'),
        name: value.get<String>('name') ?? '',
        description: value.get<String>('description') ?? '',
      );

      print(group.toJsonDB());

      await db.addGroup(group);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> handleLiveQueryEventUpdate(
      LiveQueryEvent event, dynamic value) async {
    try {
      Group group = Group(
        id: value.get<String>('objectId'),
        localId: value.get<String>('localId'),
        name: value.get<String>('name') ?? '',
        description: value.get<String>('description') ?? '',
      );

      print(group.toJsonDB());

      await db.updateGroups(group);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> handleLiveQueryEventDelete(
      LiveQueryEvent event, dynamic value) async {
    try {
      Group group = Group(
        id: value.get<String>('objectId'),
        localId: value.get<String>('localId'),
        name: value.get<String>('name') ?? '',
        description: value.get<String>('description') ?? '',
      );

      print(group.toJsonDB());

      await db.deleteGroupsDB(group);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> getGroup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString('userToken') ?? 'null';
    dio.options.headers = {
      'X-Parse-Application-Id': KeyApplicationId,
      'X-Parse-REST-API-Key': KeyClientKey,
      'X-Parse-Session-Token': userToken,
    };

    try {
      final response = await dio.post('$b4a/get-group');

      if (response.data["result"] != null) {
        List<Group> groups = (response.data["result"] as List)
            .map((data) => Group.fromJson(data))
            .toList();

        await db.saveGroups(groups);

        this.groups.value = groups;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> createGroup(Group group) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setor.text = prefs.getString('setor')!;
    userToken = prefs.getString('userToken')!;

    try {
      final response = await Dio().post(
        '$b4a/create-group',
        options: Options(
          headers: {
            'X-Parse-Application-Id': KeyApplicationId,
            'X-Parse-REST-API-Key': KeyClientKey,
            'X-Parse-Session-Token': userToken,
          },
        ),
        data: {
          "name": group.name,
          "description": group.description,
          "setor": group.setor,
        },
      );

      if (response.statusCode == 200) {
        String objectId = response.data['result'].toString();

        // Update the locally saved group information in SharedPreferences
        List<String> groupList = prefs.getStringList('offlineGroups') ?? [];

        for (int i = 0; i < groupList.length; i++) {
          Map<String, dynamic> groupJson = jsonDecode(groupList[i]);

          if (groupJson['localId'] == group.id) {
            groupJson['id'] = objectId; // Assuming the field is objectId
            groupList[i] = jsonEncode(groupJson);
            break;
          }
        }

        prefs.setStringList('offlineGroups', groupList);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> editGroup(Group group) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');
    try {
      final response = await Dio().post('$b4a/change-group',
          options: Options(
            headers: {
              'X-Parse-Application-Id': KeyApplicationId,
              'X-Parse-REST-API-Key': KeyClientKey,
              'X-Parse-Session-Token': '${userToken}',
            },
          ),
          data: {
            "id": group.id,
            "name": group.name,
            "description": group.description,
            "action": group.action
          });
      Group.fromJson(response.data['result']);
    } catch (e) {
      print(e);
    }
  }
}

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meu_estoque/model/group.dart';
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

  Future<List<Group>> getGroup() async {
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

        // Save the group information in SharedPreferences
        prefs.setString(
            'selectedGroup', groups.isNotEmpty ? groups[0].name : '');

        this.groups.value = groups;
      }
    } catch (e) {
      print(e);
    }
    return groups;
  }

  Future<void> createGroup(Group group) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setor.text = prefs.getString('setor')!;
    userToken = prefs.getString('userToken')!;

    try {
      final response = await Dio().post(
        'https://parseapi.back4app.com/parse/functions/create-group',
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

  Future<void> createGroupOffline(Group group) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> groupList = prefs.getStringList('offlineGroups') ?? [];
      groupList.add(jsonEncode(group.toJson()));
      prefs.setStringList('offlineGroups', groupList);

      groups.value = groupList.cast<Group>();
    } catch (e) {
      print(e);
    }
  }

  Future<List<Group>> getOfflineGroups() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> groupList = prefs.getStringList('offlineGroups') ?? [];
    groups.value = [];

    for (String groupJsonString in groupList) {
      Map<String, dynamic> groupJson = jsonDecode(groupJsonString);
      Group group = Group.fromJson(groupJson);
      groups.add(group);
    }

    return groups;
  }

  Future<void> editGroupOffline(Group editedGroup) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> groupList = prefs.getStringList('offlineGroups') ?? [];

      for (int i = 0; i < groupList.length; i++) {
        Map<String, dynamic> groupJson = jsonDecode(groupList[i]);
        if (groupJson['localId'] == editedGroup.localId) {
          // Atualiza as propriedades do produto com base nas alterações
          groupJson['name'] = editedGroup.name;
          groupJson['description'] = editedGroup.description;

          // Atualiza o produto na lista
          groupList[i] = jsonEncode(groupJson);
          break; // Sai do loop, pois encontrou o produto
        }
      }

      // Salva a lista atualizada no shared_preferences
      prefs.setStringList('offlineGroups', groupList);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteGroupOffline(Group group) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> groupList = prefs.getStringList('offlineGroups') ?? [];

      // Remove o produto da lista offline
      groupList.removeWhere((groupJsonString) {
        Map<String, dynamic> groupJson = jsonDecode(groupJsonString);
        return groupJson['localId'] == group.localId;
      });

      prefs.setStringList('offlineGroups', groupList);
    } catch (e) {
      print(e);
    }
  }

  Future<void> createActionGroupOffline(Group group) async {
    try {
      // Create a new Group instance with the input values
      Group newGroup = Group(
        id: group.id,
        localId: group.localId,
        name: group.name,
        description: group.description,
        setor: group.setor,
        action: 'new',
      );

      // Check if localId already exists in offline groups
      if (actionGroups.any((group) => group.localId == newGroup.localId)) {
        // Handle duplicate localId as needed
        print("Group with the same localId already exists offline.");
        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> groupList = prefs.getStringList('actionGroups') ?? [];
      groupList.add(jsonEncode(newGroup.toJson()));
      prefs.setStringList('actionGroups', groupList);

      // Clear the fields or controllers as needed
      localId.clear();
      name.clear();
      description.clear();
      setor.clear();

      // Notify the UI that the list has been updated
      update();
    } catch (e) {
      print(e);
    }
  }
}

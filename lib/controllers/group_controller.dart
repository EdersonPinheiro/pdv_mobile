import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meu_estoque/model/group.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupController extends GetxController {
  final dio = new Dio();
  List groups = <Group>[].obs;
  final localId = TextEditingController();
  final name = TextEditingController();
  final description = TextEditingController();
  final quantity = TextEditingController();

  Future<void> createGroupOffline(Group group) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> groupList = prefs.getStringList('offlineGroups') ?? [];
      groupList.add(jsonEncode(group.toJson()));
      prefs.setStringList('offlineGroups', groupList);

      groups = groupList;
    } catch (e) {
      print(e);
    }
  }

  Future<List> getOfflineGroups() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> groupList = prefs.getStringList('offlineGroups') ?? [];
    groups = [];

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
}

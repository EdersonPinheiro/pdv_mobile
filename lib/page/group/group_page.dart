import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meu_estoque/page/product/create_product_page.dart';
import 'package:meu_estoque/page/product/edit_product_page.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';
import '../../controllers/group_controller.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/sync/sync_controller.dart';
import '../../model/group.dart';
import '../../model/product.dart';
import 'create_group_page.dart';
import 'edit_group_page.dart';

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  final GroupController groupController = Get.put(GroupController());
  final SyncController syncController = Get.put(SyncController());
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getGroupsDB();
  }

  Future<void> checkConnection() async {
    syncController.isConn == true
        ? groupController.getGroup()
        : groupController.getGroupsDB();
  }

  Future<void> getGroupsDB() async {
    groupController.groups.value = await db.getGroupDB();
    for (var element in groupController.groups) {
      element.name;
    }
    print(groupController.groups.value);
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grupos'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: checkConnection,
        child: Obx(() => ListView.builder(
              itemCount: groupController.groups.length,
              itemBuilder: (BuildContext context, int index) {
                Group group = groupController.groups[index];
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 218, 211, 211),
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: ListTile(
                      title: Text(group.name),
                      subtitle: Text(group.description),
                      onTap: () async {
                        print(group.toJson());
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          Get.to(EditGroupPage(
                              group: group, reload: checkConnection));
                        },
                      ),
                    ),
                  ),
                );
              },
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(CreateGroupPage(
            reload: checkConnection,
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

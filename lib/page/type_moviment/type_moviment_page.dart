import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meu_estoque/model/type_moviment.dart';
import 'package:meu_estoque/page/product/create_product_page.dart';
import 'package:meu_estoque/page/product/edit_product_page.dart';
import 'package:meu_estoque/page/type_moviment/edit_type_moviment_page.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';
import '../../controllers/group_controller.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/type_moviment_controller.dart';
import '../../model/group.dart';
import '../../model/product.dart';
import 'create_type_moviment_page.dart';

class TypeMovimentPage extends StatefulWidget {
  @override
  _TypeMovimentPageState createState() => _TypeMovimentPageState();
}

class _TypeMovimentPageState extends State<TypeMovimentPage> {
  final TypeMovimentController typeMovimentController =
      Get.put(TypeMovimentController());
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    typeMovimentController.getTypeMoviment();
  }

  final LiveQuery liveQueryT = LiveQuery();
  QueryBuilder<ParseObject> queryT =
      QueryBuilder<ParseObject>(ParseObject("TypeMoviment"));

  Future<void> startLiveQuery() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final setor = prefs.getString('setor')!;
    Subscription subscription = await liveQueryT.client.subscribe(queryT);

    subscription.on(LiveQueryEvent.create, (value) async {
      ParseObject? setorObject = value.get<ParseObject>("setor");
      final setorParse = setorObject?.get("objectId");

      if (setorParse == setor) {
        await typeMovimentController.handleLiveQueryEventCreate(
            LiveQueryEvent.create, value);
        if (mounted) {
          setState(() {
            getTypeMovimentDB();
          });
        }
      }
    });

    subscription.on(LiveQueryEvent.update, (value) async {
      ParseObject? setorObject = value.get<ParseObject>("setor");
      final setorParse = setorObject?.get("objectId");

      if (setorParse == setor) {
        await typeMovimentController.handleLiveQueryEventUpdate(
            LiveQueryEvent.update, value);
        if (mounted) {
          setState(() {
            getTypeMovimentDB();
          });
        }
      }
    });

    subscription.on(LiveQueryEvent.delete, (value) async {
      ParseObject? setorObject = value.get<ParseObject>("setor");
      final setorParse = setorObject?.get("objectId");

      if (setorParse == setor) {
        await typeMovimentController.handleLiveQueryEventDelete(
            LiveQueryEvent.delete, value);
        if (mounted) {
          setState(() {
            getTypeMovimentDB();
          });
        }
      }
    });
  }

  Future<void> getTypeMovimentDB() async {
    typeMovimentController.typeMoviments.value = await db.getTypeMovimentDB();
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
        title: const Text('Tipos de Movimento'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: getTypeMovimentDB,
        child: Obx(() => ListView.builder(
              itemCount: typeMovimentController.typeMoviments.length,
              itemBuilder: (BuildContext context, int index) {
                TypeMoviment typeMoviment =
                    typeMovimentController.typeMoviments[index];
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
                      title: Text(typeMoviment.name),
                      subtitle: Text(typeMoviment.type.toString()),
                      onTap: () async {
                        print(typeMoviment.toJson());
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          Get.to(EditTypeMovimentPage(
                              typeMoviment: typeMoviment,
                              reload: getTypeMovimentDB));
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
          Get.to(CreateTypeMovimentPage(
            reload: getTypeMovimentDB,
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

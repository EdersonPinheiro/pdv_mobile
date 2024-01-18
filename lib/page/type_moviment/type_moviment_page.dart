import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meu_estoque/model/type_moviment.dart';
import 'package:meu_estoque/page/product/create_product_page.dart';
import 'package:meu_estoque/page/product/edit_product_page.dart';
import 'package:meu_estoque/page/type_moviment/edit_type_moviment_page.dart';

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
    getTypeMovimentOff();
  }

  Future<void> getTypeMovimentOff() async {
    await typeMovimentController.getOfflineTypeMoviments();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tipos de Movimento'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: getTypeMovimentOff,
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
                              reload: getTypeMovimentOff));
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
            reload: getTypeMovimentOff,
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/sync/sync_controller.dart';
import '../../controllers/type_moviment_controller.dart';
import '../../db/db.dart';
import '../../model/product.dart';
import '../../model/type_moviment.dart';

class EditTypeMovimentPage extends StatefulWidget {
  final TypeMoviment typeMoviment;
  final Function reload;

  EditTypeMovimentPage({required this.typeMoviment, required this.reload});

  @override
  _EditTypeMovimentPageState createState() => _EditTypeMovimentPageState();
}

class _EditTypeMovimentPageState extends State<EditTypeMovimentPage> {
  final db = DB();
  final SyncController syncController = Get.find();
  TypeMovimentController controller = TypeMovimentController();

  @override
  void initState() {
    super.initState();
    controller.id.text = widget.typeMoviment.localId!;
    controller.name.text = widget.typeMoviment.name;
    controller.description.text = widget.typeMoviment.description!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.typeMoviment.name), actions: [
        IconButton(onPressed: () async {}, icon: Icon(Icons.image))
      ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Form(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Container(
                      width: 120,
                      height: 120,
                      color: Colors.grey,
                    ),
                    TextFormField(
                      controller: controller.name,
                      decoration: const InputDecoration(labelText: 'Nome'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, insira o nome do produto';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: controller.description,
                      decoration: const InputDecoration(labelText: 'Descrição'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final newTypeMoviment = TypeMoviment(
                                  id: widget.typeMoviment.id,
                                  localId: widget.typeMoviment.localId,
                                  name: controller.name.text,
                                  description: controller.description.text,
                                  type: 'true',
                                  action: "edit");
                              if (syncController.isConn.value == true) {
                                controller.changeTypeMoviment(newTypeMoviment);
                                Get.back();
                                widget.reload();
                              } else {
                                await db.updateTypeMovimentDB(newTypeMoviment);
                                await db
                                    .saveActionTypeMoviment(newTypeMoviment);
                                Get.back();
                                widget.reload();
                              }
                            },
                            child: const Text('Salvar'),
                          ),
                        ),
                        const SizedBox(
                          width: 32,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final newTypeMoviment = TypeMoviment(
                                  id: widget.typeMoviment.id,
                                  localId: widget.typeMoviment.localId,
                                  name: controller.name.text,
                                  description: controller.description.text,
                                  type: '1',
                                  action: "delete");
                              if (syncController.isConn.value == true) {
                                await db.deleteTypeMovimentDB(newTypeMoviment);
                                controller.deleteTypeMoviment(newTypeMoviment);
                                Get.back();
                                widget.reload();
                              } else {
                                await db.deleteTypeMovimentDB(newTypeMoviment);
                                await db
                                    .saveActionTypeMoviment(newTypeMoviment);
                                Get.back();
                                widget.reload();
                              }
                            },
                            child: const Text('Excluir'),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                return Colors.red;
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> changeTypeMoviment() async {
    try {
      final response = await Dio().post(
          'https://parseapi.back4app.com/parse/functions/edit-type-moviment',
          options: Options(
            headers: {
              'X-Parse-Application-Id':
                  'YL2IncWbsoj2a3FQKByPEr89wwhFmoyWhPob5MP0',
              'X-Parse-REST-API-Key':
                  'w7IrZb43oVfFf0rbyIf9z0bNJCod7KaOnYo2sLF6',
              'X-Parse-Session-Token': userToken,
            },
          ),
          data: {
            "id": widget.typeMoviment.id,
            "name": controller.name.text,
            "description": controller.description.text,
            "type": controller.type.text
          });
      Product.fromJson(response.data['result']);
    } catch (e) {
      print(e);
    }
  }
}

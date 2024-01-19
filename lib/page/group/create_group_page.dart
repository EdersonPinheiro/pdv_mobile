import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../controllers/group_controller.dart';
import '../../controllers/product_controller.dart';
import '../../model/group.dart';
import '../../model/product.dart';

class CreateGroupPage extends StatefulWidget {
  //final Function sync;
  final Function reload;
  const CreateGroupPage(
      {super.key, /*required this.sync*/ required this.reload});
  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  GroupController controller = new GroupController();
  final Dio dio = Dio();
  final _formKey = GlobalKey<FormState>();
  static const uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grupos"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: controller.name,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Insira o nome';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: controller.description,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                        onPressed: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          controller.setor.text = prefs.getString('setor').toString();
                          const uuid = Uuid();
                          final newGroup = Group(
                            id: '',
                            localId: uuid.v4(),
                            name: controller.name.text,
                            description: controller.description.text,
                            setor: controller.setor.text,
                            action: 'new'
                          );
                          controller.createGroupOffline(newGroup);
                          Get.back();
                          widget.reload();
                        },
                        child: Text('Criar')),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createGroupOffline(Group newGroup) async {
    controller.createGroupOffline(newGroup);
    controller.createActionGroupOffline(newGroup);
  }
}

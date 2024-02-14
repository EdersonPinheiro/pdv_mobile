import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:meu_estoque/controllers/sync/sync_controller.dart';
import 'package:uuid/uuid.dart';
import '../../controllers/type_moviment_controller.dart';
import '../../db/db.dart';
import '../../model/type_moviment.dart';

class CreateTypeMoviment extends StatefulWidget {
  final Function sync;
  final Function reload;
  const CreateTypeMoviment(
      {super.key, required this.sync, required this.reload});

  @override
  State<CreateTypeMoviment> createState() => _CreateTypeMovimentState();
}

class _CreateTypeMovimentState extends State<CreateTypeMoviment> {
  final SyncController syncController = Get.find();
  TypeMovimentController controller = TypeMovimentController();
  final _formKey = GlobalKey<FormState>();
  final db = DB();
  bool isToggleOn = false;
  String name = "Entrada";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Criar Tipo de Movimento"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: controller.name,
                decoration: InputDecoration(
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
                decoration: InputDecoration(
                  labelText: 'Descrição',
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(name),
                  Container(
                    width: 50,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: isToggleOn ? Colors.red : Colors.blue,
                    ),
                    child: Switch(
                      value: isToggleOn,
                      onChanged: (value) {
                        setState(() {
                          isToggleOn = value;
                          name = isToggleOn ? "Saída" : "Entrada";
                        });
                      },
                      activeTrackColor: Colors.transparent,
                      inactiveTrackColor: Colors.transparent,
                      activeColor: Colors.transparent,
                      inactiveThumbColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    const uuid = Uuid();
                    final newTypeMoviment = TypeMoviment(
                      localId: uuid.v4(),
                      name: controller.name.text,
                      description: controller.description.text,
                      type: isToggleOn ? '1' : '2',
                      action: "new",
                    );

                    if (syncController.isConn.value == true) {
                      //await db.addTypeMoviment(newTypeMoviment);
                      controller.createTypeMoviment(newTypeMoviment);
                      Get.back();
                      widget.reload();
                    } else {
                      await db.addTypeMoviment(newTypeMoviment);
                      await db.saveActionTypeMoviment(newTypeMoviment);
                      Get.back();
                      widget.reload();
                    }
                  }
                },
                child: Text('Criar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

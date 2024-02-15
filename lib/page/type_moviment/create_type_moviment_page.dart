import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../constants/constants.dart';
import '../../controllers/sync/sync_controller.dart';
import '../../controllers/type_moviment_controller.dart';
import '../../model/type_moviment.dart';

class CreateTypeMovimentPage extends StatefulWidget {
  final Function reload;
  const CreateTypeMovimentPage({super.key, required this.reload});

  @override
  State<CreateTypeMovimentPage> createState() => _CreateTypeMovimentPageState();
}

class _CreateTypeMovimentPageState extends State<CreateTypeMovimentPage> {
  final TypeMovimentController typeMovimentController =
      Get.put(TypeMovimentController());
  final SyncController syncController = Get.put(SyncController());
  final _formKey = GlobalKey<FormState>();
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
                controller: typeMovimentController.name,
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
                      id: '',
                      localId: uuid.v4(),
                      name: typeMovimentController.name.text,
                      type: isToggleOn ? 'Saida' : 'Entrada', // Update here
                      setor: '',
                    );
                    if (syncController.isConn.value == true) {
                      await typeMovimentController
                          .createTypeMoviment(newTypeMoviment);
                      widget.reload();
                      Get.back();
                    } else {
                      await db.addTypeMoviment(newTypeMoviment);
                      await db.saveActionTypeMoviment(newTypeMoviment);
                      widget.reload();
                      Get.back();
                    }
                    widget.reload();
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

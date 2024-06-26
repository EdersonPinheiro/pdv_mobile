import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../controllers/group_controller.dart';
import '../../controllers/type_moviment_controller.dart';
import '../../model/group.dart';
import '../../model/type_moviment.dart';

class EditTypeMovimentPage extends StatefulWidget {
  final TypeMoviment typeMoviment;
  final Function reload;

  EditTypeMovimentPage({required this.typeMoviment, required this.reload});

  @override
  _EditTypeMovimentPageState createState() => _EditTypeMovimentPageState();
}

class _EditTypeMovimentPageState extends State<EditTypeMovimentPage> {
  final TypeMovimentController typeMovimentController =
      Get.put(TypeMovimentController());
  bool isToggleOn = false;
  String name = "Entrada";

  @override
  void initState() {
    super.initState();
    getTypeMovimentsOff();
    typeMovimentController.localId.text = widget.typeMoviment.localId ?? '';
    typeMovimentController.name.text = widget.typeMoviment.name;
    typeMovimentController.description.text =
        widget.typeMoviment.desc.toString();
    typeMovimentController.type.text = widget.typeMoviment.type;
  }

  Future<void> getTypeMovimentsOff() async {
    await typeMovimentController.getOfflineTypeMoviments();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.typeMoviment.name), actions: [
        //IconButton(onPressed: () async {}, icon: Icon(Icons.image))
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
                      controller: typeMovimentController.name,
                      decoration: const InputDecoration(labelText: 'Nome'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, insira o nome do produto';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: typeMovimentController.description,
                      decoration: const InputDecoration(labelText: 'Descrição'),
                      maxLines: 3,
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(typeMovimentController.type.text),
                        Container(
                          width: 50,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: typeMovimentController.type.text == "Saída"
                                ? Colors.red
                                : Colors.blue,
                          ),
                          child: Switch(
                            value: isToggleOn,
                            onChanged: (value) {
                              setState(() {
                                isToggleOn = value;
                                typeMovimentController.type.text =
                                    isToggleOn ? "Saída" : "Entrada";
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
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final newTypeMoviment = TypeMoviment(
                                id: typeMovimentController.id.text,
                                localId: typeMovimentController.localId.text,
                                name: typeMovimentController.name.text,
                                desc: typeMovimentController.description.text,
                                type: isToggleOn ? 'Saída' : 'Entrada',
                                setor: '',
                              );
                              await typeMovimentController
                                  .deleteTypeMovimentOffline(newTypeMoviment);
                              widget.reload();
                              Get.back();
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
                        const SizedBox(
                          width: 32,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final newTypeMoviment = TypeMoviment(
                                id: typeMovimentController.id.text,
                                localId: typeMovimentController.localId.text,
                                name: typeMovimentController.name.text,
                                desc: typeMovimentController.description.text,
                                type: isToggleOn ? 'Saída' : 'Entrada',
                                setor: '',
                              );
                              await typeMovimentController
                                  .editTypeMovimentOffline(newTypeMoviment);
                              widget.reload();
                              Get.back();
                            },
                            child: const Text('Salvar'),
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
}

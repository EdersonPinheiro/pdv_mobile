import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/group_controller.dart';
import '../../controllers/sync/sync_controller.dart';
import '../../model/group.dart';

class EditGroupPage extends StatefulWidget {
  final Group group;
  final Function reload;

  EditGroupPage({required this.group, required this.reload});

  @override
  _EditGroupPageState createState() => _EditGroupPageState();
}

class _EditGroupPageState extends State<EditGroupPage> {
  GroupController controller = GroupController();
  final SyncController syncController = Get.put(SyncController());
  
  @override
  void initState() {
    super.initState();
    getProductsOff();
    controller.localId.text = widget.group.localId ?? '';
    controller.name.text = widget.group.name;
    controller.description.text = widget.group.description;
  }

  Future<void> getProductsOff() async {
    await controller.getOfflineGroups();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.group.name), actions: [
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
                              SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          controller.setor.text =
                              prefs.getString('setor').toString();
                              final newGroup = Group(
                                id: widget.group.id,
                                localId: widget.group.localId,
                                name: controller.name.text,
                                description: controller.description.text,
                                setor: controller.setor.text,
                              );
                              await controller.deleteGroupOffline(newGroup);
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
                              SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          controller.setor.text =
                              prefs.getString('setor').toString();
                              final newGroup = Group(
                                id: widget.group.id,
                                localId: widget.group.localId,
                                name: controller.name.text,
                                description: controller.description.text,
                                setor: controller.setor.text,
                                action: 'edit'
                              );
                              syncController.isConn == true
                              ? controller.editGroup(newGroup)
                              : editGroupOffline(newGroup);
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

  Future<void> editGroupOffline(Group newGroup) async {
    controller.editGroupOffline(newGroup);
    controller.createActionGroupOffline(newGroup, "edit");
  }
}

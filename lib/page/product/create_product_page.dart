import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../controllers/group_controller.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/sync/sync_controller.dart';
import '../../model/product.dart';

class CreateProductPage extends StatefulWidget {
  //final Function sync;
  final Function reload;
  const CreateProductPage(
      {super.key, /*required this.sync*/ required this.reload});
  @override
  _CreateProductPageState createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final ProductController controller = Get.put(ProductController());
  final GroupController groupController = Get.put(GroupController());
  final SyncController syncController = Get.put(SyncController());
  
  final Dio dio = Dio();
  final _formKey = GlobalKey<FormState>();
  static const uuid = Uuid();
  String? _selectedGroup;
  List _groupList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGroupsOff();
  }

  Future<void> getGroupsOff() async {
    _groupList = await groupController.getOfflineGroups();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Produto"),
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
                      keyboardType: TextInputType.number,
                      controller: controller.quantity,
                      decoration: const InputDecoration(
                        labelText: 'Quantidade',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Insira a quantidade';
                        } else if (int.tryParse(value) == null) {
                          return "A quantidade deve conter apenas números";
                        } else if (int.parse(value) <= 0) {
                          return "A quantidade deve ser maior que zero";
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField(
                      value: _selectedGroup,
                      onChanged: (String? value) {
                        print("Dropdown onChanged triggered");
                        print("Selected Value: $value");
                        setState(() {
                          _selectedGroup = value;
                          controller.group.text = value ?? '';
                        });
                        print(
                            "Controller Group Text: ${controller.group.text}");
                        print("Selected Group: $_selectedGroup");
                      },
                      items: _groupList.map((group) {
                        return DropdownMenuItem<String>(
                          value: group.localId,
                          child: Text(group.name),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Grupo',
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Defina o grupo do produto';
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
                          final newProduct = Product(
                            id: '',
                            localId: uuid.v4(),
                            name: controller.name.text,
                            group: _selectedGroup.toString(),
                            quantity: int.parse(controller.quantity.text),
                            description: controller.description.text,
                            setor: controller.setor.text,
                            action: 'new'
                          );
                          syncController.isConn == true
                              ? controller.createProduct(newProduct)
                              : createProductOffline(newProduct);

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

  Future<void> createProductOffline(Product newProduct) async {
    controller.createProductOffline(newProduct);
    controller.createActionProductOffline(newProduct);
  }
}

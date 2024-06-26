import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../controllers/group_controller.dart';
import '../../controllers/product_controller.dart';
import '../../model/product.dart';

class EditProductPage extends StatefulWidget {
  final Product product;
  final Function reload;

  EditProductPage({required this.product, required this.reload});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  ProductController controller = ProductController();
  final GroupController groupController = Get.put(GroupController());
  String? _selectedGroup;
  List _groupList = [];

  @override
  void initState() {
    super.initState();
    getProductsOff();
    getGroupsOff();
    controller.localId.text = widget.product.localId ?? '';
    controller.name.text = widget.product.name;
    controller.description.text = widget.product.description;
    controller.quantity.text = widget.product.quantity.toString();
    controller.group.text = widget.product.group;
  }

  Future<void> getGroupsOff() async {
    _groupList = await groupController.getOfflineGroups();
    setState(() {});
  }

  Future<void> getProductsOff() async {
    await controller.getOfflineProducts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product.name), actions: [
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
                    DropdownButtonFormField(
                      value: _selectedGroup == null ? controller.group.text : _selectedGroup,
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
                      decoration: const InputDecoration(labelText: 'Descrição'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final newProduct = Product(
                                id: widget.product.id,
                                localId: widget.product.localId,
                                name: controller.name.text,
                                group: controller.group.text,
                                quantity: widget.product.quantity,
                                description: controller.description.text,
                                setor: '',
                              );
                              await controller.deleteProductOffline(newProduct);
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
                              final newProduct = Product(
                                id: widget.product.id,
                                localId: widget.product.localId,
                                name: controller.name.text,
                                quantity: widget.product.quantity,
                                group: controller.group.text,
                                description: controller.description.text,
                                setor: '',
                              );
                              await controller.editProductOffline(newProduct);
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

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../controllers/product_controller.dart';
import '../model/product.dart';

class EditProductPage extends StatefulWidget {
  final Product product;
  final Function reload;

  EditProductPage({required this.product, required this.reload});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  ProductController controller = ProductController();
  //String? selectedGroupIndex;
  @override
  void initState() {
    super.initState();
    getProductsOff();
    controller.localId.text = widget.product.localId ?? '';
    controller.name.text = widget.product.name;
    controller.description.text = widget.product.description;
    controller.quantity.text = widget.product.quantity.toString();
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
                                description: controller.description.text,
                                quantity: widget.product.quantity,
                                setor: '',
                              );
                              await controller.editProductOffline(newProduct);

                              Get.back();
                              widget.reload();
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
                              final newProduct = Product(
                                id: widget.product.id,
                                localId: widget.product.localId,
                                name: controller.name.text,
                                description: controller.description.text,
                                quantity: widget.product.quantity,
                                setor: '',
                              );
                              controller.deleteProductOffline(newProduct);
                              Get.back();
                              widget.reload();
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

  void confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tem certeza que deseja excluir este produto ?'),
          content: Text(
              'Excluindo o produto você também exclui todo o histórico de movimentações relacionado'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                //await db.deleteProductDB(widget.product);
              },
              child: const Text(
                'Excluir',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return Colors.red;
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}

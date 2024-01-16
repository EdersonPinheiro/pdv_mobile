import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../controllers/product_controller.dart';
import '../model/product.dart';

class CreateProductPage extends StatefulWidget {
  //final Function sync;
  final Function reload;
  const CreateProductPage(
      {super.key, /*required this.sync*/ required this.reload});
  @override
  _CreateProductPageState createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  ProductController controller = new ProductController();
  final Dio dio = Dio();
  final _formKey = GlobalKey<FormState>();
  static const uuid = Uuid();

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
                    TextFormField(
                      controller: controller.description,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                        onPressed: () async {
                          const uuid = Uuid();
                          final newProduct = Product(
                            id: '',
                            localId: uuid.v4(),
                            name: controller.name.text,
                            description: controller.description.text,
                            quantity: int.parse(controller.quantity.text),
                            setor: '',
                          );
                          controller.createProductOffline(newProduct);
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
}

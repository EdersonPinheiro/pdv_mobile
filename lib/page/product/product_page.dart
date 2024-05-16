import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../db/db.dart';
import '../../model/product.dart';
import 'create_product_page.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final db = DB();
  bool isLoading = false;
  final products = <Product>[].obs;

  @override
  void initState() {
    super.initState();
    getProductsDB();
  }

  Future<void> getProductsDB() async {
    products.value = await db.getProductsDB();
    for (var element in products) {
      element.name;
    }
    print(products.value);
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            leading: SizedBox(
              width: 48,
              height: 48,
              child: product.image != null && product.image!.isNotEmpty
                  ? Image.file(File(product.image!))
                  : Icon(Icons.image_not_supported_rounded),
            ),
            onTap: () {},
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          const uuid = Uuid();
          final newProduct = Product(
              id: uuid.v4(),
              localId: uuid.v4(),
              image: null,
              name: 'teste',
              groups: 'teste',
              quantity: 5,
              priceSell: '60',
              priceBuy: '20',
              codBarras: null);
          final newProduct2 = Product(
              id: uuid.v4(),
              localId: uuid.v4(),
              image: null,
              name: 'Alexa',
              groups: 'tesfte',
              quantity: 5,
              priceSell: '60',
              priceBuy: '20',
              codBarras: null);
          await db.addProduct(newProduct);
          await db.addProduct(newProduct2);

          /*Get.to(CreateProductPage(
            reload: getProductsDB,
          ));*/
        },
        tooltip: 'Adicionar Produto',
        child: Icon(Icons.add),
      ),
    );
  }
}

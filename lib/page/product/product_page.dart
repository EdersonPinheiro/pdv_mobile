import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meu_estoque/page/product/create_product_page.dart';
import 'package:meu_estoque/page/product/edit_product_page.dart';

import '../../controllers/product_controller.dart';
import '../../model/product.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductsPage> {
  final ProductController productController = Get.put(ProductController());
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getProductsOff();
  }

  List<Product> teste = [];
  Future<void> getProductsApi() async {
    productController.products.value =
        (await productController.getProducts()) as List<Product>;
    setState(() {});
    print("Buscou os dados da api");
  }

  Future<void> getProductsOff() async {
    await productController.getOfflineProducts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: getProductsOff,
        child: Obx(() => ListView.builder(
              itemCount: productController.products.length,
              itemBuilder: (BuildContext context, int index) {
                Product product = productController.products[index];
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: ListTile(
                      title: Text(product.name),
                      subtitle: Text(product.description),
                      onTap: () async {
                        print(product.toJson());
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          Get.to(() => EditProductPage(
                              product: product, reload: getProductsOff));
                        },
                      ),
                    ),
                  ),
                );
              },
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(CreateProductPage(
            reload: getProductsOff,
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

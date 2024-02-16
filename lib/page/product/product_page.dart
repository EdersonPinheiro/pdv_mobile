import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meu_estoque/page/product/create_product_page.dart';
import 'package:meu_estoque/page/product/edit_product_page.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/sync/sync_controller.dart';
import '../../model/product.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductsPage> {
  final ProductController productController = Get.put(ProductController());
  final SyncController syncController = Get.put(SyncController());
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getProductsDB();
  }

  Future<void> getProductsDB() async {
    productController.products.value = await db.getProductsDB();
    for (var element in productController.products) {
      element.name;
    }
    print(productController.products.value);
    print("Buscou os dados do DB");
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> checkConnection() async {
    syncController.isConn == true
        ? productController.getProducts()
        : productController.getProductsDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: checkConnection,
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
                      subtitle: Text(product.description ?? ''),
                      onTap: () async {
                        print(product.toJson());
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          Get.to(() => EditProductPage(
                              product: product, reload: checkConnection));
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
            reload: checkConnection,
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

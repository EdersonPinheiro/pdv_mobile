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
    //productController.getProducts();
    getProductsDB();
    startLiveQuery();
  }

  final LiveQuery liveQuery = LiveQuery();
  QueryBuilder<ParseObject> query =
      QueryBuilder<ParseObject>(ParseObject("Product"));

  Future<void> startLiveQuery() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final setor = prefs.getString('setor')!;
    Subscription subscription = await liveQuery.client.subscribe(query);

    subscription.on(LiveQueryEvent.create, (value) async {
      ParseObject? setorObject = value.get<ParseObject>("setor");
      final setorParse = setorObject?.get("objectId");

      if (setorParse == setor) {
        ParseObject? groupObject = value.get<ParseObject>("group");
        final teste = groupObject?.get("objectId");

        ParseObject? setorObject = value.get<ParseObject>("setor");
        final setor = setorObject?.get("objectId");

        Product product = Product(
            id: value.get<String>('objectId').toString(),
            localId: value.get<String>('localId').toString(),
            name: value.get<String>('name') ?? '',
            description: value.get<String>('description') ?? '',
            quantity: value.get('quantity'),
            groups: teste,
            setor: setor);

        await db.addProduct(product);
        if (mounted) {
          setState(() {
            getProductsDB();
          });
        }
      }
    });

    subscription.on(LiveQueryEvent.update, (value) async {
      ParseObject? setorObject = value.get<ParseObject>("setor");
      final setorParse = setorObject?.get("objectId");

      if (setorParse == setor) {
        ParseObject? groupObject = value.get<ParseObject>("group");
        final teste = groupObject?.get("objectId");

        Product product = Product(
            id: value.get<String>('objectId').toString(),
            localId: value.get<String>('localId').toString(),
            name: value.get<String>('name') ?? '',
            description: value.get<String>('description') ?? '',
            quantity: value.get('quantity'),
            groups: teste,
            setor: setorParse);

        await db.updateProduct(product);
        if (mounted) {
          setState(() {
            getProductsDB();
          });
        }
      }
    });

    subscription.on(LiveQueryEvent.delete, (value) async {
      ParseObject? setorObject = value.get<ParseObject>("setor");
      final setorParse = setorObject?.get("objectId");

      if (setorParse == setor) {
        ParseObject? groupObject = value.get<ParseObject>("group");
        final teste = groupObject?.get("objectId");

        Product product = Product(
            id: value.get<String>('objectId').toString(),
            localId: value.get<String>('localId').toString(),
            name: value.get<String>('name') ?? '',
            description: value.get<String>('description') ?? '',
            quantity: value.get('quantity'),
            groups: teste,
            setor: setorParse);

        await db.deleteProductDB(product);
        if (mounted) {
          setState(() {
            getProductsDB();
          });
        }
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: getProductsDB,
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
                              product: product, reload: getProductsDB));
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
            reload: getProductsDB,
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

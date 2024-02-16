import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meu_estoque/page/product/product_page.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/constants.dart';
import '../model/moviment.dart';
import '../model/product.dart';

class ProductController extends GetxController {
  final dio = new Dio();
  List actioProducts = <Product>[].obs;
  final RxList<Product> products = <Product>[].obs;
  final id = TextEditingController();
  final localId = TextEditingController();
  final name = TextEditingController();
  final quantity = TextEditingController();
  final group = TextEditingController();
  final description = TextEditingController();
  final setor = TextEditingController();

  Future<void> handleLiveQueryEventCreate(
      LiveQueryEvent event, ParseObject value) async {
    try {
      ParseObject? groupObject = value.get<ParseObject>("group");
      final teste = groupObject?.get("objectId");

      ParseObject? setorObject = value.get<ParseObject>("setor");
      final setor = setorObject?.get("objectId");
      debugPrint("ue");

      Product product = Product(
          id: value.get<String>('objectId').toString(),
          localId: value.get<String>('localId').toString(),
          name: value.get<String>('name') ?? '',
          description: value.get<String>('description') ?? '',
          quantity: value.get('quantity'),
          groups: teste,
          setor: setor);

      debugPrint("Product criadu : $product");

      await db.addProduct(product);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> handleLiveQueryEventUpdate(
      LiveQueryEvent event, ParseObject value) async {
    try {
      ParseObject? groupObject = value.get<ParseObject>("groups");
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
        action: value.get<String>('action') ?? '',
        setor: value.get('setor'),
      );

      print(product.toJson());

      await db.updateProduct(product);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> handleLiveQueryEventDelete(
      LiveQueryEvent event, ParseObject value) async {
    try {
      ParseObject? groupObject = value.get<ParseObject>("groups");
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
        action: value.get<String>('action') ?? '',
        setor: value.get('setor'),
      );

      print(product.toJson());

      await db.deleteProductDB(product);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> getProductsDB() async {
    products.value = await db.getProductsDB();
    for (var element in products) {
      element.name;
    }
    print(products.value);
    print("Buscou os dados do DB");
    update();
  }

  Future<void> createProduct(Product product) async {
    try {
      final response = await Dio().post(
        '$b4a/create-product',
        options: Options(
          headers: {
            'X-Parse-Application-Id': KeyApplicationId,
            'X-Parse-REST-API-Key': KeyClientKey,
            'X-Parse-Session-Token': '${userToken}',
          },
        ),
        data: {
          "localId": product.localId,
          "group": product.groups,
          "name": product.name,
          "description": product.description,
          "quantity": product.quantity,
          "setor": product.setor
        },
      );

      if (response.statusCode == 200) {
        // Extrair o novo ID do produto do corpo da resposta
        final newProductId = response.data['result']['productId'];

        // Atualizar o ID do produto
        product.id = newProductId;

        // Agora você pode prosseguir com a atualização no banco de dados local
        await db.updateProduct(product);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List> getOfflineProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> productList = prefs.getStringList('offlineProducts') ?? [];
    products.value = [];

    for (String productJsonString in productList) {
      Map<String, dynamic> productJson = jsonDecode(productJsonString);
      Product product = Product.fromJson(productJson);
      products.add(product);
    }

    return products;
  }

  Future<void> createMovimentOffline(
      Moviment newMoviment, Product updatedProduct) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> productList = prefs.getStringList('offlineProducts') ?? [];

      // Adiciona o produto atualizado na lista de produtos offline
      productList.add(jsonEncode(updatedProduct.toJson()));

      // Salva a lista atualizada no shared_preferences
      prefs.setStringList('offlineProducts', productList);

      // Salva a movimentação offline
      List<String> movimentList = prefs.getStringList('offlineMoviments') ?? [];
      movimentList.add(jsonEncode(newMoviment.toJson()));
      prefs.setStringList('offlineMoviments', movimentList);
    } catch (e) {
      print(e);
    }
  }

  Future<void> changeProduct(Product product) async {
    try {
      final response = await Dio().post('$b4a/change-product',
          options: Options(
            headers: {
              'X-Parse-Application-Id': KeyApplicationId,
              'X-Parse-REST-API-Key': KeyClientKey,
              'X-Parse-Session-Token': '${userToken}',
            },
          ),
          data: {
            "id": product.id,
            "name": product.name,
            "description": product.description,
            "group": product.groups,
            "action": product.action
          });
      Product.fromJson(response.data['result']);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteProduct(Product product) async {
    try {
      final response = await Dio().post('$b4a/delete-product',
          options: Options(
            headers: {
              'X-Parse-Application-Id': KeyApplicationId,
              'X-Parse-REST-API-Key': KeyClientKey,
              'X-Parse-Session-Token': userToken,
            },
          ),
          data: {
            "productId": product.id,
          });
      Product.fromJson(response.data['result']);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString('userToken') ?? 'null';
    dio.options.headers = {
      'X-Parse-Application-Id': KeyApplicationId,
      'X-Parse-REST-API-Key': KeyClientKey,
      'X-Parse-Session-Token': userToken,
    };

    try {
      final response = await dio.post('$b4a/get-all-products');

      if (response.data["result"] != null) {
        List<Product> products = (response.data["result"] as List)
            .map((data) => Product.fromJson(data))
            .where((product) =>
                product.action !=
                'delete') // Filter out products with action 'delete'
            .toList();

        this.products.value = products;
        await db.saveProducts(products);
      }
    } catch (e) {
      print(e);
    }
  }
}

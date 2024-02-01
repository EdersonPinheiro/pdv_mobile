import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meu_estoque/page/product/product_page.dart';
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
          "group": product.group,
          "name": product.name,
          "description": product.description,
          "quantity": product.quantity,
          "setor": product.setor
        },
      );

      if (response.statusCode == 200) {}
    } catch (e) {
      print(e);
    }
  }

  Future<void> createProductOffline(Product product) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> productList = prefs.getStringList('offlineProducts') ?? [];
      productList.add(jsonEncode(product.toJson()));
      prefs.setStringList('offlineProducts', productList);

      products.value = productList.cast<Product>();
    } catch (e) {
      print(e);
    }
  }

  Future<void> editProductOffline(Product editedProduct) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> productList = prefs.getStringList('offlineProducts') ?? [];

      for (int i = 0; i < productList.length; i++) {
        Map<String, dynamic> productJson = jsonDecode(productList[i]);
        if (productJson['localId'] == editedProduct.localId) {
          // Atualiza as propriedades do produto com base nas alterações
          productJson['name'] = editedProduct.name;
          productJson['description'] = editedProduct.description;
          productJson['group'] = editedProduct.group;

          // Atualiza o produto na lista
          productList[i] = jsonEncode(productJson);
          break; // Sai do loop, pois encontrou o produto
        }
      }

      // Salva a lista atualizada no shared_preferences
      prefs.setStringList('offlineProducts', productList);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteProductOffline(Product product) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> productList = prefs.getStringList('offlineProducts') ?? [];

      // Remove o produto da lista offline
      productList.removeWhere((productJsonString) {
        Map<String, dynamic> productJson = jsonDecode(productJsonString);
        return productJson['localId'] == product.localId;
      });

      prefs.setStringList('offlineProducts', productList);
    } catch (e) {
      print(e);
    }
  }

  Future<void> createActionProductOffline(Product product, action) async {
    try {
      // Create a new Product instance with the input values
      Product newProduct = Product(
          id: id.text,
          localId: localId.text,
          name: name.text,
          quantity: int.parse(quantity.text),
          group: group.text,
          description: description.text,
          setor: setor.text,
          action: action);

      // Check if localId already exists in offline products
      if (actioProducts
          .any((product) => product.localId == newProduct.localId)) {
        // Handle duplicate localId as needed
        print("Product with the same localId already exists offline.");
        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> productList = prefs.getStringList('actionProducts') ?? [];
      productList.add(jsonEncode(product.toJson()));
      prefs.setStringList('actionProducts', productList);

      products.value = productList.cast<Product>();

      // Clear the text controllers
      id.clear();
      localId.clear();
      name.clear();
      quantity.clear();
      group.clear();
      description.clear();

      // Notify the UI that the list has been updated
      update();
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
            "group": product.group
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

  Future<List<Product>> getProducts() async {
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
            .toList();

        List<String> offlineProducts =
            products.map((product) => jsonEncode(product.toJson())).toList();
        prefs.setStringList('offlineProducts', offlineProducts);

        this.products.value = products;
      }
    } catch (e) {
      print(e);
    }
    return products.value;
  }
}

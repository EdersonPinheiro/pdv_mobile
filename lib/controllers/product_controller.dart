import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meu_estoque/view/product/product_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/constants.dart';
import '../model/product.dart';

class ProductController extends GetxController {
  final dio = new Dio();
  List products = <Product>[].obs;
  final localId = TextEditingController();
  final name = TextEditingController();
  final description = TextEditingController();
  final quantity = TextEditingController();

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
          //"group": product.group,
          "name": product.name,
          "description": product.description,
          "quantity": product.quantity,
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

      products = productList;
    } catch (e) {
      print(e);
    }
  }

  Future<List> getOfflineProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> productList = prefs.getStringList('offlineProducts') ?? [];
    products = [];

    for (String productJsonString in productList) {
      Map<String, dynamic> productJson = jsonDecode(productJsonString);
      Product product = Product.fromJson(productJson);
      products.add(product);
    }

    return products;
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
          productJson['quantity'] = editedProduct.quantity;

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
            "quantity": product.quantity
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

  Future<List> getProducts() async {
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
        products = (response.data["result"] as List)
            .map((data) => Product.fromJson(data))
            .toList();
      }
    } catch (e) {
      print(e);
    }
    return products;
  }
}

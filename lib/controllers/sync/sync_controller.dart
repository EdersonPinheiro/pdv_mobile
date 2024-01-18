import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/constants.dart';
import '../../model/product.dart';
import '../product_controller.dart';
import 'internet_connection_hook.dart';

class SyncController extends GetxController {
  InternetConnectionHook internetConnectionHook = InternetConnectionHook();
  final ProductController productController = Get.put(ProductController());
  var isConn = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkConnection(apiMethod);
  }

  apiMethod() {}

  Future<void> checkConnection(apiMethod) async {
    internetConnectionHook.startListening();
    try {
      internetConnectionHook.isConnected.listen((isConnected) async {
        if (isConnected) {
          // Se houver conexão, faça a chamada para a API de dados
          dynamic result = await InternetAddress.lookup("www.google.com");

          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            isConn.value = true;
            await syncOfflineProducts();
            await apiMethod();
          } else {
            isConn.value = false;
          }
        } else {
          print("Nada para sincronizar");
          isConn.value = false;
        }
      });
    } catch (e) {
      isConn.value = false;
      print(e);
    }
  }

  Future<void> syncOfflineProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> actionProducts = prefs.getStringList('actionProducts') ?? [];

    for (String productString in actionProducts) {
      Map<String, dynamic> productMap = jsonDecode(productString);
      Product product = Product.fromJson(productMap);

      if (product.action == "new") {
        await productController.createProduct(product);
      }

      // Remover o produto da lista de ações após a sincronização
      actionProducts.remove(productString);
    }

    // Atualizar a lista de ações no SharedPreferences após a sincronização
    prefs.setStringList('actionProducts', actionProducts);
  }
}

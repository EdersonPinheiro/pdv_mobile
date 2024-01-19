import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/constants.dart';
import '../../model/group.dart';
import '../../model/product.dart';
import '../group_controller.dart';
import '../product_controller.dart';
import 'internet_connection_hook.dart';

class SyncController extends GetxController {
  InternetConnectionHook internetConnectionHook = InternetConnectionHook();
  final ProductController productController = Get.put(ProductController());
  final GroupController groupController = Get.put(GroupController());
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

    // Create a copy of the list to avoid ConcurrentModificationError
    List<String> copyOfActionProducts = List.from(actionProducts);

    for (String productString in copyOfActionProducts) {
      Map<String, dynamic> productMap = jsonDecode(productString);
      Product product = Product.fromJson(productMap);

      if (product.action == "new") {
        await productController.createProduct(product);
      }

      // Remove the product from the original list of actions after synchronization
      actionProducts.remove(productString);
    }

    // Update the list of actions in SharedPreferences after synchronization
    prefs.setStringList('actionProducts', actionProducts);
  }

  Future<void> syncOfflineGroups() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> offlineGroups = prefs.getStringList('offlineGroups') ?? [];

    // Create a copy of the list to avoid ConcurrentModificationError
    List<String> copyOfOfflineGroups = List.from(offlineGroups);

    for (String groupString in copyOfOfflineGroups) {
      Map<String, dynamic> groupJson = jsonDecode(groupString);
      Group group = Group.fromJson(groupJson);

      // Adjust the condition based on your requirements
      if (group.action == "new") {
        await groupController.createGroup(group);
      } else if (group.action == "edit") {
        await groupController.editGroupOffline(group);
      } else if (group.action == "delete") {
        await groupController.deleteGroupOffline(group);
      }

      // Remove the group from the original list of offline groups after synchronization
      offlineGroups.remove(groupString);
    }

    // Update the list of offline groups in SharedPreferences after synchronization
    prefs.setStringList('offlineGroups', offlineGroups);
  }
}

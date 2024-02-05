import 'dart:convert';
import 'dart:io';
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
    checkConnection(sync);
  }

  Future<void> checkConnection(teste) async {
    internetConnectionHook.startListening();
    try {
      internetConnectionHook.isConnected.listen((isConnected) async {
        if (isConnected) {
          dynamic result = await InternetAddress.lookup("www.google.com");

          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            isConn.value = true;
            await sync();
          } else {
            isConn.value = false;
          }
        } else {
          print("No internet connection. Nothing to synchronize.");
          isConn.value = false;
        }
      });
    } catch (e) {
      isConn.value = false;
      print(e);
    }
  }

  sync() async {
    await syncOfflineItems<Product>(
      'actionproduct',
      (product) async {
        await productController.createProduct(product);
      },
      (product) async {
        await productController.changeProduct(product);
      },
    );
  }

  Future<void> syncOfflineItems<T>(
    String actionKey,
    void Function(T) createItem,
    void Function(T) editItem,
  ) async {
    List<Product> offlineItems = await db.getActionProduct();
    for (Product item in offlineItems) {
      if (item.action == "new") {
        createItem(item as T);
      } else if (item.action == "edit") {
        editItem(item as T);
      }
    }
    db.deleteActionDB('actionproduct');
  }
}

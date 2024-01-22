import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  apiMethod() async {
    await syncOfflineGroups();
    await syncOfflineProducts();
    // Add any additional synchronization methods here

    // Clear the lists of actions after synchronization
    clearOfflineGroups();
    clearOfflineProducts();
  }

  Future<void> checkConnection(apiMethod) async {
    internetConnectionHook.startListening();
    try {
      internetConnectionHook.isConnected.listen((isConnected) async {
        if (isConnected) {
          dynamic result = await InternetAddress.lookup("www.google.com");

          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            isConn.value = true;
            await apiMethod();
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
      } else if (product.action == "edit") {
        print("");
      }

      // Remove the product from the original list of actions after synchronization
      actionProducts.remove(productString);
    }

    // Update the list of actions in SharedPreferences after synchronization
    prefs.setStringList('actionProducts', actionProducts);
  }

  Future<void> syncOfflineGroups() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> offlineGroups = prefs.getStringList('actionGroups') ?? [];

    // Create a copy of the list to avoid ConcurrentModificationError
    List<String> copyOfOfflineGroups = List.from(offlineGroups);

    for (String groupString in copyOfOfflineGroups) {
      Map<String, dynamic> groupJson = jsonDecode(groupString);
      Group group = Group.fromJson(groupJson);

      // Adjust the condition based on your requirements
      if (group.action == "new") {
        await groupController.createGroup(group);
      } else if (group.action == "edit") {
        await groupController.editGroup(group);
      }

      // Remove the group from the original list of offline groups after synchronization
      offlineGroups.remove(groupString);
    }

    // Update the list of offline groups in SharedPreferences after synchronization
    prefs.setStringList('actionGroups', offlineGroups);
  }

  void clearOfflineProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('actionProducts');
  }

  void clearOfflineGroups() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('actionGroups');
  }
}

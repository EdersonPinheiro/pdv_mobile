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
    await syncOfflineItems<Group>(
      'actionGroups',
      (group) async {
        await groupController.createGroup(group);
      },
      (group) async {
        await groupController.editGroup(group);
      },
    );

    clearOfflineGroups();
    clearOfflineProducts();
  }

  Future<void> syncOfflineItems<T>(
    String actionKey,
    void Function(T) createItem,
    void Function(T) editItem,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> offlineItems = prefs.getStringList(actionKey) ?? [];

    // Create a copy of the list to avoid ConcurrentModificationError
    List<String> copyOfOfflineItems = List.from(offlineItems);

    for (String itemString in copyOfOfflineItems) {
      Map<String, dynamic> itemJson = jsonDecode(itemString);
      T item = _createItemFromJson<T>(itemJson);

      if (item is Group) {
        if (item.action == "new") {
          createItem(item);
        } else if (item.action == "edit") {
          editItem(item);
        }
      } else if (item is Product) {
        if (item.action == "new") {
          createItem(item);
        } else if (item.action == "edit") {
          editItem(item);
        }
      }

      // Remove the item from the original list of offline items after synchronization
      offlineItems.remove(itemString);
    }

    // Update the list of offline items in SharedPreferences after synchronization
    prefs.setStringList(actionKey, offlineItems);
  }

  T _createItemFromJson<T>(Map<String, dynamic> itemJson) {
    if (T == Group) {
      return Group.fromJson(itemJson) as T;
    } else if (T == Product) {
      return Product.fromJson(itemJson) as T;
    }
    // Handle other types if needed
    throw ArgumentError("Unsupported type");
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

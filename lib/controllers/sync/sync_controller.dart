import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:meu_estoque/model/type_moviment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/constants.dart';
import '../../model/group.dart';
import '../../model/product.dart';
import '../group_controller.dart';
import '../product_controller.dart';
import '../type_moviment_controller.dart';
import 'internet_connection_hook.dart';

class SyncController extends GetxController {
  InternetConnectionHook internetConnectionHook = InternetConnectionHook();
  final ProductController productController = Get.put(ProductController());
  final TypeMovimentController typeMovimentController =
      Get.put(TypeMovimentController());
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

  Future<void> sync() async {
    await syncOfflineItems<TypeMoviment>(
      'actiontypemoviment',
      (typeMoviment) async {
        await typeMovimentController.createTypeMoviment(typeMoviment);
      },
      (typeMoviment) async {
        await typeMovimentController.changeTypeMoviment(typeMoviment);
      },
      await db.getActionTypeMoviment(),
      (actionKey) => db.deleteActionDB(actionKey),
    );

    await syncOfflineItems<Group>(
      'actiongroups',
      (group) async {
        await groupController.createGroup(group);
      },
      (group) async {
        await groupController.editGroup(group);
      },
      await db.getActionGroup(),
      (actionKey) => db.deleteActionDB(actionKey),
    );

    await syncOfflineItems<Product>(
      'actionproduct',
      (product) async {
        await productController.createProduct(product);
      },
      (product) async {
        await productController.changeProduct(product);
      },
      await db.getActionProduct(), // Função para obter itens offline de Product
      (actionKey) => db.deleteActionDB(actionKey),
    );
  }

  Future<void> syncOfflineItems<T>(
    String actionKey,
    void Function(T) createItem,
    void Function(T) editItem,
    List<T> getOfflineItems,
    void Function(String) deleteActionDB,
  ) async {
    List<T> offlineItems = getOfflineItems;
    for (T item in offlineItems) {
      if (item is TypeMoviment) {
        TypeMoviment typeMoviment = item as TypeMoviment;
        if (typeMoviment.action == "new") {
          createItem(item);
        } else if (typeMoviment.action == "edit") {
          editItem(item);
        }
      } else if (item is Group) {
        Group group = item as Group;
        if (group.action == "new") {
          createItem(item);
        } else if (group.action == "edit") {
          editItem(item);
        }
      } else if (item is Product) {
        Product product = item as Product;
        if (product.action == "new") {
          createItem(item);
        } else if (product.action == "edit") {
          editItem(item);
        }
      }
    }
    deleteActionDB(actionKey);
  }
}

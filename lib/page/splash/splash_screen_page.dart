import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/user_controller.dart';
import '../../model/user.dart';
import '../home/home_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  final UserController userController = Get.put(UserController());
  /*
  GroupController groupController = GroupController();
  TypeMovimentController typeMovimentController = TypeMovimentController();
  MovimentController movimentController = MovimentController();
  ProductController productController = ProductController();
  final user = <User>[].obs;
  final groups = <Group>[].obs;
  final products = <Product>[].obs;
  final typemoviments = <TypeMoviment>[].obs;
  final moviments = <Moviment>[].obs;
  final db = DB();*/
  
  @override
  void initState() {
    super.initState();
    navigateToHomePage(); // Chama a função para navegar à página inicial após o tempo definido
  }

  Future<void> navigateToHomePage() async {
    await Future.delayed(const Duration(seconds: 2)); // Atraso de 3 segundos
    await userController.getUser();
    /*print("User");
    await db.saveUser(user);

    products.value = await productController.getProducts();
    print("Products");
    await db.saveProducts(products);

    groups.value = await groupController.getGroup();
    print("Groups");
    await db.saveGroups(groups);

    moviments.value = await movimentController.getMov();
    await db.saveMoviment(moviments);

    typemoviments.value = await typeMovimentController.getTypeMoviment();
    print("Groups");
    await db.saveTypeMoviment(typemoviments);

    try {
      GetIt.instance.registerLazySingleton<EventBus>(
        () => EventBus(),
      );
    } catch (e) {
      print(e);
    }*/

    
    Get.off(HomePage());
  
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.indigo,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Meu Estoque",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

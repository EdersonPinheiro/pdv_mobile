import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meu_estoque/model/type_moviment.dart';
import 'package:meu_estoque/page/relatorios/relatorio_estoque_atual.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';
import '../../controllers/group_controller.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/sync/sync_controller.dart';
import '../../controllers/type_moviment_controller.dart';
import '../../controllers/user_controller.dart';
import '../../model/group.dart';
import '../../model/product.dart';
import '../../model/user.dart';
import '../auth/login_page.dart';
import '../payment/payment_page.dart';
import '../relatorios/relatorio_page.dart';
import 'components/button.dart';
import '../entrada_saida/entrada_saida_page.dart';
import '../group/group_page.dart';
import '../moviment/moviment_page.dart';
import '../product/product_page.dart';
import '../type_moviment/type_moviment_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SyncController syncController = Get.put(SyncController());
  final UserController userController = Get.put(UserController());
  final ProductController productController = Get.put(ProductController());
  final GroupController groupController = Get.put(GroupController());
  final TypeMovimentController typeMovimentController =
      Get.put(TypeMovimentController());
  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  void checkConnection() {
    if (syncController.isConn.value == true) {
      productController.getProducts();
      groupController.getGroup();
      typeMovimentController.getTypeMoviment();
    } else {
      productController.getProductsDB();
      groupController.getGroupsDB();
      typeMovimentController.getTypeMovimentDB();
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Meu Estoque",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        actions: [
          Obx(() {
            return IconButton(
              icon: Icon(
                syncController.isConn.value == true
                    ? Icons.signal_wifi_4_bar
                    : Icons.wifi_off,
                color: syncController.isConn.value ? Colors.green : Colors.red,
              ),
              onPressed: () async {
                List<TypeMoviment> actionTypeMoviment =
                    await db.getActionTypeMoviment();
                List<Group> actionGroups = await db.getActionGroup();
                List<Product> actionProducts = await db.getActionProduct();
                actionProducts.forEach((product) {
                  print(product); 
                });
                actionGroups.forEach((group) {
                  print(group);
                });
                actionTypeMoviment.forEach((typeMoviment) {
                  print(typeMoviment);
                });
              },
            );
          }),
        ],
      ),
      drawer: Drawer(
        child: Obx(
          () => ListView.builder(
            itemCount: userController.userL.length,
            itemBuilder: (BuildContext context, int index) {
              User user = userController.userL[index];
              return Column(
                children: [
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(color: Colors.indigo),
                    currentAccountPicture: CircleAvatar(
                      /*backgroundImage: syncController.isConn.value == true
                          ? NetworkImage("")
                          : NetworkImage(""),*/
                      backgroundColor: Colors.white,
                    ),
                    accountName: Text(
                      user.fullname,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    otherAccountsPictures: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            user.premium == true
                                ? Icons.workspace_premium
                                : Icons.highlight_off_rounded,
                            color: Colors.orange[400],
                          )),
                    ],
                    accountEmail: Text(
                      user.email,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text("Setor: ${user.setor}"),
                    trailing: Obx(() {
                      return IconButton(
                        icon: Icon(
                          syncController.isConn.value == true
                              ? Icons.signal_wifi_4_bar
                              : Icons.wifi_off,
                          color: syncController.isConn.value
                              ? Colors.green
                              : Colors.red,
                        ),
                        onPressed: () async {},
                      );
                    }),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Meu Perfil'),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Relatorios'),
                    onTap: () {
                      Get.to(RelatoriosPage());
                    },
                  ),
                  user.premium == true
                      ? Container()
                      : ListTile(
                          title: AnimatedTextKit(
                            animatedTexts: [
                              ColorizeAnimatedText(
                                "Premium",
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                                speed: const Duration(milliseconds: 150),
                                colors: [
                                  Colors.orange,
                                  Colors.amber,
                                  Colors.white
                                ], // Ajuste a velocidade conforme necessário
                              ),
                            ],
                          ),
                          onTap: () {
                            Get.to(PaymentPage());
                          },
                        ),
                  SizedBox(height: 20),
                  ListTile(
                    title: Text('Sair'),
                    onTap: () async {
                      logOut();
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
      body: Container(
        color: Colors.indigo,
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = (constraints.maxWidth / 180).floor();

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 1.2,
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 0,
                      ),
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Button(
                          title: _getButtonTitle(index),
                          icon: _getButtonIcon(index),
                          onPressed: () {
                            _navigateToPage(index);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAll(const LoginPage());
  }

  String _getButtonTitle(int index) {
    switch (index) {
      case 0:
        return "Entrada/Saída";
      case 1:
        return "Produto";
      case 2:
        return "Movimentações";
      case 3:
        return "Tipo/Movimentação";
      case 4:
        return "Grupos";
      case 5:
        return "Operadores";
      default:
        return "";
    }
  }

  IconData _getButtonIcon(int index) {
    switch (index) {
      case 0:
        return Icons.swap_horiz;
      case 1:
        return Icons.shopping_basket;
      case 2:
        return Icons.move_to_inbox;
      case 3:
        return Icons.assessment;
      case 4:
        return Icons.add_box;
      case 5:
        return Icons.person;
      default:
        return Icons.error;
    }
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        Get.to(EntradaSaidaPage());
        break;
      case 1:
        Get.to(ProductsPage());
        break;
      case 2:
        Get.to(MovimentacoesPage());
        break;
      case 3:
        Get.to(TypeMovimentPage());
        break;
      case 4:
        Get.to(GroupPage());
        break;
      case 5:
        //Get.to(() => OperatorPage());
        break;
    }
  }
}

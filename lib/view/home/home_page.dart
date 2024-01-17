import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../group/group_page.dart';
import '../product/product_page.dart';
import '../type_moviment/type_moviment_page.dart';
import 'components/button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var height, width;
  //BannerAd? _banner;
  /*final SyncController syncController = Get.find();
  AuthController authController = AuthController();
  final userL = <User>[].obs;
  final teste = <User>[].obs;
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    getDataDB();
    _createBannerAd();
  }

  void _createBannerAd() {
    _banner = BannerAd(
        size: AdSize.banner,
        adUnitId: AdMobService.bannerAdUnitId!,
        listener: AdMobService.bannerListener,
        request: const AdRequest())
      ..load();
  }

  final teste2 = <Product>[].obs;

  void getProductsApi() async {
    teste2.value = await productController.getProducts();
    await db.saveProducts(teste2);
    print("Buscou os dados da api");
  }

  void getDataDB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('userToken') ?? 'null';

    if (userToken.isNotEmpty) {
      userL.value = await db.getUserDB();
      if (userL.value.isEmpty) {
        Get.offAll(LoginPage());
      }
    }

    if (userToken == 'null') {
      Get.offAll(LoginPage());
    }
  }*/

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Meu Estoque",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          centerTitle: true,
          backgroundColor: Colors.indigo,
        ),
        drawer: Drawer(
          child: Container(),/*Obx(
            () => ListView.builder(
              itemCount: userL.length,
              itemBuilder: (BuildContext context, int index) {
                User user = userL[index];
                return Column(
                  children: [
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(color: Colors.indigo),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: syncController.isConn.value == true
                            ? NetworkImage(
                                "https://source.unsplash.com/random/200x200")
                            : NetworkImage(""),
                        backgroundColor: Colors.white,
                      ),
                      accountName: Text(
                        user.fullname,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                    /*ListTile(
                      title: Text('Meu Perfil'),
                      onTap: () {},
                    ),
                    ListTile(
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
                        //Get.to(PaymentPage());
                      },
                    ),*/
                    SizedBox(height: 20),
                    ListTile(
                      title: Text('Sair'),
                      onTap: () async {
                        logOut();
                      },
                    ),
                    const Divider(
                      height: 60,
                    ),
                  ],
                );
              },
            ),
          ),*/
        ),
        body: Builder(
          builder: (context) => Container(
            color: Colors.indigo,
            height: height,
            width: width,
            child: Flexible(
              flex: 0,
              fit: FlexFit.tight,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      width: width,
                      child: GridView.count(
                        crossAxisCount: 2, // número de colunas
                        childAspectRatio: 1.2,
                        mainAxisSpacing: 0,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          Button(
                            title: "Entrada/Saída",
                            icon: Icons.swap_horiz,
                            onPressed: () {
                              //Get.to(EntradaSaidaPage());
                            },
                          ),
                          Button(
                            title: "Produto",
                            icon: Icons.shopping_basket,
                            onPressed: () {
                              Get.to(ProductsPage());
                            },
                          ),
                          Button(
                            title: "Movimentações",
                            icon: Icons.move_to_inbox,
                            onPressed: () {
                              //Get.to(const MovimentacoesPage());
                            },
                          ),
                          Button(
                            title: "Tipo/Movimentação",
                            icon: Icons.assessment,
                            onPressed: () {
                              Get.to(TypeMovimentPage());
                            },
                          ),
                          Button(
                            title: "Grupos",
                            icon: Icons.add_box,
                            onPressed: () {
                              Get.to(GroupPage());
                            },
                          ),
                          Button(
                            title: "Operadores",
                            icon: Icons.person,
                            onPressed: () {
                              //Get.to(() => OperatorPage());
                            },
                          ),
                          /*Button(
                                          title: "Relatórios",
                                          icon: Icons.insert_drive_file,
                                          onPressed: () {
                                Get.to(RelatoriosPage());
                                          },
                                  ),*/
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        /*bottomNavigationBar: _banner == null
            ? Container()
            : Container(
                margin: const EdgeInsets.only(bottom: 12),
                height: 52,
                child: AdWidget(ad: _banner!),
              )*/);
  }

  /*void logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAll(const LoginPage());
  }*/
}
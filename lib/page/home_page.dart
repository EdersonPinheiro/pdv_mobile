import 'package:efipay/efipay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../graphs/bar_page.dart';
import 'auth/login_page.dart';
import 'cliente/cliente_page.dart';
import 'payment/create_one_step_card_payment.dart';
import 'credentials.dart';
import 'payment/plans.dart';
import 'pdv.dart';
import 'product/product_page.dart';
import 'static/static_page.dart';
import 'venda/order_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 3;

  // Lista de páginas para serem exibidas
  final List<Widget> _pages = [
    ProductPage(), // Página 0
    ClientePage(), // Página 1
    PdvPage(), // Página 2
    OrderPage(), // Página 3
    BarPage(), // Página 4
  ];

  // Função chamada ao selecionar um item da BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAll(const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepOrange,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      'https://source.unsplash.com/random/200x200',
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Ederson",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "edersonspt@gmail.com",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
            ListTile(
              title: Text('Premium'),
              onTap: () async {
                Get.to(Plans());
              },
            ),
            ListTile(
              title: Text('Configurações'),
              onTap: () {
                //Get.to(Configuracoes());
              },
            ),
            ListTile(
              title: Text('Sair'),
              onTap: () {
                logOut();
              },
            ),
          ],
        ),
      ),
      body: _pages[
          _selectedIndex], // Exibe a página correspondente ao índice selecionado
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit_square),
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () => _onItemTapped(1),
            ),
            GestureDetector(
              onTap: () {
                Get.to(PdvPage());
              },
              child: WillPopScope(
                onWillPop: () async {
                  // Impedir a ação de voltar
                  return false;
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  padding: EdgeInsets.all(20),
                  child: Icon(Icons.shopping_cart, color: Colors.white),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.description),
              onPressed: () => _onItemTapped(3),
            ),
            IconButton(
              icon: Icon(Icons.bar_chart),
              onPressed: () => _onItemTapped(4),
            ),
          ],
        ),
      ),
    );
  }
}

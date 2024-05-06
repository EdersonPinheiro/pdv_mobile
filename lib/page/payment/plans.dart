import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdv_mobile/page/payment/confirm_method_payment_page.dart';
import '../../controller/cart_controller.dart';
import 'subscription_card.dart';

class Plans extends StatefulWidget {
  //const Plans({Key key});

  @override
  _PlansState createState() => _PlansState();
}

class _PlansState extends State<Plans> with SingleTickerProviderStateMixin {
  var height, width;
  late TabController _tabController;
  final CartController checkoutController = Get.put(CartController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Assine o Plano Premium!'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            color: Colors.white, // Cor de fundo diferente para a segunda guia
            height: height,
            width: width,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  width: width,
                  child: SubscriptionCard(
                    title: "Premium",
                    description: 'R\$ 29,99',
                    widgets: [
                      _buildListItem(
                          "Criação de Produtos - Ilimitado", Colors.green),
                      _buildListItem(
                          "Criação de Grupos - Ilimitado", Colors.green),
                      _buildListItem(
                          "Criação de Tipo/Mov - Ilimitado", Colors.green),
                      _buildListItem(
                          "Criação de Operadores - Ilimitado", Colors.green),
                      _buildListItem(
                          "Persistência dos Dados Offline", Colors.green),
                      _buildListItem("Sincronização dos Dados Offline a Nuvem",
                          Colors.green),
                      _buildListItem("Relatórios", Colors.green),
                      _buildListItem("Melhoria Continua", Colors.green),
                      _buildListItem("Suporte", Colors.green),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Get.to(ConfirmMethodPaymentPage());
                  },
                  child: AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                        "Assinar Premium",
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                        speed: const Duration(milliseconds: 150),
                        colors: [Colors.orange, Colors.amber, Colors.white],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.indigo,
            height: height,
            width: width,
            child: Column(
              children: [
                SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  width: width,
                  child: SubscriptionCard(
                    title: "Basic",
                    description: 'Plano Atual',
                    widgets: [
                      _buildListItem(
                          "Criação de Produtos - Máx. 10", Colors.green),
                      _buildListItem(
                          "Criação de Grupos - Máx. 5", Colors.green),
                      _buildListItem(
                          "Criação de Tipo/Mov - Máx 2", Colors.green),
                      _buildListItem2("Criação de Operadores", Colors.red),
                      _buildListItem(
                          "Persistência dos Dados Offline", Colors.green),
                      _buildListItem2("Sincronização dos Dados Offline a Nuvem",
                          Colors.red),
                      _buildListItem2("Relatórios", Colors.red),
                      _buildListItem2("Suporte", Colors.red),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

Widget _buildListItem(String text, Color iconColor) {
  return Row(
    children: <Widget>[
      Icon(
        Icons.check,
        color: iconColor,
      ),
      Text(
        text,
      ),
    ],
  );
}

Widget _buildListItem2(String text, Color iconColor) {
  return Row(
    children: <Widget>[
      Icon(
        Icons.clear, // Ícone de uma cruz (x)
        color: Colors.red, // Define a cor como vermelha
      ),
      Text(
        text,
      ),
    ],
  );
}

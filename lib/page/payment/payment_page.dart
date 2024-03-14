import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meu_estoque/controllers/checkout_controller.dart';
import 'package:meu_estoque/page/payment/components_payment/payment_option_button.dart';
import 'package:meu_estoque/page/payment/form_payment.dart';
import 'subscription_card.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage>
    with SingleTickerProviderStateMixin {
  var height, width;
  late TabController _tabController;
  final CheckoutController checkoutController = Get.put(CheckoutController());

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
                title: "Plano 12 Meses",
                description: '30 R\$/mês',
                widgets: [
                  _buildListItem(
                      "Criação de Produtos - Ilimitado", Colors.green),
                  _buildListItem("Criação de Grupos - Ilimitado", Colors.green),
                  _buildListItem(
                      "Criação de Tipo/Mov - Ilimitado", Colors.green),
                  _buildListItem(
                      "Criação de Operadores - Ilimitado", Colors.green),
                  _buildListItem(
                      "Persistência dos Dados Offline", Colors.green),
                  _buildListItem(
                      "Sincronização dos Dados Offline a Nuvem", Colors.green),
                  _buildListItem("Relatórios", Colors.green),
                  _buildListItem("Melhoria Continua", Colors.green),
                  _buildListItem("Suporte", Colors.green),
                ],
                buy: ElevatedButton(
                  onPressed: () {
                    _showPaymentOptionsDialog();
                  },
                  child: Text('Assinar Agora'),
                ),
              ),
            ),
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
                title: "Plano 6 Meses",
                description: '60 R\$/mês',
                widgets: [
                  _buildListItem(
                      "Criação de Produtos - Ilimitado", Colors.green),
                  _buildListItem("Criação de Grupos - Ilimitado", Colors.green),
                  _buildListItem(
                      "Criação de Tipo/Mov - Ilimitado", Colors.green),
                  _buildListItem(
                      "Criação de Operadores - Ilimitado", Colors.green),
                  _buildListItem(
                      "Persistência dos Dados Offline", Colors.green),
                  _buildListItem(
                      "Sincronização dos Dados Offline a Nuvem", Colors.green),
                  _buildListItem("Relatórios", Colors.green),
                  _buildListItem("Melhoria Continua", Colors.green),
                  _buildListItem("Suporte", Colors.green),
                ],
                buy: ElevatedButton(
                  onPressed: () {
                    _showPaymentOptionsDialog();
                  },
                  child: Text('Assinar Agora'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  void _showPaymentOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Selecione a Forma de Pagamento",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PaymentOptionButton(
                  iconData: Icons.pix,
                  text: 'Pix',
                  onPressed: () {
                    checkoutController.checkoutPix();
                  }),
              SizedBox(height: 10),
              PaymentOptionButton(
                  iconData: Icons.credit_card,
                  text: 'Cartão',
                  onPressed: () {
                    showInfoCard();
                  })
            ],
          ),
        );
      },
    );
  }

  void showInfoCard() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Preencha os dados do cartão"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nome'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'CPF'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-mail'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Data de Nascimento'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Telefone'),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Lógica para salvar os dados do cartão
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}

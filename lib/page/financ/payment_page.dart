import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/constants.dart';
import '../../model/order.dart';
import '../../model/statistics.dart';
import '../home_page.dart';
import '../venda/payment_color.dart';
import '../venda/troco_page.dart';

class PaymentPage extends StatefulWidget {
  final Order order;

  const PaymentPage({Key? key, required this.order}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedPayment = 'Dinheiro';
  int totalTransactions = 0;
  double totalRevenue = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página de Pagamento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: ListTile(
                leading: Icon(
                  getPaymentInfo(selectedPayment).icon,
                  color: getPaymentInfo(selectedPayment).color,
                ),
                title: Text(
                  'Total a pagar:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text('R\$ ${widget.order.total}'),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Formas de Pagamento:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            buildPaymentMethod('Dinheiro'),
            buildPaymentMethod('Credito'),
            buildPaymentMethod('Debito'),
            buildPaymentMethod('Pix'),
            Expanded(child: Container()),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (selectedPayment == 'Dinheiro') {
                        double total = double.parse(widget.order.total);
                        Get.to(TrocoPage(order: widget.order));
                      }
                      widget.order.formaPagamento = selectedPayment;
                      int millisSinceEpoch =
                          DateTime.now().millisecondsSinceEpoch;
                      String localId = generateLocalId(4) + '-1';
                      print('$millisSinceEpoch');
                      Order order = Order(
                        localId: localId,
                        type: widget.order.type,
                        date: millisSinceEpoch,
                        clienteId: widget.order.clienteId,
                        vendedor: 'Ederson',
                        product: widget.order.product,
                        total: widget.order.total.toString(),
                        subtotal: widget.order.subtotal.toString(),
                        formaPagamento: selectedPayment,
                      );
                      await db.addOrder(order);
                      addStatistics(double.parse(order.total)); // Passando o valor da transação para adicionar estatísticas
                      Get.offAll(HomePage());
                    },
                    child: Text(
                      selectedPayment == 'Dinheiro' ? 'AVANÇAR' : 'CONCLUIR',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String generateLocalId(int length) {
    const chars = '0123456789';
    final random = Random();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  void addStatistics(double transactionValue) async {
    totalTransactions++;
    totalRevenue += transactionValue;

    // Calculando o ticket médio
    double averageTicket = totalRevenue / totalTransactions;

    // Obtendo os dados para as estatísticas
    String mostUsedPaymentMethod = selectedPayment;
    String topSpendingClient = widget.order.clienteId.toString(); // Assumindo que clienteId é o identificador do cliente
    String bestSellingProduct = widget.order.product.toString();
    int millisSinceEpoch = DateTime.now().millisecondsSinceEpoch;
    String localId = generateLocalId(4) + '-1';

    // Criando o objeto Statistics
    Statistics statistics = Statistics(
      localId: localId,
      totalRevenue: totalRevenue.toString(),
      mostUsedPaymentMethod: mostUsedPaymentMethod,
      averageTicket: averageTicket.toString(),
      topSpendingClient: topSpendingClient,
      bestSellingProduct: bestSellingProduct,
      date: millisSinceEpoch,
    );

    // Adicionando as estatísticas ao banco de dados
    await db.addStatistics(statistics);
  }

  Widget buildPaymentMethod(String method) {
    PaymentInfo paymentInfo = getPaymentInfo(method);
    return Card(
      color: selectedPayment == method ? Colors.blue[100] : null,
      child: ListTile(
        onTap: () {
          setState(() {
            selectedPayment = method;
          });
        },
        leading: Icon(
          paymentInfo.icon,
          color: paymentInfo.color,
        ),
        title: Text(method),
        trailing: selectedPayment == method ? Icon(Icons.check) : null,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Importe para usar o DateFormat
import '../../constants/constants.dart';
import '../../model/order.dart';
import 'order_details_page.dart';
import 'payment_color.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<Order>? orders;
  String selectedDateType = 'Hoje';

  @override
  void initState() {
    super.initState();
    getOrders();
  }

  Future<void> getOrders() async {
    orders = await db.getOrdersByDate(selectedDateType);
    if (orders != null) {
      orders!.sort((a, b) => b.date.compareTo(a.date));
    }
    setState(() {});
  }

  void _showDateSelectionSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Container(
        margin: EdgeInsets.symmetric(),
        child: Wrap(
          spacing: 20,
          children: [
            _buildDateSelectionButton(context, 'Hoje'),
            _buildDateSelectionButton(context, 'Ontem'),
            _buildDateSelectionButton(context, 'Últimos 7 dias'),
            _buildDateSelectionButton(context, 'Últimos 30 dias'),
            _buildDateSelectionButton(context, 'Últimos 3 meses'),
            _buildDateSelectionButton(context, 'Últimos 6 meses'),
          ],
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _buildDateSelectionButton(BuildContext context, String dateType) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedDateType = dateType;
              });
              getOrders();
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            child: Container(
              width: constraints.maxWidth / 3 -
                  8, // Ajuste para levar em conta o espaço do Card
              padding: EdgeInsets.all(8),
              child: Center(
                child: Text(
                  dateType,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double total = 0.0;

    if (orders != null) {
      for (Order order in orders!) {
        total += double.parse(order.total);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Vendas'),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      selectedDateType,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () {
                        _showDateSelectionSnackBar(context);
                      },
                    ),
                  ],
                ),
                Text(
                  'Total: R\$ $total',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return orders != null
                    ? ListView.builder(
                        itemCount: orders?.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final Order order = orders![index];
                          final paymentInfo =
                              getPaymentInfo(order.formaPagamento.toString());

                          // Convertendo o timestamp para um objeto DateTime
                          final dateTime =
                              DateTime.fromMillisecondsSinceEpoch(order.date);

                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(OrderDetailsPage(
                                  order: order,
                                ));
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: paymentInfo.color,
                                            child: Icon(
                                              paymentInfo.icon,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              'Nº ${order.localId}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Text('•'),
                                          SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              '${order.formaPagamento}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          SizedBox(width: 40),
                                          Expanded(
                                            child: Text(
                                              DateFormat('dd/MM/yyyy')
                                                  .format(dateTime),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'R\$ ${order.total}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        '${order.product.length} Items',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}

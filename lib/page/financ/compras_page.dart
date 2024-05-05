import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/product.dart';
import '../../constants/constants.dart';
import '../../controller/product_controller.dart';
import '../../model/order.dart';
import 'confirm_order_page.dart';

class ComprasPage extends StatefulWidget {
  @override
  _ComprasPageState createState() => _ComprasPageState();
}

class _ComprasPageState extends State<ComprasPage> {
  final ProductController productController = Get.put(ProductController());
  List<Product> cart = [];
  Order? order;

  @override
  void initState() {
    super.initState();
  }

  Future<void> getProducts() async {}

  void addToCart(Product product) {
    setState(() {
      cart.add(product);
      //order?.total = order?.valueTotal() ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Pesquisar por nome ou código',
              ),
              onChanged: (value) {
                // Lógica para pesquisar produtos por nome ou código
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final product = cart[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('R\$ ${product.priceSell}'),
                  trailing: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      addToCart(product);
                    },
                  ),
                );
              },
            ),
          ),
          Divider(),
          Text('Itens no Carrinho: ${cart.length}'),
          //Text('Valor Total: R\$ ${order!.valueTotal()}'),
          ElevatedButton(
            onPressed: () {
              int millisSinceEpoch = DateTime.now().millisecondsSinceEpoch;
              Order order = Order(
                id: uuid.v4(),
                localId: uuid.v4(),
                type: 'Venda',
                date: millisSinceEpoch,
                clienteId: 'cliente',
                vendedor: 'vendedor',
                product: cart,
                total: '0',
                subtotal: '0',
              );
              //order.total = order.valueTotal();
              Get.to(ConfirmOrderPage(
                order: order,
              ));
            },
            child: Text('R\$'),
          ),
        ],
      ),
    );
  }
}

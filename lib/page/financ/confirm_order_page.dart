import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/order.dart'; // Importe o modelo Order
import '../../model/product.dart';
import '../venda/cliente_page_frete.dart';
import '../venda/desconto_page.dart';
import '../venda/frete_page.dart';
import 'payment_page.dart';

class ConfirmOrderPage extends StatefulWidget {
  final Order order;

  const ConfirmOrderPage({Key? key, required this.order}) : super(key: key);

  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void updateClienteName(String clienteNome) {
    setState(() {
      widget.order.clienteNome = clienteNome;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Order'),
        actions: [
          Row(
            children: [
              widget.order.clienteNome == null
                  ? TextButton(
                      onPressed: () {
                        Get.to(ClientePageFrete(
                            order: widget.order,
                            updateClienteName: updateClienteName));
                      },
                      child: Text('Cliente'),
                    )
                  : Text('${widget.order.clienteNome}'),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.order.product.length,
              itemBuilder: (context, index) {
                final product = widget.order.product[index];
                return ListTile(
                  title: Row(
                    children: [
                      Text('${product.quantitySelected}'),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.name),
                            Text('Estoque Atual: ${product.quantity}'),
                          ],
                        ),
                      ),
                      Text(
                          'R\$ ${product.quantitySelected * double.parse(product.priceSell)}'),
                    ],
                  ),
                );
              },
            ),
          ),
          Text('Tipo de pedido: ${widget.order.type}'),
          Text('Data do pedido: ${widget.order.date}'),
          Text('Cliente: ${widget.order.clienteId}'),
          Text('Vendedor: ${widget.order.vendedor}'),
          Text('Forma Pgto: ${widget.order.formaPagamento}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.delivery_dining,
                        size: 32), // Defina o tamanho do ícone aqui
                    onPressed: () {
                      if (widget.order.clienteNome != null) {
                        Get.to(FretePage(order: widget.order));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ClientePageFrete(
                                        order: widget.order,
                                        updateClienteName: updateClienteName),
                                  ),
                                );
                              },
                              child: Text(
                                  'Selecione um cliente para incluir o frete'),
                            ),
                            backgroundColor: Colors.blue,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  Text(widget.order.desconto != null
                      ? 'Subtotal: R\$ ${widget.order.subtotal}'
                      : ''),
                  Row(
                    children: [
                      widget.order.valorFrete == null
                          ? Container()
                          : Row(children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    widget.order.valorFrete = null;
                                    if (widget.order.tipoDesconto ==
                                        TipoDesconto.Percentual) {
                                      double subtotal =
                                          double.parse(widget.order.subtotal);
                                      double desconto = double.parse(
                                          widget.order.desconto ?? '0');
                                      double total = subtotal -
                                          (subtotal * desconto / 100);
                                      widget.order.total = total.toString();
                                    } else {
                                      double subtotal =
                                          double.parse(widget.order.subtotal);
                                      double desconto = double.parse(
                                          widget.order.desconto ?? '0');
                                      double total = subtotal - desconto;
                                      widget.order.total = total.toString();
                                    }
                                  });
                                },
                                icon: Icon(Icons.close_sharp),
                              ),
                              Text(
                                'Entrega: R\$ ${widget.order.valorFrete}',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ]),
                    ],
                  ),
                  Row(
                    children: [
                      widget.order.desconto == null
                          ? TextButton(
                              onPressed: () async {
                                final updatedOrder = await Get.to(
                                    DescontoPage(order: widget.order));
                                if (updatedOrder != null) {
                                  setState(() {
                                    widget.order.total = updatedOrder.total;
                                    widget.order.desconto =
                                        updatedOrder.desconto;
                                  });
                                }
                              },
                              child: Text(
                                "Dar Desconto",
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : Row(children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    double subtotal = double.parse(
                                        widget.order.subtotal ?? '0');
                                    double valorFrete = double.parse(
                                        widget.order.valorFrete ?? '0');
                                    double total = subtotal + valorFrete;
                                    widget.order.desconto =
                                        null; // Assuming you want to clear the discount
                                    widget.order.total = total.toString();
                                  });
                                },
                                icon: Icon(Icons.close_sharp),
                              ),
                              Text(
                                'Desconto: R\$ ${widget.order.desconto}',
                                style: TextStyle(color: Colors.red),
                              ),
                            ]),
                    ],
                  ),
                  Text('Total: R\$ ${widget.order.total}'),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(PaymentPage(
                      order: widget.order,
                    ));
                  },
                  child: Text('AVANÇAR'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

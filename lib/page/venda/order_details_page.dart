import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'dart:io';

import '../../model/order.dart';


class OrderDetailsPage extends StatefulWidget {
  final Order order;

  const OrderDetailsPage({Key? key, required this.order}) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {

  Future<void> _generateAndSharePDF(Order order) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Vendedor: ${order.vendedor}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 16.0),
              pw.Text(
                '${order.product.length} Itens',
                style: pw.TextStyle(fontSize: 16.0),
              ),
              pw.SizedBox(height: 16.0),
              for (var product in order.product)
                pw.Container(
                  margin: pw.EdgeInsets.symmetric(vertical: 4.0),
                  child: pw.Row(
                    children: [
                      pw.Text(
                        'Qtd. ${product.quantitySelected}',
                      ),
                      pw.SizedBox(
                          width:
                              8.0), // Espaçamento entre a quantidade e o nome do produto
                      pw.Expanded(
                        child: pw.Text(
                          '${product.name}',
                        ),
                      ),
                      pw.SizedBox(
                          width:
                              8.0), // Espaçamento entre o nome do produto e o preço de venda
                      pw.Text(
                        'R\$ ${product.priceSell}',
                        textAlign: pw.TextAlign.right, // Alinhamento à direita
                      ),
                    ],
                  ),
                ),
              pw.SizedBox(height: 16.0),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Expanded(
                      child: pw
                          .SizedBox()), // Espaço vazio para alinhar o preço de venda com o subtotal
                  pw.Text(
                    'Subtotal: R\$ ${order.subtotal}',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 16.0),
              pw.Divider(),
              pw.SizedBox(height: 16.0),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('Desconto: R\$ ${order.desconto ?? 0.00}'),
                        pw.Text('Entrega: R\$ ${order.valorFrete ?? 0.00}'),
                        pw.Text('${order.formaPagamento ?? 'N/A'}'),
                        pw.SizedBox(height: 16.0),
                        pw.Divider(),
                        pw.SizedBox(height: 16.0),
                        pw.Text(
                          'Total: R\$ ${order.total}',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/order_details.pdf");
    await file.writeAsBytes(await pdf.save());

    // Compartilhar o PDF
    Share.shareFiles([file.path], text: 'Detalhes do Pedido');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Pedido'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vendedor: ${widget.order.vendedor}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              '${widget.order.product.length} Itens',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            for (var product in widget.order.product)
              ListTile(
                title: Row(
                  children: [
                    Text('${product.quantitySelected} ${product.name}'),
                    Spacer(), // Adiciona um espaço flexível para alinhar o preço à direita
                    Text('R\$ ${product.priceSell}',
                        textAlign: TextAlign.right),
                  ],
                ),
              ),
            SizedBox(height: 16.0),
            Divider(),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Subtotal: R\$ ${widget.order.subtotal}'),
                      Text('Desconto: R\$ ${widget.order.desconto ?? 0.00}'),
                      Text('Entrega: R\$ ${widget.order.valorFrete ?? 0.00}'),
                      Text('${widget.order.formaPagamento ?? 'N/A'}'),
                      SizedBox(height: 16.0),
                      Divider(),
                      SizedBox(height: 16.0),
                      Text(
                        'Total: R\$ ${widget.order.total}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                // Implementar ação para cancelar venda
              },
              child: Text('Cancelar Venda'),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _generateAndSharePDF(widget.order);
                    },
                    child: Text('Compartilhar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../controllers/product_controller.dart';
import '../../model/product.dart'; // Importe a classe Product aqui

class RelatorioEstoqueAtual extends StatefulWidget {
  const RelatorioEstoqueAtual({Key? key}) : super(key: key);

  @override
  State<RelatorioEstoqueAtual> createState() => _RelatorioEstoqueAtualState();
}

class _RelatorioEstoqueAtualState extends State<RelatorioEstoqueAtual> {
  final ProductController productController = Get.put(ProductController());
  Future<void> _gerarRelatorio() async {
    // Obter produtos offline antes de gerar o relatório
    List offlineProducts = await productController.getOfflineProducts();

    final pdf = pw.Document();

    for (Product product in offlineProducts) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Relatório de Estoque',
                  style:
                      pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.Text('Nome do Produto: ${product.name}'),
              pw.Text('Descrição: ${product.description}'),
              pw.Text('Quantidade: ${product.quantity}'),
            ],
          ),
        ),
      );
    }

    // Obtém o diretório de documentos do aplicativo
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/estoque_repo.pdf';

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    print('Relatório de Estoque gerado com sucesso: $filePath');

    OpenFile.open(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatório de Estoque Atual'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _gerarRelatorio,
          child: Text('Gerar Relatório'),
        ),
      ),
    );
  }
}

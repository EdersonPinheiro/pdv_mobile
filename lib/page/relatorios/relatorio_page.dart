import 'package:flutter/material.dart';

class RelatoriosPage extends StatefulWidget {
  const RelatoriosPage({super.key});

  @override
  State<RelatoriosPage> createState() => _RelatoriosPageState();
}

class _RelatoriosPageState extends State<RelatoriosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatórios'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navegar para o relatório de estoque atual
                Navigator.pushNamed(context, '/relatorio-estoque-atual');
              },
              child: Text('Relatório de Estoque Atual'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Navegar para o relatório de movimentações
                Navigator.pushNamed(context, '/relatorio-movimentacoes');
              },
              child: Text('Relatório de Movimentações'),
            ),
            // Adicione mais botões para outros relatórios, se necessário
          ],
        ),
      ),
    );
  }
}

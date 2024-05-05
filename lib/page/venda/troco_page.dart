import 'package:flutter/material.dart';

import '../../model/order.dart';

class TrocoPage extends StatefulWidget {
  final Order order;

  TrocoPage({required this.order});

  @override
  _TrocoPageState createState() => _TrocoPageState();
}

class _TrocoPageState extends State<TrocoPage> {
  TextEditingController _valorRecebidoController = TextEditingController();
  double troco = 0;
  double total = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    total = double.parse(widget.order.total);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Venda Em Dinheiro'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Valor Recebido:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _valorRecebidoController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Digite o valor recebido',
                ),
                onChanged: (value) {
                  setState(() {
                    double valorRecebido = double.tryParse(value) ?? 0;
                    troco = valorRecebido - total;
                  });
                },
              ),
              SizedBox(height: 20),
              Text(
                troco >= 0 ? 'Troco:' : 'Faltam:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'R\$ ${troco >= 0 ? troco.toStringAsFixed(2) : (troco.abs()).toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  color: troco >= 0 ? Colors.green : Colors.red,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        //Get.to(TrocoPage(totalValue: totalValue));
                      },
                      child: Text('CONCLUIR R\$ $total'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _valorRecebidoController.dispose();
    super.dispose();
  }
}

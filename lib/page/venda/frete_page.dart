import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/order.dart';
import '../financ/confirm_order_page.dart';

class FretePage extends StatefulWidget {
  final Order order;

  const FretePage({Key? key, required this.order}) : super(key: key);

  @override
  _FretePageState createState() => _FretePageState();
}

class _FretePageState extends State<FretePage> {
  TextEditingController _valorEntregaController = TextEditingController();
  double _valorEntrega = 0.0;
  double _valorTotal = 0.0;
  double _valorFinal = 0.0;

  @override
  void initState() {
    super.initState();
    _valorTotal = double.parse(widget.order.subtotal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cálculo do Frete'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Digite o valor da entrega:',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _valorEntregaController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Valor da entrega',
                ),
                onChanged: (value) {
                  setState(() {
                    _valorEntrega = double.tryParse(value) ?? 0.0;
                    _updateTotal();
                  });
                },
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _updateTotal();
                    widget.order.valorFrete = _valorEntrega.toString();
                    widget.order.total = _valorFinal.toString();
                    Get.to(ConfirmOrderPage(order: widget.order));
                  },
                  child: Text('Aplicar'),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Total: ${widget.order.total} + Frete:${_valorEntrega.toStringAsFixed(2)} = ${(_valorFinal).toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateTotal() {
    setState(() {
      _valorFinal = double.parse(widget.order.total) + _valorEntrega;
    });
  }
}

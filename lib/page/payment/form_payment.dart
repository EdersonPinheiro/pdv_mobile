import 'package:flutter/material.dart';

class FormPaymentPage extends StatefulWidget {
  @override
  _FormPaymentPageState createState() => _FormPaymentPageState();
}

class _FormPaymentPageState extends State<FormPaymentPage> {
  String _selectedPaymentMethod = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Escolha a Forma de Pagamento'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  _selectPaymentMethod('Pix');
                },
                child: Text('Pix'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _selectPaymentMethod('Cartão');
                },
                child: Text('Cartão'),
              ),
              SizedBox(height: 20),
              Text(
                'Forma de pagamento selecionada: $_selectedPaymentMethod',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectPaymentMethod(String paymentMethod) {
    setState(() {
      _selectedPaymentMethod = paymentMethod;
    });
  }
}

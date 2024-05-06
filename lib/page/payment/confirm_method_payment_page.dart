import 'dart:math';

import 'package:efipay/efipay.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdv_mobile/page/payment/sucess_payment.dart';

import '../credentials.dart';
import 'create_one_step_card_payment.dart';

class ConfirmMethodPaymentPage extends StatefulWidget {
  @override
  _ConfirmMethodPaymentPageState createState() =>
      _ConfirmMethodPaymentPageState();
}

class _ConfirmMethodPaymentPageState extends State<ConfirmMethodPaymentPage> {
  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _monthController = TextEditingController();
  TextEditingController _yearController = TextEditingController();
  TextEditingController _cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cartão de Crédito'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4.0,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detalhes do Cartão',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: _cardNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Número do Cartão',
                      ),
                      onChanged: (value) {
                        setState(() {
                          _cardNumberController.text = value;
                        });
                      },
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 2,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: 'Mês', hintText: 'ex: 06'),
                            onChanged: (value) {
                              setState(() {
                                _monthController.text = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Flexible(
                          flex: 2,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: 'Ano', hintText: 'ex: 2026'),
                            onChanged: (value) {
                              setState(() {
                                _yearController.text = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: 'CVV', hintText: 'ex: 123'),
                            onChanged: (value) {
                              setState(() {
                                _cvvController.text = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 80,
            ),
            ElevatedButton(
              onPressed: () async {
                assinar(_cardNumberController.text, _cvvController.text,
                    _monthController.text, _yearController.text);
              },
              child: Text('Finalizar Compra'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void assinar(String cardNumber, String cvv, String month, String year) async {
    credentials.remove('certificate');
    EfiPay efi = EfiPay(credentials);
    Map<String, Object> card = {
      "brand": "visa",
      "number": cardNumber,
      "cvv": cvv,
      "expiration_month": month,
      "expiration_year": year,
      "reuse": true
    };
    dynamic response = await createOneStepCharge(efi, card, 1);
    print(response);

    // Verificar se o pagamento foi aprovado
    if (response['code'] == 200 && response['data']['status'] == 'approved') {
      // Navegar para outra página
      Get.to(SucessPayment());
    } else {
      // Se o pagamento não foi aprovado, exiba uma mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'O pagamento não foi aprovado. Motivo: ${response['data']['refusal']['reason']}'),
        backgroundColor: Colors.red,
      ));
    }
  }
}

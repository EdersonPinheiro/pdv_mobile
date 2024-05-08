import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:efipay/efipay.dart';
import 'package:flutter/material.dart';
import 'package:pdv_mobile/page/payment/pix/credentials.dart';
import 'package:http/http.dart' as http;

import '../../../constants/constants.dart';

class CreateChargePage extends StatefulWidget {
  const CreateChargePage({Key? key}) : super(key: key);

  @override
  State<CreateChargePage> createState() => _CreateChargePageState();
}

class _CreateChargePageState extends State<CreateChargePage> {
  EfiPay efipay = EfiPay(credentials);
  Uint8List? _byteImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Criar Transação"),
        actions: [
          IconButton(
            icon: Icon(Icons.pix),
            onPressed: () {
              pixCreateImmediateCharge(
                  efipay, "17338eab-cdcc-4997-82ff-009d03631861");
            },
          )
        ],
      ),
      body: _byteImage != null ? _qrCode() : Container(),
    );
  }

  Widget _qrCode() {
    return Image.memory(_byteImage!.buffer.asUint8List());
  }

  Future<dynamic> checkout(String txid) async {
    try {
      final response = await http.post(Uri.parse("$b4a/checkout"), headers: {
        'X-Parse-Application-Id': KeyApplicationId,
        'X-Parse-REST-API-Key': KeyClientKey,
        'X-Parse-Session-Token': userToken
      }, body: {
        "total": 0.01.toString(),
        "txid": txid
      });

      return response.toString();
    } catch (e) {
      print(e);
    }
  }

  Future<void> pixCreateImmediateCharge(EfiPay efipay, String key) async {
    dynamic body = {
      "calendario": {"expiracao": 3600},
      "devedor": {"cpf": "04267484171", "nome": "Gorbadoc Oldbuck"},
      "valor": {"original": "0.01"},
      "chave": key,
      'solicitacaoPagador': "Cobrança dos serviços prestados."
    };

    dynamic response =
        await efipay.call("pixCreateImmediateCharge", body: body).then((value) async{
        await checkout(value['txid']);
      efipay.call("pixGenerateQRCode", params: {"id": value["loc"]["id"]}).then(
          (value) {
        setState(() {
          this._byteImage =
              Base64Decoder().convert(value["imagemQrcode"].split(',').last);
        });
        print(value);
      });
    }).catchError((err) => print((err)));
    print(response);
  }


}

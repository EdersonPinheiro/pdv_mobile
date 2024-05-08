import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:pdv_mobile/controller/webhook_pix_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/order_payment.dart';

class PixPage extends StatefulWidget {
  final OrderPayment order;

  PixPage({required this.order});

  @override
  State<PixPage> createState() => _PixPageState();
}

class _PixPageState extends State<PixPage> {
  String _chavePix = "";
  final WebhookPixController pixController= Get.put(WebhookPixController());

  final LiveQuery liveQuery = LiveQuery();
  QueryBuilder<ParseObject> query =
      QueryBuilder<ParseObject>(ParseObject("Setor"));

  Future<void> startLiveQuery() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final setor = prefs.getString('setor')!;
    Subscription subscription = await liveQuery.client.subscribe(query);

    subscription.on(LiveQueryEvent.update, (value) async {
      if (value['objectId'] == setor) {
        await pixController.handleLiveQueryEventUpdate(
            LiveQueryEvent.update, value);
      }

      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Pagamento'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: Image.memory(
              base64Decode(widget.order.qrCodeImage.substring(22)),
            ),
          ),
          Text('Total: R\$ ${widget.order.total}'),
          const SizedBox(height: 20),
          Container(
            width: 300,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text('${widget.order.copiaecola}'),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              _copyToClipboard('${widget.order.copiaecola}');
              Get.snackbar('Chave Pix copiada!', "",
                  backgroundColor: Colors.white);
            },
            child: Text("Copiar Chave Pix"),
          ),
        ],
      ),
    );
  }
}

void _copyToClipboard(String text) {
  Clipboard.setData(ClipboardData(text: text));
}

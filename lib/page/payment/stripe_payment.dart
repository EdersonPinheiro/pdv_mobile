import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StripePayment extends StatefulWidget {
  const StripePayment({super.key});

  @override
  State<StripePayment> createState() => _StripePaymentState();
}

class _StripePaymentState extends State<StripePayment> {
 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter WebView Example'),
        ),
        body: WebView(
          initialUrl: 'https://buy.stripe.com/test_3csdSS0drfuc0YEeUW',
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
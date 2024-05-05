import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../constants/constants.dart';
import '../model/order_payment.dart';
import '../page/payment/pix_page.dart';

class CartController {
  Future<void> checkout() async {
    try {
      final response = await http.post(
        Uri.parse('$b4a/checkout'),
        headers: {
          'X-Parse-Application-Id': KeyApplicationId,
          'X-Parse-REST-API-Key': KeyClientKey,
          'X-Parse-Session-Token': userToken,
          'Content-Type':
              'application/json',
        },
        body: jsonEncode({"total": 0.01}),
      );

      if (response.statusCode == 200) {
        final order = OrderPayment.toJson(jsonDecode(response.body)["result"]);
        Get.to(PixPage(order: order));
        print(order.qrCodeImage);
      } else {
        print('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

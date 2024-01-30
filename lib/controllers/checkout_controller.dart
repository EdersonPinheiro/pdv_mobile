import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:meu_estoque/page/payment/confirm_payment_page.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import '../model/order.dart';
import '../page/payment/pix_payment.dart';

class CheckoutController {
  Future<void> checkout() async {
    try {
      final response = await Dio().post('$b4a/checkout',
          options: Options(
            headers: {
              'X-Parse-Application-Id': KeyApplicationId,
              'X-Parse-REST-API-Key': KeyClientKey,
              'X-Parse-Session-Token': userToken,
              'Content-Type': 'application/json;charset=UTF-8',
            },
          ),
          data: {"total": 0.01});
      final order = Order.toJson(response.data['result']);
      Get.to(PixPaymentPage(order: order));
      print(order.qrCodeImage);
    } on DioError catch (e) {
      print(e.response);
    }
  }

  Future<void> handleLiveQueryEventUpdate(
      LiveQueryEvent event, ParseObject value) async {
    try {
      // Assume that value.get<String>('premium') gets the premium value
      bool premiumValue = value.get<bool>('premium') ?? false;

      // Update the premium value in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('premium', premiumValue.toString());

      Get.off(ConfirmPaymentPage());
    } catch (e) {
      print(e);
    }
  }
}

import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:pdv_mobile/page/payment/sucess_payment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebhookPixController {
  Future<void> handleLiveQueryEventUpdate(
      LiveQueryEvent event, ParseObject value) async {
    try {
      // Assume that value.get<String>('premium') gets the premium value
      bool premiumValue = value.get<bool>('premium') ?? false;

      // Update the premium value in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('premium', premiumValue.toString());

      Get.off(SucessPayment());
    } catch (e) {
      print(e);
    }
  }
}
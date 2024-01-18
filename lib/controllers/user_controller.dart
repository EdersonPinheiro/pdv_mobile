import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/constants.dart';
import '../model/user.dart';

class UserController {
  final Dio dio = Dio();
  final userL = <User>[].obs;

  Future<void> getUser() async {
    try {
      final response = await Dio().post(
        '$b4a/get-info',
        options: Options(
          headers: {
            'X-Parse-Application-Id': KeyApplicationId,
            'X-Parse-REST-API-Key': KeyClientKey,
            'X-Parse-Session-Token': '${userToken}',
          },
        ),
      );

      if (response.statusCode == 200) {
        userL.value = (response.data["result"] as List)
            .map((data) => User.fromJson(data))
            .toList();
      } else {
        print(response.data.toString());
      }
    } catch (e) {
      print(e);
    }
  }
}

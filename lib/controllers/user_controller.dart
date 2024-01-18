import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/constants.dart';
import '../model/user.dart';

class UserController {
  final Dio dio = Dio();
  final userL = <User>[].obs;

  Future<List<User>> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString("userToken")?? 'null';

    dio.options.headers = {
      'X-Parse-Application-Id': KeyApplicationId,
      'X-Parse-REST-API-Key': KeyClientKey ,
      'X-Parse-Session-Token': userToken,
    };

    try {
      final response = await dio
          .post('https://parseapi.back4app.com/parse/functions/get-info');

      if (response.statusCode == 200) {
        userL.value = (response.data["result"] as List)
            .map((data) => User.fromJson(data))
            .toList();
      }
    } catch (e) {
      print(e);
    }
    return [];
  }
}
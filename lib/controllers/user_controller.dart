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
        List<User> users = (response.data["result"] as List)
            .map((data) => User.fromJson(data))
            .toList();

        if (users.isNotEmpty) {
          // Save the user information in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('userId', users[0].id);
          prefs.setString('userName', users[0].fullname);
          prefs.setString('userEmail', users[0].email);
          prefs.setString('userSetor', users[0].setor);
          prefs.setBool('premium', users[0].premium! ?? false);
        }

        userL.value = users;
      } else {
        print(response.data.toString());
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<User>> getUserOffline() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Recupere os dados do SharedPreferences
      String userId = prefs.getString('userId') ?? '';
      String userName = prefs.getString('userName') ?? '';
      String userEmail = prefs.getString('userEmail') ?? '';
      String userSetor = prefs.getString('userSetor') ?? '';
      bool? premium = prefs.getBool('premium');

      // Crie um objeto User com os dados recuperados
      User offlineUser = User(
          id: userId,
          fullname: userName,
          email: userEmail,
          setor: userSetor,
          premium: premium);

      // Adicione o usuário offline à lista userL
      userL.value = [];
      userL.add(offlineUser);

      // Faça o que quiser com o usuário offline
      print('Usuário offline: $offlineUser');

      // Retorne a lista atualizada
      return userL;
    } catch (e) {
      print(e);
      // Em caso de erro, retorne a lista original
      return userL;
    }
  }
}

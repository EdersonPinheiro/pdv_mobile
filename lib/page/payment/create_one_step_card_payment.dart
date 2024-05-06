import 'package:efipay/efipay.dart';
import '../../constants/constants.dart';
import '../../model/user.dart';
import '../credentials.dart';

void createCharge(bandeira, numero, cvv, mes_exp, ano_exp) async {
  try {
    credentials.remove('certificate');
    EfiPay efi = EfiPay(credentials);
    Map<String, Object> card = {
      "brand": bandeira,
      "number": numero,
      "cvv": cvv,
      "expiration_month": mes_exp,
      "expiration_year": ano_exp
    };
    dynamic response = await createOneStepCharge(efi, card, 3);
    print(response);
  } catch (e) {
    print(e);
  }
}

Future<dynamic> createOneStepCharge(
    EfiPay efi, Map<String, Object> card, int installments) async {
  dynamic paymentToken = await efi.call("paymentToken", body: card);

  List<User> users = await db.getUserDB();

  User? user = users.isNotEmpty ? users[0] : null;

  if (user == null) {
    throw Exception("User not found in the database");
  }

  dynamic body = {
    "items": [
      {"name": "Meu Estoque", "value": 100, "amount": 3}
    ],
    "payment": {
      "credit_card": {
        "installments": installments,
        "payment_token": paymentToken['data']['payment_token'],
        "customer": {
          "name": user.nome,
          "email": user.email,
          "cpf": user.cpfCnpj,
          "birth": user.dataNascimento
        }
      }
    }
  };

  return await efi.call("createOneStepCharge", body: body);
}

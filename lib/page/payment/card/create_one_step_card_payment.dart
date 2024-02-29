import 'package:efipay/efipay.dart';
import '../../../../credentials.dart';

void createCharge() async {
  try {
    credentials.remove('certificate');
    EfiPay efi = EfiPay(credentials);
    Map<String, Object> card = {
      "brand": "visa",
      "number": "4660690020250214",
      "cvv": "118",
      "expiration_month": "03",
      "expiration_year": "2023"
    };
    dynamic response = await createOneStepCharge(efi, card, 6);
    print(response);
  } catch (e) {
    print(e);
  }
}

dynamic createOneStepCharge(EfiPay efi, Map<String, Object> card, int installments) async {
  dynamic paymentToken = await efi.call("paymentToken", body: card);

  dynamic body = {
    "items": [
      {"name": "Meu Estoque", "value": 100, "amount": 2}
    ],
    /*"shippings": [
      {"name": "Default Shipping Cost", "value": 100}
    ],*/
    "payment": {
      "credit_card": {
        "installments": installments,
        "payment_token": paymentToken['data']['payment_token'],
        "billing_address": {
          "street": "Rua Sao Joao",
          "number": 966,
          "neighborhood": "Zona 7",
          "zipcode": "87030200",
          "city": "Maringa",
          "state": "PR"
        },
        "customer": {
          "name": "Eduarda Cruz de Angei",
          "email": "2301cruz@gmail.com",
          "cpf": "04612798279",
          "birth": "2001-01-23",
          "phone_number": "44984263024"
        }
      }
    }
  };

  return await efi.call("createOneStepCharge", body: body);
}

import 'package:efipay/efipay.dart';

import '../../credentials.dart';

EfiPay efipay = EfiPay(credentials);

dynamic pixCreateImmediateCharge(EfiPay efipay, String key) async {
  dynamic body = {
    "calendario": {"expiracao": 3600},
    "devedor": {"cpf": "04267484171", "nome": "Gorbadoc Oldbuck"},
    "valor": {"original": "0.01"},
    "chave": key,
    'solicitacaoPagador': "Cobrança dos serviços prestados."
  };
  return await efipay.call("pixCreateImmediateCharge", body: body);
}

void main() async {
  credentials['headers'] = {
    'x-skip-mtls-checking': 'true',
  };
  dynamic response = await pixConfigWebhook(
      efipay,
      "17338eab-cdcc-4997-82ff-009d03631861",
      "https://api.meuestoquesolutions.cloudns.nz/prod/webhook");
  print(response);
}

dynamic pixConfigWebhook(EfiPay efiPay, String key, String url) async {
  Map<String, dynamic> params = {
    "chave": key,
  };
  dynamic body = {"webhookUrl": url};
  return await efipay.call("pixConfigWebhook", params: params, body: body);
}

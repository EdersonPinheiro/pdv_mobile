import 'package:efipay/efipay.dart';

import '../../../credentials.dart';

void getParticipants() async {
  try {
    credentials.remove('certificate');
    EfiPay efi = EfiPay(credentials);
    dynamic response = await ofListParticipants(efi);
    print(response);
  } catch (e) {
    print(e);
  }
}

dynamic ofListParticipants(EfiPay efi) async {
  return await efi.call('ofListParticipants');
}

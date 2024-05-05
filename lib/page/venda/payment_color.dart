import 'package:flutter/material.dart';

class PaymentInfo {
  final IconData icon;
  final Color color;

  PaymentInfo({required this.icon, required this.color});
}

PaymentInfo getPaymentInfo(String method) {
  switch (method) {
    case 'Dinheiro':
      return PaymentInfo(
          icon: Icons.attach_money_outlined, color: Colors.green);
    case 'Credito':
      return PaymentInfo(icon: Icons.credit_card, color: Colors.yellow);
    case 'Debito':
      return PaymentInfo(icon: Icons.credit_card, color: Colors.black);
    case 'Pix':
      return PaymentInfo(icon: Icons.pix, color: Colors.blue);
    default:
      return PaymentInfo(icon: Icons.attach_money, color: Colors.black);
  }
}

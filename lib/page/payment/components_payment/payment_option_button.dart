import 'package:flutter/material.dart';

class PaymentOptionButton extends StatelessWidget {
  final IconData iconData;
  final String text;
  final VoidCallback onPressed;

  const PaymentOptionButton({
    required this.iconData,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200, // Largura fixa do botão
      height: 50, // Altura fixa do botão
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero, // Remove o preenchimento interno
          minimumSize: Size(200, 50), // Define o tamanho mínimo
          backgroundColor: Colors.grey[200], // Cor de fundo do botão
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData),
            SizedBox(width: 5), // Espaço entre o ícone e o texto
            Text(text, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

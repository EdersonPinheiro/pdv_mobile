import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;

  const Button({
    required this.title,
    required this.icon,
    required this.onPressed,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed, // Usando a função onPressed fornecida como callback
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color ??
              Colors.white, // Usando a cor fornecida ou branco como padrão
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 1,
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.indigo), // Usando o ícone fornecido
            SizedBox(width: 8), // Espaço entre o ícone e o título
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ), // Usando o título fornecido
          ],
        ),
      ),
    );
  }
}
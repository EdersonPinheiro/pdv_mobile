import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdv_mobile/page/payment/confirm_method_payment_page.dart';

import '../../constants/constants.dart';
import '../../model/user.dart';

class ConfirmUserData extends StatefulWidget {
  @override
  _ConfirmUserDataState createState() => _ConfirmUserDataState();
}

class _ConfirmUserDataState extends State<ConfirmUserData> {
  List<User> users = []; // Lista de usuários do banco de dados

  @override
  void initState() {
    super.initState();
    db.getUserDB().then((data) {
      setState(() {
        users = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmar Dados do Usuário'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Exibir os dados dos usuários em campos de texto editáveis
            for (var user in users)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Nome:'),
                  TextFormField(
                    initialValue: user.nome,
                    onChanged: (value) {
                      setState(() {
                        user.nome = value;
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                  Text('Email:'),
                  TextFormField(
                    initialValue: user.email,
                    onChanged: (value) {
                      setState(() {
                        user.email = value;
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                  Text('CPF/CNPJ:'),
                  TextFormField(
                    initialValue: user.cpfCnpj,
                    onChanged: (value) {
                      setState(() {
                        user.cpfCnpj = value;
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                  Text('Data de Nascimento:'),
                  TextFormField(
                    initialValue: user.dataNascimento,
                    onChanged: (value) {
                      setState(() {
                        user.dataNascimento = value;
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            // Botão para prosseguir
            ElevatedButton(
              onPressed: () async {
                for (var user in users) {
                  await db.updateUser(user);
                }
                Get.to(ConfirmMethodPaymentPage());
              },
              child: Text('Confirmar Dados'),
            ),
          ],
        ),
      ),
    );
  }
}

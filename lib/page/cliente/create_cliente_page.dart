import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../constants/constants.dart';
import '../../db/db.dart';
import '../../model/cliente.dart';

class CreateClientePage extends StatefulWidget {
  final Function reload;

  const CreateClientePage({Key? key, required this.reload}) : super(key: key);

  @override
  _CreateClientePageState createState() => _CreateClientePageState();
}

class _CreateClientePageState extends State<CreateClientePage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _cpfCnpjController;
  late TextEditingController _observationController;
  late TextEditingController _addressController;
  final db = DB();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _cpfCnpjController = TextEditingController();
    _observationController = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _cpfCnpjController.dispose();
    _observationController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Cliente'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 12.0),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o Nome do Cliente';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Telefone',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                ),
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: _cpfCnpjController,
                decoration: InputDecoration(
                  labelText: 'CPF/CNPJ',
                ),
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: _observationController,
                decoration: InputDecoration(
                  labelText: 'Observação',
                ),
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Endereço',
                ),
              ),
              SizedBox(height: 24.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final uuid = Uuid();
                          final newCliente = Cliente(
                            id: 'ff',
                            localId: uuid.v4(),
                            nome: _nameController.text,
                            telefone: _phoneController.text ?? '',
                            email: _emailController.text ?? '',
                            cpfCnpj: _cpfCnpjController.text ?? '',
                            observacao: _observationController.text ?? '',
                            endereco: _addressController.text ?? '',
                          );
                          await db.addCliente(newCliente);
                          Get.back();
                          widget.reload();
                          print(newCliente.toString());
                        }
                      },
                      child: Text('SALVAR'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

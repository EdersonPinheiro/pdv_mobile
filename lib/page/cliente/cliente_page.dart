import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../db/db.dart';
import '../../model/cliente.dart';
import '../../model/order.dart';
import 'create_cliente_page.dart';

class ClientePage extends StatefulWidget {

  const ClientePage(
      {Key? key,})
      : super(key: key);

  @override
  _ClientePageState createState() => _ClientePageState();
}

class _ClientePageState extends State<ClientePage> {
  final db = DB();
  final isLoading = false.obs;
  final clientes = <Cliente>[].obs;
  final _idController = TextEditingController();
  final _localIdController = TextEditingController();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfCnpjController = TextEditingController();
  final _observacaoController = TextEditingController();
  final _enderecoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getClientesDB();
  }

  Future<void> getClientesDB() async {
    isLoading.value = true;
    clientes.value = await db.getClientesDB();
    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clientes'),
      ),
      body: Obx(
        () => isLoading.value
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: clientes.length,
                itemBuilder: (context, index) {
                  final cliente = clientes[index];
                  return ListTile(
                    title: Text(cliente.nome),
                    onTap: () {
                      
                    },
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(CreateClientePage(reload: getClientesDB));
        },
        tooltip: 'Adicionar Cliente',
        child: Icon(Icons.add),
      ),
    );
  }
}

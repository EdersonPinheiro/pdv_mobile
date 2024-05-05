import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../db/db.dart';
import '../../model/cliente.dart';
import '../../model/order.dart';
import '../cliente/create_cliente_page.dart';
import 'frete_page.dart';

class ClientePageFrete extends StatefulWidget {
  final Order order;
  final Function(String) updateClienteName;

  const ClientePageFrete(
      {Key? key, required this.order, required this.updateClienteName})
      : super(key: key);

  @override
  _ClientePageFreteState createState() => _ClientePageFreteState();
}

class _ClientePageFreteState extends State<ClientePageFrete> {
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
                      widget.order.clienteNome = cliente.nome;
                      widget.updateClienteName(cliente
                          .nome); // Chame a função para atualizar o estado na ConfirmOrderPage
                      Get.to(FretePage(
                        order: widget.order,
                      ));
                      
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

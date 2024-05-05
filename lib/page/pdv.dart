import 'package:flutter/material.dart';

import 'financ/compras_page.dart';
import 'financ/vendas_page.dart';

class PdvPage extends StatefulWidget {
  @override
  _PdvPageState createState() => _PdvPageState();
}

class _PdvPageState extends State<PdvPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDV'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Vendas'),
            Tab(text: 'Compras'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [VendasPage(), ComprasPage()],
      ),
    );
  }
}

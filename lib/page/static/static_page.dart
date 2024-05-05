import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../constants/constants.dart';
import '../../model/statistics.dart';
import 'bar_chart_sample8.dart';

class StaticPage extends StatefulWidget {
  const StaticPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StaticPage> createState() => _StaticPageState();
}

class _StaticPageState extends State<StaticPage> {
  List<Statistics> statistics = [];
  String selectedDateType = 'Hoje';

  @override
  void initState() {
    super.initState();
    getStatisticsDB(selectedDateType);
  }

  Future<void> getStatisticsDB(String selectedType) async {
    statistics = await db.getStaticsByDate(selectedType);
    setState(() {});
  }

  void _showDateSelectionSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Container(
        margin: EdgeInsets.symmetric(),
        child: Wrap(
          spacing: 20,
          children: [
            _buildDateSelectionButton(context, 'Hoje'),
            _buildDateSelectionButton(context, 'Ontem'),
            _buildDateSelectionButton(context, 'Últimos 7 dias'),
            _buildDateSelectionButton(context, 'Últimos 30 dias'),
            _buildDateSelectionButton(context, 'Últimos 3 meses'),
            _buildDateSelectionButton(context, 'Últimos 6 meses'),
          ],
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _buildDateSelectionButton(BuildContext context, String dateType) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedDateType = dateType;
              });
              getStatisticsDB(selectedDateType);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            child: Container(
              width: constraints.maxWidth / 3 -
                  8, // Ajuste para levar em conta o espaço do Card
              padding: EdgeInsets.all(8),
              child: Center(
                child: Text(
                  dateType,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double calculateTotalRevenue() {
    double totalRevenue = 0;
    for (var stat in statistics) {
      totalRevenue += double.parse(stat.totalRevenue);
    }
    return totalRevenue;
  }

  double calculateAverageTicket() {
    double totalRevenue = calculateTotalRevenue();
    int totalTransactions = statistics.length;

    if (totalTransactions == 0) {
      return 0.0; // Evita divisão por zero
    }

    return totalRevenue / totalTransactions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          selectedDateType,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () {
                            _showDateSelectionSnackBar(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(
                      BarChartSample8(totalRevenue: calculateTotalRevenue()));
                },
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: _buildCard(
                    title: "Faturamento",
                    value: "R\$ ${calculateTotalRevenue().toStringAsFixed(2)}",
                    subtitle:
                        "Pgto. mais utilizado: ${statistics.isNotEmpty ? statistics[0].mostUsedPaymentMethod : ''}",
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: _buildCard(
                  title: "Qtd. de Vendas",
                  value: "${statistics.length}",
                  subtitle: "Canal que mais vendeu: App",
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: _buildCard(
                  title: "Ticket Médio",
                  value: "R\$ ${calculateAverageTicket().toStringAsFixed(2)}",
                  subtitle:
                      "Cliente que mais gastou: ${statistics.isNotEmpty ? statistics[0].topSpendingClient : ''}",
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: _buildCard(
                  title: "Lucro Bruto",
                  value: "R\$ ${calculateTotalRevenue().toStringAsFixed(2)}",
                  subtitle:
                      "Produto mais vendido: ${statistics.isNotEmpty ? statistics[0].bestSellingProduct : ''}",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
      {required String title,
      required String value,
      required String subtitle}) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.trending_up,
              size: 60,
              color: Colors.blue,
            ),
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                Text(subtitle),
              ],
            ),
            trailing: Icon(Icons.chevron_right),
          )
        ],
      ),
    );
  }
}

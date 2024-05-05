import 'package:flutter/material.dart';
import '../db/db.dart';
import '../model/statistics.dart';
import 'bar_graph.dart';

class BarPage extends StatefulWidget {
  const BarPage({Key? key}) : super(key: key);

  @override
  _BarPageState createState() => _BarPageState();
}

class _BarPageState extends State<BarPage> {
  String selectedDuration = "Hoje";
  List<double> weeklySummary = [];
  List<DateTime> weeklyDates =
      []; // Variável para armazenar as datas correspondentes

  final db = DB();

  @override
  void initState() {
    super.initState();
    updateData(selectedDuration);
  }

  Future<void> updateData(String duration) async {
    List<double> data = [];
    List<DateTime> dates =
        []; // Lista temporária para armazenar as datas correspondentes

    try {
      List<Statistics> statistics = await db.getStaticsByDate(duration);
      for (var stat in statistics) {
        data.add(double.parse(stat.totalRevenue));
        // Convertendo o timestamp para DateTime e adicionando à lista de datas
        dates.add(DateTime.fromMillisecondsSinceEpoch(stat.date));
      }
    } catch (e) {
      print('Erro ao buscar estatísticas do banco de dados: $e');
    }

    setState(() {
      weeklySummary = data;
      weeklyDates = dates; // Atualiza a lista de datas
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    // Calcula a altura e largura do gráfico
    double graphHeight = screenSize.height * 0.6; // 60% da altura da tela
    double graphWidth = screenSize.width * 0.90; // 90% da largura da tela

    return Scaffold(
      appBar: AppBar(
        title: Text('Gráfico de Barras'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<String>(
            value: selectedDuration,
            items: [
              DropdownMenuItem<String>(
                value: "Hoje",
                child: Text("Hoje"),
              ),
              DropdownMenuItem<String>(
                value: "Ultimos 6 dias",
                child: Text("Ultimos 6 dias"),
              ),
              DropdownMenuItem<String>(
                value: "Ultimos 3 Meses",
                child: Text("Ultimos 3 Meses"),
              ),
            ],
            onChanged: (value) {
              setState(() {
                selectedDuration = value!;
                updateData(selectedDuration);
              });
            },
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                height: graphHeight,
                width: graphWidth,
                child: BarGraph(
                  weeklySummary: weeklySummary,
                  selectedDuration: selectedDuration,
                  weeklyDates: weeklyDates, // Passa a lista de datas
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

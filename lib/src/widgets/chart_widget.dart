import 'package:app_grafico_compartilhado/src/isar/moeda_model.dart';
import 'package:app_grafico_compartilhado/src/models/cotacao.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:app_grafico_compartilhado/src/isar/cotacao_database.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_database.dart';

class GraficoCotacoes extends StatefulWidget {
  GraficoCotacoes({
    Key? key,
    required this.groupedCotacoes,
  }) : super(key: key);

  final Map<Moeda, List<Cotacao>> groupedCotacoes;

  @override
  State<GraficoCotacoes> createState() => GraficoCotacoesState();
}

class GraficoCotacoesState extends State<GraficoCotacoes> {
  Map<int, Color> indicatorColors = {
    1: Colors.blue,
    2: Colors.yellow,
    3: Colors.greenAccent.shade400,
    4: Colors.purpleAccent.shade400,
    5: Colors.pinkAccent.shade400,
    6: Colors.orangeAccent.shade400,
    7: Colors.tealAccent.shade400,
  };

  @override
  void initState() {
    super.initState();
    fetchDados();
  }

  Future<void> fetchDados() async {
    await MoedaDatabase.initialize();
    await CotacaoDatabase.initialize();

    await MoedaDatabase().fetchMoedas();
    await CotacaoDatabase().fetchCotacoes();
    setState(() {}); // Atualizar a interface após buscar os dados
  }

  List<Cotacao> getCotacoesForMoeda(Moeda moeda) {
    return widget.groupedCotacoes[moeda] ?? [];
  }

  Widget buildMoedaLegend(Moeda moeda, Color color) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.rectangle,
          ),
        ),
        const SizedBox(width: 8),
        Text(moeda.nome, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget buildMoedaLegends() {
    List<Widget> legendWidgets = [];
    widget.groupedCotacoes.forEach((Moeda moeda, List<Cotacao> cotacoes) {
      int moedaID = moeda.id; // Supondo que Moeda tenha um ID único
      Color lineColor = indicatorColors[moedaID] ?? Colors.black;
      legendWidgets.add(buildMoedaLegend(moeda, lineColor));
      legendWidgets.add(const SizedBox(width: 16));
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: legendWidgets,
          ),
        ),
      ],
    );
  }

  Widget bottomTitlesWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.bold,
    );

    int dia = value.toInt() + 1;
    if (dia >= 1 && dia <= 30) {
      String text = dia == 1 ? "Dia $dia" : "$dia";
      return Text(text, style: style);
    } else {
      return const SizedBox();
    }
  }

  Widget leftTitlesWidget(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    return Text("R\$ ${value.toStringAsFixed(2)}", style: style);
  }

  List<LineChartBarData> generateLinesForIndicadores() {
    List<LineChartBarData> lineBarsData = [];

    widget.groupedCotacoes.forEach((Moeda moeda, List<Cotacao> cotacoes) {
      int moedaID = moeda.id; // Supondo que Moeda tenha um ID único
      Color lineColor = indicatorColors[moedaID] ?? Colors.black;

      List<FlSpot> spots = [];
      List<Cotacao> cotacoes = getCotacoesForMoeda(moeda);
      for (int i = 0; i < cotacoes.length; i++) {
        spots.add(FlSpot(i.toDouble(), cotacoes[i].valor));
      }

      LineChartBarData lineChartData = LineChartBarData(
        spots: spots,
        isCurved: false,
        color: lineColor,
        barWidth: 6,
      );
      lineBarsData.add(lineChartData);
    });

    return lineBarsData;
  }

  @override
  Widget build(BuildContext context) {
    double maxY = widget.groupedCotacoes.values
        .expand((cotacoes) => cotacoes.map((e) => e.valor))
        .fold(0, (a, b) => a > b ? a : b);

    List<LineChartBarData> lineBarsData = generateLinesForIndicadores();

    return AspectRatio(
      aspectRatio: 1.2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          children: [
            Expanded(
              child: LineChart(
                LineChartData(
                    lineBarsData: lineBarsData,
                    minX: 0,
                    maxX: 30,
                    minY: 0,
                    maxY: maxY,
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                          return touchedBarSpots.map((barSpot) {
                            final flSpot = barSpot.bar.spots[barSpot.spotIndex];
                            final moeda = widget.groupedCotacoes.keys
                                .elementAt(barSpot.barIndex);
                            final moedaID =
                                moeda.id; // Supondo que Moeda tenha um ID único
                            final lineColor =
                                indicatorColors[moedaID] ?? Colors.black;
                            return LineTooltipItem(
                              "R\$ ${flSpot.y.toStringAsFixed(2)}"
                                  .replaceAll(".", ","),
                              TextStyle(color: lineColor),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1.4,
                              getTitlesWidget: bottomTitlesWidgets),
                        ),
                        leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                getTitlesWidget: leftTitlesWidget,
                                reservedSize: 40)))),
              ),
            ),
            const SizedBox(height: 64),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: buildMoedaLegends(),
            ),
          ],
        ),
      ),
    );
  }
}

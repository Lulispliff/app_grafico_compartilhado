import 'package:app_grafico_compartilhado/src/isar/cotacao_model.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraficoCotacoes extends StatefulWidget {
  GraficoCotacoes({
    Key? key,
    required this.cotacoes,
    required this.groupedCotacaoes,
  }) : super(key: key);

  final List<Cotacoess> cotacoes;
  final Map<Moeda, List<Cotacoess>> groupedCotacaoes;

  @override
  GraficoCotacoesState createState() => GraficoCotacoesState();
}

class GraficoCotacoesState extends State<GraficoCotacoes> {
  Map<int, Color> moedaColors = {
    1: Colors.green,
    2: Colors.red,
  };

  @override
  Widget build(BuildContext context) {
    double maxY = widget.cotacoes.isNotEmpty
        ? widget.cotacoes.map((e) => e.valor).reduce((a, b) => a > b ? a : b)
        : 0;

    List<LineChartBarData> lineBars = generateMoedaLines();

    return AspectRatio(
      aspectRatio: 1.2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          children: [
            Expanded(
              child: LineChart(LineChartData(
                  lineBarsData: lineBars,
                  minX: 0,
                  maxX: 30,
                  minY: 0,
                  maxY: maxY,
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (List<LineBarSpot> touchedBarspots) {
                        return touchedBarspots.map((barSpot) {
                          final flSpot = barSpot.bar.spots[barSpot.spotIndex];
                          final moedaID = barSpot.barIndex;
                          final selectedMoeda =
                              widget.groupedCotacaoes.keys.elementAt(moedaID);
                          final lineColor = moedaColors[selectedMoeda.id] ??
                              Colors.transparent;

                          return LineTooltipItem(
                              "R\$ ${flSpot.y.toStringAsFixed(2)}"
                                  .replaceAll(".", ","),
                              TextStyle(color: lineColor));
                        }).toList();
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1.4,
                          getTitlesWidget: bottomTitles),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: leftTitles,
                          reservedSize: 40),
                    ),
                  ))),
            )
          ],
        ),
      ),
    );
  }

  Widget buildMoedaLegenda(Moeda moeda, Color color) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(color: color, shape: BoxShape.rectangle),
        ),
        const SizedBox(width: 8),
        Text(moeda.nome, style: const TextStyle(fontSize: 16))
      ],
    );
  }

  Widget buildMoedasLengas() {
    List<Widget> legendaWidgets = [];
    widget.groupedCotacaoes.forEach((Moeda moeda, List<Cotacoess> cotacoes) {
      int moedaID = moeda.id;
      Color lineColor = moedaColors[moedaID] ?? Colors.transparent;
      legendaWidgets.add(buildMoedaLegenda(moeda, lineColor));
      legendaWidgets.add(const SizedBox(width: 16));
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: legendaWidgets,
          ),
        )
      ],
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 13, fontWeight: FontWeight.bold);
    int dia = value.toInt() + 1;

    if (dia >= 1 && dia <= 30) {
      String text = dia == 1 ? "Dia $dia" : "$dia";
      return Text(text, style: style);
    } else {
      return const SizedBox();
    }
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    return Text("R\$ ${value.toStringAsFixed(2)}", style: style);
  }

  List<LineChartBarData> generateMoedaLines() {
    List<LineChartBarData> lineBars = [];
    widget.groupedCotacaoes.forEach((Moeda moeda, List<Cotacoess> cotacoes) {
      int moedaID = moeda.id;
      Color lineColor = moedaColors[moedaID] ?? Colors.transparent;

      List<FlSpot> spots = [];
      for (int i = 0; i < cotacoes.length; i++) {
        spots.add(FlSpot(i.toDouble(), cotacoes[i].valor));
      }

      LineChartBarData lineChartData = LineChartBarData(
          spots: spots, isCurved: false, color: lineColor, barWidth: 6);
      lineBars.add(lineChartData);
    });
    return lineBars;
  }
}

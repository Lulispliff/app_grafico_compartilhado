import 'package:app_grafico_compartilhado/src/isar/cotacao_model.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_model.dart';
import 'package:app_grafico_compartilhado/utils/string_utils.dart';
import 'package:app_grafico_compartilhado/utils/colors_app.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CotacoesChart extends StatelessWidget {
  final Duration selectedInterval;
  final List<Cotacoess> cotacoes;
  final Moeda selectedMoeda;

  const CotacoesChart({
    required this.selectedInterval,
    required this.selectedMoeda,
    required this.cotacoes,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Map<double, DateTime> spotDates = _generateSpotDates();
    List<FlSpot> spots = _generateSpots();

    return Scaffold(
      backgroundColor: AppColors.color4,
      appBar: AppBar(
        backgroundColor: AppColors.color1,
        centerTitle: true,
        title: Text("Gráfico - ${selectedMoeda.nome}"),
        titleTextStyle: const TextStyle(
          color: AppColors.color2,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.color2,
          size: 30,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50, 50, 50, 100),
        child: Center(
          child: SizedBox(
            height: 1000,
            width: 2000,
            child: LineChart(
              _buildLineChartData(spots, spotDates),
            ),
          ),
        ),
      ),
    );
  }

  List<FlSpot> _generateSpots() {
    Map<String, int> dayCount = {};
    List<FlSpot> spots = [];

    DateTime firstDate =
        cotacoes.map((c) => c.data).reduce((a, b) => a.isBefore(b) ? a : b);

    for (var cotacao in cotacoes) {
      String dayKey = cotacao.data.toString();
      dayCount[dayKey] = (dayCount[dayKey] ?? 0) + 1;

      double x = cotacao.data.difference(firstDate).inDays.toDouble() +
          (dayCount[dayKey]! - 1) * 0.1;
      double y = cotacao.valor;

      if (x > getMaxX()) {
        x = getMaxX();
      }

      spots.add(FlSpot(x, y));
    }

    spots.sort((a, b) => a.x.compareTo(b.x));
    return spots;
  }

  Map<double, DateTime> _generateSpotDates() {
    Map<double, DateTime> spotDates = {};
    Map<String, int> dayCount = {};

    DateTime firstDate =
        cotacoes.map((c) => c.data).reduce((a, b) => a.isBefore(b) ? a : b);

    for (var cotacao in cotacoes) {
      String dayKey = cotacao.data.toString();
      dayCount[dayKey] = (dayCount[dayKey] ?? 0) + 1;

      double x = cotacao.data.difference(firstDate).inDays.toDouble() +
          (dayCount[dayKey]! - 1) * 0.1;

      spotDates[x] = cotacao.data;
    }

    return spotDates;
  }

  LineChartData _buildLineChartData(
      List<FlSpot> spots, Map<double, DateTime> spotDates) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine: true,
        horizontalInterval: getMaxY(spots) / 5,
        verticalInterval: getMaxX() / 5,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(0.5),
            strokeWidth: 0.5,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(0.5),
            strokeWidth: 0.5,
          );
        },
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: getInterval(),
            reservedSize: 40,
            getTitlesWidget: bottomTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: getMaxY(spots) / 5,
            getTitlesWidget: leftTitles,
            reservedSize: 40,
          ),
        ),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      minX: 0,
      maxX: getMaxX(),
      minY: 0,
      maxY: getMaxY(spots),
      lineBarsData: [
        LineChartBarData(
          isCurved: false,
          color: AppColors.color2,
          barWidth: 3,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
            show: true,
            color: AppColors.color2.withOpacity(0.3),
          ),
          spots: spots,
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => AppColors.color3,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((touchedSpot) {
              DateTime data = spotDates[touchedSpot.x]!;
              String dataFormatada = StringUtils.formatDateSimple(data);
              String valor =
                  touchedSpot.y.toStringAsFixed(4).replaceAll(".", ",");

              return LineTooltipItem(
                'R\$ $valor $dataFormatada',
                const TextStyle(color: Colors.white),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 12, fontWeight: FontWeight.bold);

    DateTime firstDate =
        cotacoes.map((c) => c.data).reduce((a, b) => a.isBefore(b) ? a : b);
    DateTime currentDate = firstDate.add(Duration(days: value.toInt()));

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(StringUtils.formatDiaMes(currentDate), style: style),
    );
  }

  double getInterval() {
    if (selectedInterval == const Duration(days: 7)) {
      return 1;
    } else if (selectedInterval == const Duration(days: 30)) {
      return 3;
    } else if (selectedInterval == const Duration(days: 180)) {
      return 17;
    } else if (selectedInterval == const Duration(days: 365)) {
      return 27;
    } else {
      return 1;
    }
  }

  double getMaxX() {
    DateTime firstDate =
        cotacoes.map((c) => c.data).reduce((a, b) => a.isBefore(b) ? a : b);
    DateTime lastDate =
        cotacoes.map((c) => c.data).reduce((a, b) => a.isAfter(b) ? a : b);

    return lastDate.difference(firstDate).inDays.toDouble();
  }

  double getMaxY(List<FlSpot> spots) {
    if (spots.isEmpty) {
      return 0;
    }

    double maxY = spots
        .map((spot) => spot.y)
        .reduce((max, value) => max > value ? max : value);

    return maxY * 1.1; // Adiciona 10% ao valor máximo para margem
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
    return Text("R\$ ${value.toStringAsFixed(2).replaceAll(".", ",")}",
        style: style);
  }
}

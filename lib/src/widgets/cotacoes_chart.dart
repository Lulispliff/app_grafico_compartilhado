import 'package:app_grafico_compartilhado/src/isar/cotacao_model.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_model.dart';
import 'package:app_grafico_compartilhado/utils/colors_app.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CotacoesChart extends StatelessWidget {
  final List<Cotacoess> cotacoes;
  final Moeda selectedMoeda;

  const CotacoesChart(
      {super.key, required this.cotacoes, required this.selectedMoeda});

  @override
  Widget build(BuildContext context) {
    List<double> valores = cotacoes.map((cotacao) => cotacao.valor).toList();

    return Scaffold(
      backgroundColor: AppColors.color3,
      appBar: AppBar(
        backgroundColor: AppColors.color1,
        centerTitle: true,
        title: const Text("Gráfico de cotações"),
        titleTextStyle: const TextStyle(
          color: AppColors.color2,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50, 50, 50, 100),
        child: Center(
          child: SizedBox(
            height: 1000, // Altura do gráfico
            width: 2000, // Largura do gráfico
            child: LineChart(
              _buildLineChartData(valores),
            ),
          ),
        ),
      ),
    );
  }

  LineChartData _buildLineChartData(List<double> valores) {
    double maxY = valores.isNotEmpty
        ? valores.reduce((max, value) => max > value ? max : value) + 3
        : 0;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(1), // Cor da linha horizontal
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(1), // Cor da linha vertical
            strokeWidth: 1,
          );
        },
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey.withOpacity(0.5)), // Cor da borda
      ),
      titlesData: FlTitlesData(
          bottomTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              interval: 1.4,
            ),
          ),
          leftTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitles,
            reservedSize: 40,
          )),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false))),
      minX: 0,
      maxX: 30,
      minY: 0,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          isCurved: true,
          color: AppColors.color2, // Cor da linha do gráfico
          barWidth: 5,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
            show: true,
            color: AppColors.color2
                .withOpacity(0.3), // Cor da área abaixo da linha
          ),
          spots: List.generate(
            valores.length,
            (index) => FlSpot(index.toDouble(), valores[index]),
          ),
        ),
      ],
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
    return Text("R\$ ${value.toStringAsFixed(2).replaceAll(".", ",")}",
        style: style);
  }
}

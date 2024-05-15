import 'package:app_grafico_compartilhado/src/isar/cotacao_model.dart';
import 'package:app_grafico_compartilhado/utils/colors_app.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CotacoesChart extends StatelessWidget {
  final List<Cotacoess> cotacoes;

  const CotacoesChart({super.key, required this.cotacoes});

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
        padding: const EdgeInsets.fromLTRB(50, 30, 50, 100),
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
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true, interval: 1.4, getTitlesWidget: bottomTitles),
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
      maxY: valores.reduce((max, value) => max > value ? max : value) + 10,
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(
            valores.length,
            (index) => FlSpot(index.toDouble(), valores[index]),
          ),
          isCurved: true,
          color: Colors.blue, // Cor da linha do gráfico
          barWidth: 5,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
            show: true,
            color: Colors.blue.withOpacity(0.3), // Cor da área abaixo da linha
          ),
        ),
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
    const style = TextStyle(fontSize: 10, fontWeight: FontWeight.bold);
    return Text("R\$ ${value.toStringAsFixed(2).replaceAll(".", ",")}",
        style: style);
  }
}

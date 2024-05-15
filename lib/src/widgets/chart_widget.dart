import 'package:app_grafico_compartilhado/src/isar/cotacao_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample2 extends StatelessWidget {
  final List<Cotacoess> cotacoes;

  const LineChartSample2({Key? key, required this.cotacoes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<double> valores = cotacoes.map((cotacao) => cotacao.valor).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Gráfico de Cotações Selecionadas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: LineChart(
                _buildLineChartData(valores),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _buildLineChartData(List<double> valores) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.grey,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.grey,
            strokeWidth: 1,
          );
        },
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey),
      ),
      minX: 0,
      maxX: valores.length.toDouble() - 1,
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
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: Colors.blue.withOpacity(0.3), // Cor da área abaixo da linha
          ),
        ),
      ],
    );
  }
}

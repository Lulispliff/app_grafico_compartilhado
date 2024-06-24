import 'package:app_grafico_compartilhado/src/isar/cotacao_model.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_model.dart';
import 'package:app_grafico_compartilhado/utils/colors_app.dart';
import 'package:app_grafico_compartilhado/utils/string_utils.dart';
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
        padding: const EdgeInsets.fromLTRB(50, 120, 50, 120),
        child: Center(
          child: SizedBox(
            height: 1000, // Altura do gráfico
            width: 2000, // Largura do gráfico
            child: LineChart(
              _createLineChartData(),
            ),
          ),
        ),
      ),
    );
  }

  LineChartData _createLineChartData() {
    List<FlSpot> spots = _generateSpots();

    return LineChartData(
      gridData: const FlGridData(show: true),
      borderData: FlBorderData(show: true),
      titlesData: const FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false))),
      minX: 0,
      maxX: spots.length.toDouble() - 1,
      minY: _findMinValue(),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => AppColors.color3,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((touchedSpot) {
              const textStyle = TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              );

              return LineTooltipItem(
                'Valor: R\$ ${touchedSpot.y.toStringAsFixed(4).replaceAll(".", ",")}\n',
                textStyle,
                children: [
                  TextSpan(
                    text:
                        'Data: ${_formatTooltipDate(touchedSpot.spotIndex)} Horário: ${_formatTooltipHour(touchedSpot.spotIndex)}',
                    style: textStyle.copyWith(fontSize: 14),
                  ),
                ],
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          barWidth: 3,
          isStrokeCapRound: true,
          color: AppColors.color2,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            color: AppColors.color2.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  List<FlSpot> _generateSpots() {
    // Ordenar cotações pela data antes de gerar os pontos
    cotacoes.sort((a, b) => a.data.compareTo(b.data));

    List<FlSpot> spots = [];
    for (int i = 0; i < cotacoes.length; i++) {
      spots.add(FlSpot(i.toDouble(), cotacoes[i].valor));
    }
    return spots;
  }

  double _findMinValue() {
    double minValue = double.infinity;
    for (var cotacao in cotacoes) {
      if (cotacao.valor < minValue) {
        minValue = cotacao.valor;
      }
    }
    return minValue;
  }

  String _formatTooltipDate(int index) {
    final date = cotacoes[index].data;
    return StringUtils.formatDateSimple(date);
  }

  String _formatTooltipHour(int index) {
    final hour = cotacoes[index].hora;
    return StringUtils.formatHoraeMinuto(hour);
  }
}

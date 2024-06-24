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
    double maxMoedaValor = _calculateMaxMoedaValor();
    double minMoedaValor = _calculateMinMoedaValor();
    double pctVariacao = _calculateVariationPercentage();

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
        padding: const EdgeInsets.fromLTRB(90, 120, 90, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: LineChart(_createLineChartData()),
            ),
            legendaGrafico(maxMoedaValor, minMoedaValor, pctVariacao),
          ],
        ),
      ),
    );
  }

  LineChartData _createLineChartData() {
    List<FlSpot> spots = _generateSpots();

    return LineChartData(
      gridData: const FlGridData(show: true),
      borderData: FlBorderData(show: true),
      titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 80,
                  interval: _calculateInterval(),
                  getTitlesWidget: (value, meta) {
                    return bottomTitles(value.toInt());
                  })),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 80,
              getTitlesWidget: (value, meta) {
                return leftTitles(value);
              },
            ),
          ),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false))),
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

  Widget legendaGrafico(
      double maxMoedaValor, double minMoedaValor, double pctVariacao) {
    IconData icon;
    Color iconColor;

    if (pctVariacao >= 0) {
      icon = Icons.trending_up_sharp;
      iconColor = Colors.green;
    } else {
      icon = Icons.trending_down_sharp;
      iconColor = Colors.red;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Valor máximo atingido pela moeda: ${StringUtils.formatValor(maxMoedaValor)}",
          style: const TextStyle(
              color: AppColors.color1,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        Text(
          "Valor mínimo atingido pela moeda: ${StringUtils.formatValor(minMoedaValor)}",
          style: const TextStyle(
              color: AppColors.color1,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Variação percentual: ",
              style: TextStyle(
                  color: AppColors.color1,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            Icon(icon, color: iconColor),
            Text(
              " ${pctVariacao.toStringAsFixed(2)}%",
              style: const TextStyle(
                  color: AppColors.color1,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget bottomTitles(int index) {
    final date = cotacoes[index].data;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        StringUtils.formatMesAno(date),
        style: const TextStyle(
          color: AppColors.color1,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget leftTitles(double value) {
    String formattedValue;
    if (value >= 1000) {
      formattedValue = 'R\$ ${(value / 1000).toStringAsFixed(0)} K';
    } else {
      formattedValue = 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
    }

    return Text(
      formattedValue,
      style: const TextStyle(
        color: AppColors.color1,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
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

  double _calculateMaxMoedaValor() {
    if (cotacoes.isEmpty) return 0;
    return cotacoes.map((c) => c.valor).reduce((a, b) => a > b ? a : b);
  }

  double _calculateMinMoedaValor() {
    if (cotacoes.isEmpty) return 0;
    return cotacoes.map((c) => c.valor).reduce((a, b) => a < b ? a : b);
  }

  double _calculateVariationPercentage() {
    if (cotacoes.isEmpty) return 0.0;

    // Ordenar cotações pela data para garantir a sequência correta
    cotacoes.sort((a, b) => a.data.compareTo(b.data));

    // Pegar o primeiro e o último valor da lista ordenada
    double firstValue = cotacoes.first.valor;
    double lastValue = cotacoes.last.valor;

    // Calcular variação percentual
    double variation = ((lastValue - firstValue) / firstValue) * 100;

    return variation;
  }

  double _calculateInterval() {
    int totalSpots = cotacoes.length;

    if (totalSpots <= 10) {
      return 1;
    } else if (totalSpots <= 20) {
      return 2;
    } else if (totalSpots <= 50) {
      return 5;
    } else {
      return (totalSpots / 10).ceilToDouble();
    }
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

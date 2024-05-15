import 'package:app_grafico_compartilhado/src/widgets/chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:app_grafico_compartilhado/src/isar/cotacao_model.dart';

class GraficoCotacoesScreen extends StatelessWidget {
  final List<Cotacoess> cotacoesSelecionadas;

  const GraficoCotacoesScreen({Key? key, required this.cotacoesSelecionadas})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráfico de Cotações Selecionadas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LineChartSample2(cotacoes: cotacoesSelecionadas),
            ),
          ],
        ),
      ),
    );
  }
}

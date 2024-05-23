// ignore_for_file: use_build_context_synchronously

import 'package:app_grafico_compartilhado/src/isar/cotacao_database.dart';
import 'package:app_grafico_compartilhado/src/isar/cotacao_model.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_database.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_model.dart';
import 'package:app_grafico_compartilhado/src/widgets/navigator_butons.dart';
import 'package:app_grafico_compartilhado/src/widgets/cotacoes_chart.dart';
import 'package:app_grafico_compartilhado/utils/colors_app.dart';
import 'package:app_grafico_compartilhado/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GraficoScreen extends StatefulWidget {
  const GraficoScreen({
    super.key,
  });

  @override
  GraficoScreenState createState() => GraficoScreenState();
}

class GraficoScreenState extends State<GraficoScreen> {
  Moeda? selectedMoeda;
  Duration selectedInterval = const Duration(days: 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color3,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.color1,
        centerTitle: true,
        title: const Text("Gráfico de cotações"),
        titleTextStyle: const TextStyle(
            color: AppColors.color2, fontSize: 30, fontWeight: FontWeight.bold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildPrimaryList(),
            ),
            NavigatorButtons.buildNavigatorButtons(context),
          ],
        ),
      ),
      floatingActionButton: _buildGerarGraficoButton(),
    );
  }

  Widget _buildPrimaryList() {
    final moedaDatabase = context.watch<MoedaDatabase>();
    List<Moeda> currentMoeda = moedaDatabase.currentMoeda;

    return currentMoeda.isEmpty
        ? const Center(
            child: Text(
                "Você não tem cotações registradas para gerar o gráfico.",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          )
        : ListView.builder(
            itemCount: currentMoeda.length,
            itemBuilder: (context, index) {
              final moeda = currentMoeda[index];

              return Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.color2, width: 1.5),
                  ),
                ),
                child: ExpansionTile(
                  title: Text(
                    "Moeda: ${StringUtils.capitalize(moeda.nome)}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  trailing: const Icon(Icons.arrow_drop_down),
                  children: [_buildSecondaryList(moeda)],
                ),
              );
            },
          );
  }

  Widget _buildSecondaryList(Moeda moeda) {
    final cotacaoDatabase = context.watch<CotacaoDatabase>();

    return FutureBuilder<List<Cotacoess>>(
      future: cotacaoDatabase.fetchCotacoesByMoeda(moeda.nome),
      builder: (context, snapshot) {
        final cotacoes = snapshot.data ?? [];

        return cotacoes.isEmpty
            ? const Center(
                child: Text(
                  "Essa moeda ainda não possui nenhuma cotação registrada",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cotacoes.length,
                itemBuilder: (context, index) {
                  final cotacao = cotacoes[index];

                  return ListTile(
                    title: Text(
                      "Valor: ${StringUtils.formatValorBRL(cotacao.valor)} - Data de registro: ${StringUtils.formatDateSimple(cotacao.data)} - Horário de registro: ${StringUtils.formatHoraeMinuto(cotacao.hora)}",
                      style: const TextStyle(fontSize: 17),
                    ),
                  );
                },
              );
      },
    );
  }

  Widget _buildGerarGraficoButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 50,
          width: 50,
          child: FloatingActionButton(
            onPressed: _selectInfosChartScreen,
            tooltip: "Gerar gráfico",
            backgroundColor: AppColors.color2,
            shape: const CircleBorder(),
            child: const Icon(Icons.bar_chart_sharp, color: AppColors.color3),
          ),
        )
      ],
    );
  }

  Widget _buildTimeChartButtons(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      _buildTimeButton("1 D", "1 Dia", const Duration(days: 1)),
      const SizedBox(width: 5),
      _buildTimeButton("1 S", "1 Semana", const Duration(days: 7)),
      const SizedBox(width: 5),
      _buildTimeButton("1 M", "1 Mês", const Duration(days: 30)),
      const SizedBox(width: 5),
      _buildTimeButton("6 M", "6 Meses", const Duration(days: 180)),
      const SizedBox(width: 5),
      _buildTimeButton("1 A", "1 Ano", const Duration(days: 365)),
    ]);
  }

  Widget _buildTimeButton(
      String label, String tooltipMessage, Duration duration) {
    return Tooltip(
      message: tooltipMessage,
      child: TextButton(
        onPressed: () {
          if (selectedInterval != duration) {
            setState(() {
              selectedInterval = duration;
            });
          }
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (selectedInterval == duration) {
                return AppColors.color1; // Cor quando selecionado
              }
              return AppColors.color2; // Cor padrão
            },
          ),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  void _selectInfosChartScreen() {
    final moedaDataBase = context.read<MoedaDatabase>();
    showDialog(
      context: context,
      builder: (builder) {
        return AlertDialog(
          backgroundColor: AppColors.color3,
          title: const Center(
            child: Text(
              "Dados do gráfico",
              style: TextStyle(
                  fontSize: 30,
                  color: AppColors.color2,
                  fontWeight: FontWeight.bold),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<Moeda>(
                decoration: const InputDecoration(
                  focusColor: Colors.transparent,
                  labelText: "Selecione uma moeda",
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                items: moedaDataBase.currentMoeda
                    .map((moeda) => DropdownMenuItem<Moeda>(
                          value: moeda,
                          child: Text(StringUtils.capitalize(moeda.nome)),
                        ))
                    .toList(),
                onChanged: (Moeda? value) {
                  setState(() {
                    selectedMoeda = value;
                  });
                },
              ),
              const SizedBox(height: 15),
              const Text("Periodo de tempo",
                  style: TextStyle(
                      fontSize: 30,
                      color: AppColors.color2,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              _buildTimeChartButtons(context)
            ],
          ),
          actions: [
            TextButton(
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(AppColors.color2)),
              onPressed: Navigator.of(context).pop,
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(AppColors.color2)),
              onPressed: _generateChart,
              child: const Text(
                "Gerar Gráfico",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCotacoesChart(List<Cotacoess> cotacoes) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CotacoesChart(
          cotacoes: cotacoes,
          selectedMoeda: selectedMoeda!,
        ),
      ),
    );
  }

  Future<void> _generateChart() async {
    if (selectedMoeda == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text("Você deve selecionar uma moeda para gerar o gráfico!")));
    }

    final cotacaoDatabase = context.read<CotacaoDatabase>();
    List<Cotacoess> cotacoes = await cotacaoDatabase.fetchCotacoesByInterval(
        selectedMoeda!.nome, selectedInterval);

    Navigator.of(context).pop();

    if (cotacoes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "Nenhuma cotação foi encontrada no período de tempo selecionado!")));
    } else {
      _showCotacoesChart(cotacoes);
    }
  }
}

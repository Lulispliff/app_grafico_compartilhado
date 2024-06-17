// ignore_for_file: use_build_context_synchronously
import 'package:app_grafico_compartilhado/src/widgets/navigator_butons.dart';
import 'package:app_grafico_compartilhado/src/widgets/cotacoes_chart.dart';
import 'package:app_grafico_compartilhado/src/isar/cotacao_database.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_database.dart';
import 'package:app_grafico_compartilhado/src/isar/cotacao_model.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_model.dart';
import 'package:app_grafico_compartilhado/utils/error_messages.dart';
import 'package:app_grafico_compartilhado/utils/string_utils.dart';
import 'package:app_grafico_compartilhado/utils/colors_app.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class GraficoScreen extends StatefulWidget {
  const GraficoScreen({
    super.key,
  });

  @override
  GraficoScreenState createState() => GraficoScreenState();
}

class GraficoScreenState extends State<GraficoScreen> {
  Duration selectedInterval = const Duration(days: 1);
  Moeda? selectedMoeda;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color4,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.color1,
        centerTitle: true,
        title: const Text("Gráfico"),
        titleTextStyle: const TextStyle(
            color: AppColors.color2, fontSize: 30, fontWeight: FontWeight.bold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildPrimaryList(),
            )
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
            child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FontAwesomeIcons.chartColumn, color: AppColors.color1),
              SizedBox(width: 10),
              Text("Você não possui cotações registradas para gerar o gráfico",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            ],
          ))
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
                    StringUtils.capitalize(moeda.nome),
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
        cotacoes.sort((a, b) {
          int comparacaoData = a.data.compareTo(b.data);
          if (comparacaoData != 0) {
            return comparacaoData;
          } else {
            return a.hora.compareTo(b.hora);
          }
        });

        return cotacoes.isEmpty
            ? const Center(
                child: Text(
                  "Essa moeda ainda não possui nenhuma cotação registrada",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              )
            : SizedBox(
                height: 300,
                child: SingleChildScrollView(
                  child: Column(
                    children: cotacoes.map((cotacao) {
                      return ListTile(
                        title: Text(
                          "Valor: R\$ ${StringUtils.formatValor(cotacao.valor)} - Data de registro: ${StringUtils.formatDateSimple(cotacao.data)} - Horário de registro: ${StringUtils.formatHoraeMinuto(cotacao.hora)}",
                          style: const TextStyle(fontSize: 17),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
      },
    );
  }

  Widget _buildGerarGraficoButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 2),
              child: NavigatorButtons.buildNavigatorButtons(context),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: FloatingActionButton(
                onPressed: _selectInfosGrafico,
                tooltip: "Gerar gráfico",
                backgroundColor: AppColors.color2,
                shape: const CircleBorder(),
                child: const Icon(FontAwesomeIcons.chartColumn,
                    color: AppColors.color4),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _selectInfosGrafico() {
    final moedaDataBase = context.read<MoedaDatabase>();

    List<DropdownMenuItem<Duration>> buildDropdownMenuItems(
        List<Duration> durations) {
      return durations.map((Duration duration) {
        return DropdownMenuItem<Duration>(
          value: duration,
          child: Text(
            _formatDuration(duration),
          ),
        );
      }).toList();
    }

    showDialog(
      context: context,
      builder: (builder) {
        return AlertDialog(
          backgroundColor: AppColors.color4,
          title: const Center(
            child: Text(
              "Dados do gráfico",
              style: TextStyle(
                fontSize: 30,
                color: AppColors.color2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<Moeda>(
                dropdownColor: AppColors.color5,
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
              DropdownButtonFormField<Duration>(
                dropdownColor: AppColors.color5,
                decoration: const InputDecoration(
                  focusColor: Colors.transparent,
                  labelText: "Selecione o período de tempo",
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                value: selectedInterval,
                items: buildDropdownMenuItems([
                  const Duration(days: 1),
                  const Duration(days: 7),
                  const Duration(days: 30),
                  const Duration(days: 180),
                  const Duration(days: 365),
                ]),
                onChanged: (Duration? value) {
                  if (value != null) {
                    setState(() {
                      selectedInterval = value;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(AppColors.color2),
              ),
              onPressed: Navigator.of(context).pop,
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(AppColors.color2),
              ),
              onPressed: () {
                if (selectedMoeda == null) {
                  ErrorMessages.graficoMoedaErrorMessage(context);
                }
                _generateChart();
                Navigator.of(context).pop();
              },
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

  String _formatDuration(Duration duration) {
    if (duration.inDays == 1) {
      return "1 Dia";
    } else if (duration.inDays == 7) {
      return "1 Semana";
    } else if (duration.inDays == 10) {
      return "10 Dias";
    } else if (duration.inDays == 30) {
      return "1 Mês";
    } else if (duration.inDays == 180) {
      return "6 Meses";
    } else if (duration.inDays == 365) {
      return "1 Ano";
    } else {
      return "";
    }
  }

  void _showCotacoesChart(List<Cotacoess> cotacoes) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CotacoesChart(
          cotacoes: cotacoes,
          selectedMoeda: selectedMoeda!,
          selectedInterval: selectedInterval,
        ),
      ),
    );
  }

  Future<void> _generateChart() async {
    final cotacaoDatabase = context.read<CotacaoDatabase>();

    List<Cotacoess> cotacoes = await cotacaoDatabase.fetchCotacoesByInterval(
        selectedMoeda!.nome, selectedInterval);

    if (cotacoes.isEmpty) {
      ErrorMessages.graficoCotacaoErrorMessage(context);
    } else {
      _showCotacoesChart(cotacoes);
    }
  }
}

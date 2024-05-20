import 'package:app_grafico_compartilhado/src/isar/cotacao_database.dart';
import 'package:app_grafico_compartilhado/src/isar/cotacao_model.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_database.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_model.dart';
import 'package:app_grafico_compartilhado/src/screens/cotacao_screen.dart';
import 'package:app_grafico_compartilhado/src/screens/moeda_screen.dart';
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
  Duration selectedInterval = const Duration(days: 1); // Default interval

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
            const SizedBox(height: 16),
            _buildNavigatorButtons(),
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
                    "Moeda: ${moeda.nome}",
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
    List<Cotacoess> cotacoesDaMoeda = moeda.cotacoes;

    return cotacoesDaMoeda.isEmpty
        ? const Center(
            child: Text(
              "Essa moeda ainda não possui uma cotação registrada",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cotacoesDaMoeda.length,
            itemBuilder: (context, index) {
              final cotacao = cotacoesDaMoeda[index];

              return ListTile(
                title: Text(
                  "Valor: ${valorFormat().format(cotacao.valor)} - Data de registro: ${dateFormat().format(cotacao.data)} - Horario de registro: ${horaFormat().format(cotacao.hora)}",
                  style: const TextStyle(fontSize: 17),
                ),
              );
            },
          );
  }

  Widget _buildGerarGraficoButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 100,
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

  Widget _buildNavigatorButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: goToGrafico,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(AppColors.color2),
          ),
          child: const Text(
            "Gráfico",
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: goToCotacao,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(AppColors.color2),
          ),
          child: const Text(
            "Cotação",
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: goToMoeda,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(AppColors.color2),
          ),
          child: const Text(
            "Moedas",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeChartButtons(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      _buildTimeButton("1 H", const Duration(hours: 1)),
      const SizedBox(width: 10),
      _buildTimeButton("1 D", const Duration(days: 1)),
      const SizedBox(width: 10),
      _buildTimeButton("1 S", const Duration(days: 7)),
      const SizedBox(width: 10),
      _buildTimeButton("1 M", const Duration(days: 30)),
      const SizedBox(width: 10),
      _buildTimeButton("6 M", const Duration(days: 180)),
      const SizedBox(width: 10),
      _buildTimeButton("1 A", const Duration(days: 365)),
    ]);
  }

  Widget _buildTimeButton(String label, Duration duration) {
    return TextButton(
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
    );
  }

  void _selectInfosChartScreen() {
    final moedaDataBase = context.read<MoedaDatabase>();

    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            backgroundColor: AppColors.color3,
            title: const Text(
              "Selecione uma moeda registrada",
              style: TextStyle(
                  fontSize: 30,
                  color: AppColors.color2,
                  fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<Moeda>(
                  decoration: const InputDecoration(
                    focusColor: Colors.transparent,
                    labelText: "Moedas registradas",
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                  items: moedaDataBase.currentMoeda
                      .map((moeda) => DropdownMenuItem<Moeda>(
                            value: moeda,
                            child: Text(moeda.nome),
                          ))
                      .toList(),
                  onChanged: (Moeda? value) {
                    setState(() {
                      selectedMoeda = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                const Text("Selecione um periodo de tempo",
                    style: TextStyle(
                        fontSize: 30,
                        color: AppColors.color2,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _buildTimeChartButtons(context)
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (selectedMoeda == null) {
                    _erroGraficoDialog(
                        "Selecione uma moeda para gerar o gráfico.");
                    return;
                  }
                  final cotacaoDataBase = context.read<CotacaoDatabase>();
                  List<Cotacoess> cotacoes =
                      await cotacaoDataBase.fetchCotacoesByInterval(
                          selectedMoeda!.nome, selectedInterval);

                  Navigator.of(context).pop();

                  if (cotacoes.isEmpty) {
                    _erroGraficoDialog(
                        "Nenhuma cotação encontrada para o intervalo selecionado.");
                  } else {
                    _showCotacoesChart(cotacoes);
                  }
                },
                child: const Text(
                  "Gerar Gráfico",
                  style: TextStyle(
                      fontSize: 20,
                      color: AppColors.color2,
                      fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Voltar",
                  style: TextStyle(
                      fontSize: 20,
                      color: AppColors.color2,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        });
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

  void _erroGraficoDialog(String mensagem) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            backgroundColor: AppColors.color3,
            title: const Text(
              "Erro ao gerar gráfico",
              style: TextStyle(
                  fontSize: 30,
                  color: AppColors.color2,
                  fontWeight: FontWeight.bold),
            ),
            content: Text(mensagem,
                style: const TextStyle(
                    fontSize: 20,
                    color: AppColors.color2,
                    fontWeight: FontWeight.bold)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Voltar",
                  style: TextStyle(
                      fontSize: 20,
                      color: AppColors.color2,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        });
  }

  void goToGrafico() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const GraficoScreen()));
  }

  void goToCotacao() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const CotacaoScreen()));
  }

  void goToMoeda() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MoedaScreen()));
  }
}

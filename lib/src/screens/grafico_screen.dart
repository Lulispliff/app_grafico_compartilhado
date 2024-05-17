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
                    "Moeda: ${capitalize(moeda.nome)}",
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
                  "Valor: ${valorFormat().format(cotacao.valor)} - Data de registro: ${dateFormat().format(cotacao.data)}",
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
          height: 110,
          width: 50,
          child: FloatingActionButton(
            onPressed: () {
              final cotacaoDataBase = context.read<CotacaoDatabase>();
              List<Cotacoess> selectedCotacoes =
                  cotacaoDataBase.currentCotacao.where((cotacao) {
                return cotacao.isSelected;
              }).toList();

              _selectInfosChartScreen();
            },
            tooltip: "Gerar gráfico",
            backgroundColor: AppColors.color2,
            shape: const CircleBorder(),
            child: const Icon(Icons.bar_chart_sharp, color: AppColors.color3),
          ),
        ),
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
            backgroundColor: MaterialStateProperty.all(AppColors.color2),
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
            backgroundColor: MaterialStateProperty.all(AppColors.color2),
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
            backgroundColor: MaterialStateProperty.all(AppColors.color2),
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
      TextButton(
        onPressed: () {},
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AppColors.color2)),
        child: const Text("1 H", style: TextStyle(color: Colors.white)),
      ),
      const SizedBox(width: 10),
      TextButton(
        onPressed: () {},
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AppColors.color2)),
        child: const Text("1 D", style: TextStyle(color: Colors.white)),
      ),
      const SizedBox(width: 10),
      TextButton(
        onPressed: () {},
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AppColors.color2)),
        child: const Text("1 S", style: TextStyle(color: Colors.white)),
      ),
      const SizedBox(width: 10),
      TextButton(
        onPressed: () {},
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AppColors.color2)),
        child: const Text("1 M", style: TextStyle(color: Colors.white)),
      ),
      const SizedBox(width: 10),
      TextButton(
        onPressed: () {},
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AppColors.color2)),
        child: const Text("6 M", style: TextStyle(color: Colors.white)),
      ),
      const SizedBox(width: 10),
      TextButton(
        onPressed: () {},
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AppColors.color2)),
        child: const Text("1 A", style: TextStyle(color: Colors.white)),
      )
    ]);
  }

  void _selectInfosChartScreen() {
    final moedaDataBase = context.read<MoedaDatabase>();
    Moeda? selectedMoeda;

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
                            child: Text(capitalize(moeda.nome)),
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
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(AppColors.color2)),
                child: const Text("Cancelar",
                    style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(AppColors.color2)),
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              )
            ],
          );
        });
  }

  void _showCotacoesChart(List<Cotacoess> cotacoesSelecionadas) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CotacoesChart(cotacoes: cotacoesSelecionadas)));
  }

  void _erroGraficoDialog() {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: const Text("Selecione alguma cotação para gerar o gráfico",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: AppColors.color2)),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(AppColors.color2)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "OK",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  void goToCotacao() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const CotacaoScreen()));
  }

  void goToMoeda() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MoedaScreen()));
  }

  void goToGrafico() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const GraficoScreen()));
  }
}

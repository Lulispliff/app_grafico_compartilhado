import 'package:app_grafico_compartilhado/src/isar/cotacao_database.dart';
import 'package:app_grafico_compartilhado/src/isar/cotacao_model.dart';
import 'package:app_grafico_compartilhado/src/screens/cotacao_screen.dart';
import 'package:app_grafico_compartilhado/src/screens/moeda_screen.dart';
import 'package:app_grafico_compartilhado/utils/colors_app.dart';
import 'package:app_grafico_compartilhado/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GraficoScreen extends StatefulWidget {
  const GraficoScreen({super.key});

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
              child: _buildCotacoesList(),
            ),
            const SizedBox(height: 16),
            _buildNavigatorButtons(),
          ],
        ),
      ),
      floatingActionButton: _buildGerarGraficoButton(),
    );
  }

  Widget _buildCotacoesList() {
    final cotacaoDataBase = context.watch<CotacaoDatabase>();
    List<Cotacoess> currentCotacao = cotacaoDataBase.currentCotacao;

    return currentCotacao.isEmpty
        ? const Center(
            child: Text(
              "Você não tem cotações registradas para criar um gráfico.",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          )
        : ListView.builder(
            itemCount: currentCotacao.length,
            itemBuilder: (context, index) {
              final cotacao = currentCotacao[index];

              return Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.color2,
                      width: 1.5,
                    ),
                  ),
                ),
                child: ListTile(
                  title: Text(
                    "Moeda: ${cotacao.nome} - Valor: ${valorFormat().format(cotacao.valor)} - Data de registro: ${dateFormat().format(cotacao.dataHora)}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  trailing: Checkbox(
                    activeColor: AppColors.color2,
                    value: currentCotacao[index].isSelected,
                    onChanged: (value) {
                      setState(() {
                        currentCotacao[index].isSelected = value ?? false;
                      });
                    },
                  ),
                ),
              );
            },
          );
  }

  Widget _buildGerarGraficoButton() {
    return SizedBox(
      height: 50,
      width: 50,
      child: FloatingActionButton(
        onPressed: () {},
        tooltip: "Gerar gráfico",
        backgroundColor: AppColors.color2,
        shape: const CircleBorder(),
        child: const Icon(Icons.bar_chart_sharp, color: Colors.white),
      ),
    );
  }

  Widget _buildNavigatorButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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

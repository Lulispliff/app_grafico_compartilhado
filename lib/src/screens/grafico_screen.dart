
import 'package:app_grafico_compartilhado/src/models/cotacao.dart';
import 'package:app_grafico_compartilhado/src/screens/cotacao_screen.dart';
import 'package:app_grafico_compartilhado/src/screens/moeda_screen.dart';
import 'package:app_grafico_compartilhado/utils/colors_app.dart';
import 'package:flutter/material.dart';

class GraficoScreen extends StatefulWidget {
  const GraficoScreen({super.key});

  @override
  GraficoScreenState createState() => GraficoScreenState();
}

class GraficoScreenState extends State<GraficoScreen> {
  List<Cotacao> cotacoes = [];

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
    return cotacoes.isEmpty
        ? const Center(
            child: Text(
              "Você não tem cotações registradas para criar um gráfico",
              style: TextStyle(fontSize: 22),
            ),
          )
        : ListView.builder(
            itemCount: cotacoes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(cotacoes[index].indicador.nome),
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

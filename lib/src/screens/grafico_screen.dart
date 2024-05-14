import 'package:app_grafico_compartilhado/src/models/cotacao.dart';
import 'package:app_grafico_compartilhado/src/screens/cotacao_screen.dart';
import 'package:app_grafico_compartilhado/src/screens/moeda_screen.dart';
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text("Gráfico de cotações"),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 30),
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
        backgroundColor: Colors.blue,
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
          onPressed: goToMoeda,
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue)),
          child: const Text("Moeda", style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: goToCotacao,
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue)),
          child: const Text("Cotação", style: TextStyle(color: Colors.white)),
        )
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
}

import 'package:app_grafico_compartilhado/src/screens/cotacao_screen.dart';
import 'package:app_grafico_compartilhado/src/screens/grafico_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_grafico_compartilhado/src/models/indicador.dart';

class IndicadorScreen extends StatefulWidget {
  const IndicadorScreen({super.key});

  @override
  IndicadorScreenState createState() => IndicadorScreenState();
}

class IndicadorScreenState extends State<IndicadorScreen> {
  List<Indicador> indicadores = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text("Cadastro de indicadores"),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 30),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildIndicadoresList(),
            ),
            const SizedBox(height: 16),
            _buildNavigatorButtons(),
          ],
        ),
      ),
      floatingActionButton: _buildAddIndicadorButton(),
    );
  }

  Widget _buildIndicadoresList() {
    return indicadores.isEmpty
        ? const Center(
            child: Text(
              "Sua lista de indicadores está vazia",
              style: TextStyle(fontSize: 22),
            ),
          )
        : ListView.builder(
            itemCount: indicadores.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(indicadores[index].nome),
                // Adicione mais informações do indicador, se necessário
              );
            },
          );
  }

  Widget _buildNavigatorButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: goToGrafico,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
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
            backgroundColor: MaterialStateProperty.all(Colors.blue),
          ),
          child: const Text(
            "Cotações",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildAddIndicadorButton() {
    return SizedBox(
      height: 50,
      width: 50,
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void goToGrafico() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const GraficoScreen()));
  }

  void goToCotacao() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const CotacaoScreen()));
  }
}

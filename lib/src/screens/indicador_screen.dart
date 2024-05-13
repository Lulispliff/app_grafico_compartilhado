import 'package:app_grafico_compartilhado/src/isar/moeda_database.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_model.dart';
import 'package:app_grafico_compartilhado/src/screens/cotacao_screen.dart';
import 'package:app_grafico_compartilhado/src/screens/grafico_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IndicadorScreen extends StatefulWidget {
  const IndicadorScreen({super.key});

  @override
  IndicadorScreenState createState() => IndicadorScreenState();
}

class IndicadorScreenState extends State<IndicadorScreen> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
    final moedaDatabase = context.watch<MoedaDatabase>();
    List<Moeda> currentMoeda = moedaDatabase.currentMoeda;
    return currentMoeda.isEmpty
        ? const Center(
            child: Text(
              "Sua lista de indicadores está vazia",
              style: TextStyle(fontSize: 22),
            ),
          )
        : ListView.builder(
            itemCount: currentMoeda.length,
            itemBuilder: (context, index) {
              final moeda = currentMoeda[index];
              return ListTile(
                title: Text(moeda.nome),
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
    return FloatingActionButton(
      onPressed: createMoeda,
      backgroundColor: Colors.blue,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, color: Colors.white),
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

  void createMoeda() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Adicionar Indicador"),
          content: TextField(
            controller: textController,
            decoration:
                const InputDecoration(hintText: "Digite o nome do indicador"),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () {
                context.read<MoedaDatabase>().addMoeda(textController.text);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void readMoeda() {
    context.watch<MoedaDatabase>().fetchMoedas();
  }
}

import 'package:app_grafico_compartilhado/src/isar/moeda_database.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_model.dart';
import 'package:app_grafico_compartilhado/src/models/cotacao.dart';
import 'package:app_grafico_compartilhado/src/screens/grafico_screen.dart';
import 'package:app_grafico_compartilhado/src/screens/moeda_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CotacaoScreen extends StatefulWidget {
  const CotacaoScreen({super.key});

  @override
  CotacaoScreenState createState() => CotacaoScreenState();
}

class CotacaoScreenState extends State<CotacaoScreen> {
  List<Cotacao> cotacoes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text("Cadastro de cotações"),
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
      floatingActionButton: _buildAddCotacaoButton(),
    );
  }

  Widget _buildCotacoesList() {
    final moedaDatabase = context.watch<MoedaDatabase>();
    List<Moeda> currentCotacao = moedaDatabase.currentCotacao;

    return currentCotacao.isEmpty
        ? const Center(
            child: Text("Sua lista de cotações está vazia",
                style: TextStyle(fontSize: 22)),
          )
        : ListView.builder(
            itemCount: currentCotacao.length,
            itemBuilder: (context, index) {
              final cotacao = currentCotacao[index];

              return ListTile(
                title: Text(
                  "Moeda: ${cotacao.nome} - Valor: ${cotacao.valor} - Data de registro: ${cotacao.dataHora}",
                  style: const TextStyle(fontSize: 18),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.delete),
                    )
                  ],
                ),
              );
            },
          );
  }

  void addCotacaoDialog() {
    final moedaDatabase = context.read<MoedaDatabase>();
    List<Moeda> currentMoeda = moedaDatabase.currentMoeda;

    Moeda? selectedMoeda;
    DateTime? dataHora;
    double? valor;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Adicionar cotação",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blue)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<Moeda>(
                  focusColor: Colors.transparent,
                  decoration: const InputDecoration(
                      labelText: "Selecione uma moeda",
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey))),
                  onChanged: (Moeda? moeda) {
                    selectedMoeda = moeda;
                  },
                  items: currentMoeda.map((Moeda moeda) {
                    return DropdownMenuItem<Moeda>(
                      value: moeda,
                      child: Text(moeda.nome),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                TextField(
                  cursorColor: Colors.grey,
                  decoration: const InputDecoration(
                    prefixText: "R\$ ",
                    prefixStyle: TextStyle(color: Colors.grey, fontSize: 18),
                    labelText: "Valor da moeda",
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                  onChanged: (value) {
                    valor = double.tryParse(value);
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  cursorColor: Colors.grey,
                  decoration: const InputDecoration(
                      hintText: "dia/mes/ano",
                      hintStyle: TextStyle(color: Colors.grey),
                      labelText: "Data de registro",
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey))),
                  onChanged: (value) {
                    final dateFormat = DateFormat('dd/MM/yyyy');
                    dataHora = dateFormat.parse(value);
                  },
                ),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue)),
                    child: const Text("Cancelar",
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue)),
                    child: const Text("Salvar",
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      moedaDatabase.addCotacao(
                          selectedMoeda!.nome, dataHora!, valor!);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            ],
          );
        });
  }

  Widget _buildAddCotacaoButton() {
    return SizedBox(
      height: 50,
      width: 50,
      child: FloatingActionButton(
        onPressed: () {
          addCotacaoDialog();
        },
        tooltip: "Adicionar cotação",
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
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
          child: const Text(
            "Moeda",
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: goToGrafico,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
          ),
          child: const Text(
            "Gráfico",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }

  void goToGrafico() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const GraficoScreen()));
  }

  void goToMoeda() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MoedaScreen()));
  }
}

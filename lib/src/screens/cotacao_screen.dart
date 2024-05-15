import 'package:app_grafico_compartilhado/src/isar/cotacao_database.dart';
import 'package:app_grafico_compartilhado/src/isar/cotacao_model.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_database.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_model.dart';
import 'package:app_grafico_compartilhado/src/screens/grafico_screen.dart';
import 'package:app_grafico_compartilhado/src/screens/moeda_screen.dart';
import 'package:app_grafico_compartilhado/utils/colors_app.dart';
import 'package:app_grafico_compartilhado/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CotacaoScreen extends StatefulWidget {
  const CotacaoScreen({super.key});

  @override
  CotacaoScreenState createState() => CotacaoScreenState();
}

class CotacaoScreenState extends State<CotacaoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color3,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.color1,
        centerTitle: true,
        title: const Text("Cadastro de cotações"),
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
      floatingActionButton: _buildAddCotacaoButton(),
    );
  }

  Widget _buildCotacoesList() {
    final cotacaoDataBase = context.watch<CotacaoDatabase>();
    List<Cotacoess> currentCotacao = cotacaoDataBase.currentCotacao;

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
                  "Moeda: ${cotacao.nome} - Valor: ${valorFormat().format(cotacao.valor)} - Data de registro: ${dateFormat().format(cotacao.dataHora)}",
                  style: const TextStyle(fontSize: 18),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        deleteCotacaoDialog(cotacao.id);
                      },
                      icon: const Icon(Icons.delete),
                    )
                  ],
                ),
              );
            },
          );
  }

  void addCotacaoDialog() {
    final moedaDataBase = context.read<MoedaDatabase>();
    final cotacaoDataBase = context.read<CotacaoDatabase>();

    Moeda? selectedMoeda;
    TextEditingController valorController = TextEditingController();
    TextEditingController dataController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Cadastro de cotações",
            style: TextStyle(fontSize: 30),
          ),
          content: StatefulBuilder(builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<Moeda>(
                  decoration: const InputDecoration(
                    labelText: "Selecione a moeda",
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
                TextFormField(
                  controller: valorController,
                  cursorColor: Colors.grey,
                  decoration: const InputDecoration(
                    prefixText: "R\$ ",
                    prefixStyle: TextStyle(color: Colors.grey, fontSize: 18),
                    labelText: "Valor da cotação",
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: dataController,
                  cursorColor: Colors.grey,
                  decoration: const InputDecoration(
                    hintText: "dia/mês/ano",
                    hintStyle: TextStyle(color: Colors.grey),
                    labelText: "Data de registro",
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            );
          }),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              onPressed: () async {
                String valorText = valorController.text.trim();
                double valor = double.tryParse(valorText) ?? 0.0;

                String dataText = dataController.text.trim();
                DateTime? data = dateFormat().parse(dataText);

                await cotacaoDataBase.addCotacao(
                  selectedMoeda!.nome,
                  data,
                  valor,
                );

                Navigator.of(context).pop();
              },
              child: const Text(
                "Salvar",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        );
      },
    );
  }

  //DELETE
  void deleteCotacao(int id) {
    context.read<CotacaoDatabase>().deleteCotacao(id);
  }

  void deleteCotacaoDialog(int id) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: const Text(
                "Você tem certeza que deseja excluir essa cotação ?",
                style: TextStyle(fontSize: 30)),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancelar"),
                  ),
                  TextButton(
                    onPressed: () {
                      deleteCotacao(id);
                      Navigator.of(context).pop();
                    },
                    child: const Text("Confirmar"),
                  )
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
        backgroundColor: AppColors.color2,
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
          onPressed: goToMoedas,
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

  // BOTOES DE NAVEGAÇAO
  void goToGrafico() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const GraficoScreen()));
  }

  void goToCotacao() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const CotacaoScreen()));
  }

  void goToMoedas() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MoedaScreen()));
  }
}

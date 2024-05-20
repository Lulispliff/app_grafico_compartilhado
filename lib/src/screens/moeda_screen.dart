import 'package:app_grafico_compartilhado/src/error_dialogs/error_moeda_dialogs.dart';
import 'package:app_grafico_compartilhado/src/isar/cotacao_database.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_database.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_model.dart';
import 'package:app_grafico_compartilhado/src/screens/cotacao_screen.dart';
import 'package:app_grafico_compartilhado/src/screens/grafico_screen.dart';
import 'package:app_grafico_compartilhado/src/widgets/input.dart';
import 'package:app_grafico_compartilhado/utils/colors_app.dart';
import 'package:app_grafico_compartilhado/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MoedaScreen extends StatefulWidget {
  const MoedaScreen({super.key});

  @override
  MoedaScreenState createState() => MoedaScreenState();
}

class MoedaScreenState extends State<MoedaScreen> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    readMoeda();
    readCotacao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color3,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.color1,
        centerTitle: true,
        title: const Text("Cadastro de moedas"),
        titleTextStyle: const TextStyle(
            color: AppColors.color2, fontSize: 30, fontWeight: FontWeight.bold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildMoedasList(),
            ),
            const SizedBox(height: 16),
            _buildNavigatorButtons(),
          ],
        ),
      ),
      floatingActionButton: _buildAddMoedaDialog(),
    );
  }

  Widget _buildMoedasList() {
    final moedaDatabase = context.watch<MoedaDatabase>();
    List<Moeda> currentMoeda = moedaDatabase.currentMoeda;

    return currentMoeda.isEmpty
        ? const Center(
            child: Text(
              "Sua lista de moedas está vazia.",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          )
        : ListView.builder(
            itemCount: currentMoeda.length,
            itemBuilder: (context, index) {
              final moeda = currentMoeda[index];

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
                    "Moeda: ${StringUtils.capitalize(moeda.nome)} - ID: ${moeda.id}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          editMoedaDialog(moeda);
                        },
                        icon: const Icon(
                          Icons.create_sharp,
                          color: AppColors.color1,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          deleteMoedaDialog(moeda.id);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: AppColors.color1,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
  }

  Widget _buildAddMoedaDialog() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 110,
          width: 50,
          child: FloatingActionButton(
            onPressed: () {
              addMoedaDialog();
            },
            tooltip: "Adicionar moeda",
            backgroundColor: AppColors.color2,
            shape: const CircleBorder(),
            child: const Icon(FontAwesomeIcons.coins, color: AppColors.color3),
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
          onPressed: goToMoedas,
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

  //CREATE
  void addMoedaDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.color3,
          title: const Text("Adicionar Moeda",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.color2,
                  fontSize: 30,
                  fontWeight: FontWeight.bold)),
          content: Input(
              controller: textController,
              cursorColor: Colors.grey,
              label: "Nome da moeda",
              labelTextColor: Colors.grey),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(AppColors.color2)),
                  child: const Text('Cancelar',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(width: 10),
                TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(AppColors.color2)),
                  child: const Text('Salvar',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    if (textController.text.trim().isEmpty) {
                      MoedaErroDialog.addMoedaErro(context);
                    } else {
                      context
                          .read<MoedaDatabase>()
                          .addMoeda(textController.text);
                      Navigator.pop(context);
                      textController.clear();
                    }
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  //READ
  void readMoeda() {
    context.read<MoedaDatabase>().fetchMoedas();
  }

  void readCotacao() {
    context.read<CotacaoDatabase>().fetchCotacoes();
  }

  //UPDATE
  void editMoedaDialog(Moeda moeda) {
    textController.text = StringUtils.capitalize(moeda.nome);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.color3,
        title: const Text("Editar moeda",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppColors.color2,
                fontSize: 30,
                fontWeight: FontWeight.bold)),
        content: Input(
            controller: textController,
            cursorColor: Colors.grey,
            label: "Novo nome",
            labelTextColor: Colors.grey),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(AppColors.color2)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancelar",
                      style: TextStyle(
                        color: Colors.white,
                      ))),
              const SizedBox(width: 10),
              TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(AppColors.color2)),
                  onPressed: () {
                    if (textController.text.trim().isEmpty) {
                      MoedaErroDialog.editMoedaErro(context);
                    } else {
                      context
                          .read<MoedaDatabase>()
                          .updateMoeda(moeda.id, textController.text);
                      textController.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Salvar",
                      style: TextStyle(color: Colors.white)))
            ],
          )
        ],
      ),
    );
  }

  //DELETE
  void deleteMoeda(int id) {
    context.read<MoedaDatabase>().deleteMoeda(id);
  }

  void deleteMoedaDialog(int id) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: AppColors.color3,
            title: const Text("Deseja mesmo excluir essa moeda ?",
                style: TextStyle(
                    color: AppColors.color2,
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(AppColors.color2)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancelar",
                          style: TextStyle(color: Colors.white))),
                  const SizedBox(width: 10),
                  TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(AppColors.color2)),
                      onPressed: () {
                        deleteMoeda(id);
                        Navigator.of(context).pop();
                      },
                      child: const Text("Confirmar",
                          style: TextStyle(color: Colors.white)))
                ],
              )
            ],
          );
        });
  }

  //BOTOES DE NAVEGAÇAO

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

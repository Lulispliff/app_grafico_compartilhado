// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'package:app_grafico_compartilhado/src/isar/cotacao_database.dart';
import 'package:app_grafico_compartilhado/src/isar/cotacao_model.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_database.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_model.dart';
import 'package:app_grafico_compartilhado/src/widgets/date_picker.dart';
import 'package:app_grafico_compartilhado/src/widgets/navigator_butons.dart';
import 'package:app_grafico_compartilhado/src/widgets/input.dart';
import 'package:app_grafico_compartilhado/src/widgets/time_picker.dart';
import 'package:app_grafico_compartilhado/utils/colors_app.dart';
import 'package:app_grafico_compartilhado/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CotacaoScreen extends StatefulWidget {
  const CotacaoScreen({super.key});

  @override
  CotacaoScreenState createState() => CotacaoScreenState();
}

class CotacaoScreenState extends State<CotacaoScreen> {
  late List<Moeda> currentMoeda;

  late List<Cotacoess> cotacoesDaMoeda;
  @override
  void initState() {
    super.initState();
    readCotacao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color4,
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
              child: _buildPrimaryList(),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildAddCotacaoButton(),
    );
  }

  Widget _buildPrimaryList() {
    final moedaDatabase = context.watch<MoedaDatabase>();
    currentMoeda = moedaDatabase.currentMoeda;

    return currentMoeda.isEmpty
        ? const Center(
            child: Text("Sua lista de cotações está vazia.",
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
                      "Moeda: ${StringUtils.capitalize(moeda.nome)}",
                      style: const TextStyle(fontSize: 20),
                    ),
                    trailing: const Icon(Icons.arrow_drop_down),
                    children: [_buildSecondaryList(moeda)],
                  ));
            },
          );
  }

  Widget _buildSecondaryList(Moeda moeda) {
    final cotacaoDatabase = context.watch<CotacaoDatabase>();

    return FutureBuilder<List<Cotacoess>>(
      future: cotacaoDatabase.fetchCotacoesByMoeda(moeda.nome),
      builder: (context, snapshot) {
        final cotacoes = snapshot.data ?? [];
        cotacoes.sort((a, b) => a.data.compareTo(b.data));

        return cotacoes.isEmpty
            ? const Center(
                child: Text(
                  "Essa moeda ainda não possui nenhuma cotação registrada",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cotacoes.length,
                itemBuilder: (context, index) {
                  final cotacao = cotacoes[index];

                  return ListTile(
                    title: Text(
                      "Valor: ${StringUtils.formatValorBRL(cotacao.valor)} - Data de registro: ${StringUtils.formatDateSimple(cotacao.data)} - Horario de registro: ${StringUtils.formatHoraeMinuto(cotacao.hora)}",
                      style: const TextStyle(fontSize: 17),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        deleteCotacaoDialog(cotacao.id);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: AppColors.color1,
                      ),
                    ),
                  );
                },
              );
      },
    );
  }

  Widget _buildAddCotacaoButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 2),
              child: NavigatorButtons.buildNavigatorButtons(context),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: FloatingActionButton(
                onPressed: () {
                  addCotacaoDialog();
                },
                tooltip: "Adicionar cotação",
                backgroundColor: AppColors.color2,
                shape: const CircleBorder(),
                child: const Icon(Icons.add, color: AppColors.color4),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void addCotacaoDialog() {
    final moedaDataBase = context.read<MoedaDatabase>();
    final cotacaoDataBase = context.read<CotacaoDatabase>();

    DateTime? selectedHorario;
    DateTime? selectedData;
    Moeda? selectedMoeda;
    TextEditingController valorController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.color4,
          title: const Text(
            "Cadastro de cotações",
            style: TextStyle(
                fontSize: 30,
                color: AppColors.color2,
                fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<Moeda>(
                  decoration: const InputDecoration(
                    focusColor: Colors.transparent,
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
                            child: Text(StringUtils.capitalize(moeda.nome)),
                          ))
                      .toList(),
                  onChanged: (Moeda? value) {
                    setState(() {
                      selectedMoeda = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                Input(
                  label: "Valor da moeda",
                  labelTextColor: Colors.grey,
                  preffixIcon: const Icon(Icons.attach_money_outlined),
                  cursorColor: Colors.grey,
                  controller: valorController,
                ),
                const SizedBox(height: 10),
                DatePickerWidget(
                  label: "Data de registro",
                  data: selectedData,
                  onChange: (DateTime date) async {
                    setState(() {
                      selectedData = date;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TimePickerWidget(
                  label: "Horario de registro",
                  hora: selectedHorario,
                  onChange: (DateTime hora) async {
                    setState(() {
                      selectedHorario = hora;
                    });
                  },
                ),
              ],
            );
          }),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(AppColors.color2),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(AppColors.color2),
              ),
              onPressed: () async {
                String valorText = valorController.text.trim();
                valorText = valorText.replaceAll(',', '.');
                double valor = double.tryParse(valorText) ?? 0.0;

                if (selectedMoeda != null &&
                    selectedData != null &&
                    selectedHorario != null) {
                  await cotacaoDataBase.addCotacao(selectedMoeda!.nome,
                      selectedData!, selectedHorario!, valor, selectedMoeda!);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          "Por favor, preencha todos os campos corretamente!")));
                }
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

  void deleteCotacaoDialog(int id) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            backgroundColor: AppColors.color4,
            title: const Text("Deseja mesmo excluir essa cotação ?",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: AppColors.color2)),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(AppColors.color2)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(AppColors.color2)),
                    onPressed: () {
                      deleteCotacao(id);
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Confirmar",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          );
        });
  }

  //READ
  void readCotacao() {
    context.read<CotacaoDatabase>().fetchCotacoes();
  }

  void readMoeda() {
    context.read<MoedaDatabase>().fetchMoedas();
  }

  //DELETE
  void deleteCotacao(int id) {
    context.read<CotacaoDatabase>().deleteCotacao(id);
  }
}

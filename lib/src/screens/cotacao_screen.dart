import 'package:app_grafico_compartilhado/src/api/repositories/moeda_repository.dart';
import 'package:app_grafico_compartilhado/src/widgets/navigator_butons.dart';
import 'package:app_grafico_compartilhado/src/api/stores/moeda_store.dart';
import 'package:app_grafico_compartilhado/src/isar/cotacao_database.dart';
import 'package:app_grafico_compartilhado/src/api/http/http_client.dart';
import 'package:app_grafico_compartilhado/src/widgets/date_picker.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_database.dart';
import 'package:app_grafico_compartilhado/src/widgets/time_picker.dart';
import 'package:app_grafico_compartilhado/src/isar/cotacao_model.dart';
import 'package:app_grafico_compartilhado/utils/error_messages.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_model.dart';
import 'package:app_grafico_compartilhado/utils/string_utils.dart';
import 'package:app_grafico_compartilhado/src/widgets/input.dart';
import 'package:app_grafico_compartilhado/utils/colors_app.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class CotacaoScreen extends StatefulWidget {
  const CotacaoScreen({super.key});

  @override
  CotacaoScreenState createState() => CotacaoScreenState();
}

class CotacaoScreenState extends State<CotacaoScreen> {
  late List<Cotacoess> cotacoesDaMoeda;
  late List<Moeda> currentMoeda;

  @override
  void initState() {
    super.initState();
    readCotacao();
  }

  final MoedaStore store = MoedaStore(
    repository: MoedaRepository(
      client: HttpClient(),
    ),
  );

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
          color: AppColors.color2,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildPrimaryList(),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildAddCotacaolButton(),
    );
  }

  Widget _buildPrimaryList() {
    final moedaDatabase = context.watch<MoedaDatabase>();
    currentMoeda = moedaDatabase.currentMoeda;

    return currentMoeda.isEmpty
        ? const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FontAwesomeIcons.fileInvoiceDollar,
                    color: AppColors.color1),
                SizedBox(width: 10),
                Text("Sua lista de cotações está vazia",
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              ],
            ),
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
                      StringUtils.capitalize(moeda.nome),
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

        cotacoes.sort((a, b) {
          int comparacaoData = a.data.compareTo(b.data);

          if (comparacaoData != 0) {
            return comparacaoData;
          } else {
            return a.hora.compareTo(b.hora);
          }
        });

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
            : SizedBox(
                height: 300,
                child: SingleChildScrollView(
                  child: Column(
                      children: cotacoes.map((cotacao) {
                    return ListTile(
                      title: Text(
                        "Valor: R\$ ${StringUtils.formatValor(cotacao.valor)} - Data de registro: ${StringUtils.formatDateSimple(cotacao.data)} - Horário de registro: ${StringUtils.formatHoraeMinuto(cotacao.hora)}",
                        style: const TextStyle(fontSize: 17),
                      ),
                      trailing: Tooltip(
                        message: "Excluir",
                        child: IconButton(
                          onPressed: () {
                            deleteCotacaoDialog(cotacao.id);
                          },
                          icon:
                              const Icon(Icons.delete, color: AppColors.color1),
                        ),
                      ),
                    );
                  }).toList()),
                ),
              );
      },
    );
  }

  Widget _buildAddCotacaolButton() {
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
                child: const Icon(FontAwesomeIcons.fileInvoiceDollar,
                    color: AppColors.color4),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void addCotacaoDialog() {
    final cotacaoDataBase = context.read<CotacaoDatabase>();
    final moedaDataBase = context.read<MoedaDatabase>();

    TextEditingController valorController = TextEditingController();
    DateTime? selectedHorario;
    DateTime? selectedData;
    Moeda? selectedMoeda;

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
                  dropdownColor: AppColors.color5,
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
                  preffixIcon: const Icon(
                    Icons.paid_sharp,
                  ),
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
                  label: "Horário de registro",
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
            Row(
              children: [
                TextButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(AppColors.color2),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    addCotacaoApiDialog();
                  },
                  child: const Text(
                    "API",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const Spacer(),
                TextButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(AppColors.color2),
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
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(AppColors.color2),
                  ),
                  onPressed: () async {
                    String valorText = valorController.text.trim();
                    valorText = valorText.replaceAll(',', '.');
                    double valor = double.tryParse(valorText) ?? 0.0;

                    if (selectedMoeda != null &&
                        selectedData != null &&
                        selectedHorario != null) {
                      await cotacaoDataBase.addCotacao(
                          selectedMoeda!.nome,
                          selectedData!,
                          selectedHorario!,
                          valor,
                          selectedMoeda!);
                      Navigator.of(context).pop();
                    } else {
                      ErrorMessages.cotacaoAddErrorMessage(context);
                    }
                  },
                  child: const Text(
                    "Salvar",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }

  void addCotacaoApiDialog() {
    final moedaDataBase = context.read<MoedaDatabase>();

    DateTime? initialDate;
    Moeda? selectedMoeda;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: AppColors.color4,
            title: const Text(
              "Cadastro de cotações - API",
              style: TextStyle(
                  fontSize: 30,
                  color: AppColors.color2,
                  fontWeight: FontWeight.bold),
            ),
            content: StatefulBuilder(builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField(
                    dropdownColor: AppColors.color5,
                    decoration: const InputDecoration(
                        focusColor: Colors.transparent,
                        labelText: "Selecione a moeda",
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey))),
                    items: moedaDataBase.currentMoeda
                        .map((moeda) => DropdownMenuItem<Moeda>(
                              value: moeda,
                              child: Text(StringUtils.capitalize(moeda.nome)),
                            ))
                        .toList(),
                    onChanged: (Moeda? moeda) {
                      setState(() {
                        selectedMoeda = moeda;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  DatePickerWidget(
                    label: "Data inicial",
                    data: initialDate,
                    onChange: (DateTime date) async {
                      setState(() {
                        initialDate = date;
                      });
                    },
                  ),
                ],
              );
            }),
            actions: [
              Row(
                children: [
                  TextButton(
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(AppColors.color2),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      addCotacaoDialog();
                    },
                    child: const Text(
                      "Manual",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(AppColors.color2),
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
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(AppColors.color2),
                    ),
                    onPressed: () {
                      if (selectedMoeda == null || initialDate == null) {
                        ErrorMessages.addCotacaoApiErrorMessage(context);
                      }
                      store.getMoedas(
                        selectedMoeda!,
                        initialDate!.toIso8601String(),
                      );
                    },
                    child: const Text(
                      "Salvar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          );
        });
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(AppColors.color2)),
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
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(AppColors.color2),
                    ),
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

  void readCotacao() {
    context.read<CotacaoDatabase>().fetchCotacoes();
  }

  void readMoeda() {
    context.read<MoedaDatabase>().fetchMoedas();
  }

  void deleteCotacao(int id) {
    context.read<CotacaoDatabase>().deleteCotacao(id);
  }
}

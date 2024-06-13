import 'package:app_grafico_compartilhado/src/api/repositories/moeda_repository.dart';
import 'package:app_grafico_compartilhado/src/widgets/navigator_butons.dart';
import 'package:app_grafico_compartilhado/src/api/stores/moeda_store.dart';
import 'package:app_grafico_compartilhado/src/isar/cotacao_database.dart';
import 'package:app_grafico_compartilhado/src/api/http/http_client.dart';
import 'package:app_grafico_compartilhado/src/api/list/static_list.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_database.dart';
import 'package:app_grafico_compartilhado/utils/error_messages.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_model.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:app_grafico_compartilhado/utils/string_utils.dart';
import 'package:app_grafico_compartilhado/src/widgets/input.dart';
import 'package:app_grafico_compartilhado/utils/colors_app.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class MoedaScreen extends StatefulWidget {
  const MoedaScreen({super.key});

  @override
  MoedaScreenState createState() => MoedaScreenState();
}

class MoedaScreenState extends State<MoedaScreen> {
  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();
  final textController = TextEditingController();

  final MoedaStore store = MoedaStore(
    repository: MoedaRepository(
      client: HttpClient(),
    ),
  );

  @override
  void initState() {
    super.initState();
    readMoeda();
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
          ],
        ),
      ),
      floatingActionButton: _buildAddMoedaButton(),
    );
  }

  Widget _buildMoedasList() {
    final moedaDatabase = context.watch<MoedaDatabase>();
    List<Moeda> currentMoeda = moedaDatabase.currentMoeda;

    return currentMoeda.isEmpty
        ? const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FontAwesomeIcons.coins, color: AppColors.color1),
                SizedBox(width: 10),
                Text(
                  "Sua lista de moedas está vazia",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
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
                    bottom: BorderSide(
                      color: AppColors.color2,
                      width: 1.5,
                    ),
                  ),
                ),
                child: ListTile(
                  title: Text(
                    "${StringUtils.capitalize(moeda.nome)} - ID: ${moeda.id}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Tooltip(
                        message: "Editar",
                        child: IconButton(
                          onPressed: () {
                            editMoedaDialog(moeda);
                          },
                          icon: const Icon(
                            Icons.create_sharp,
                            color: AppColors.color1,
                          ),
                        ),
                      ),
                      Tooltip(
                        message: "Excluir",
                        child: IconButton(
                          onPressed: () {
                            deleteMoedaDialog(moeda.id);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: AppColors.color1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  Widget _buildAddMoedaButton() {
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
                  _addMoedaDialog();
                },
                tooltip: "Adicionar moeda",
                backgroundColor: AppColors.color2,
                shape: const CircleBorder(),
                child:
                    const Icon(FontAwesomeIcons.coins, color: AppColors.color4),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _addMoedaDialog() {
    String selectedKey = '';
    textController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.color4,
          title: const Text("Adicionar Moeda",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.color2,
                  fontSize: 30,
                  fontWeight: FontWeight.bold)),
          content: TypeAheadField<MapEntry<String, String>>(
            suggestionsBoxDecoration:
                const SuggestionsBoxDecoration(color: AppColors.color5),
            textFieldConfiguration: TextFieldConfiguration(
                controller: textController,
                cursorColor: Colors.grey,
                decoration: const InputDecoration(
                    labelText: "Nome da moeda",
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)))),
            suggestionsCallback: (pattern) {
              if (pattern.isEmpty) {
                return [];
              }
              return MoedaStatic.moedaStatic.entries
                  .where((entry) =>
                      entry.value.toLowerCase().contains(pattern.toLowerCase()))
                  .toList();
            },
            itemBuilder: (context, MapEntry<String, String> suggestion) {
              return ListTile(
                title: Text(suggestion.value),
              );
            },
            onSuggestionSelected: (MapEntry<String, String> suggestion) {
              textController.text = suggestion.value;
              selectedKey = suggestion.key; // Armazena a chave selecionada
            },
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(AppColors.color2),
                  ),
                  child: const Text('Cancelar',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(width: 10),
                TextButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(AppColors.color2),
                  ),
                  child: const Text('Salvar',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    if (textController.text.trim().isEmpty) {
                      ErrorMessages.moedaNomeErrorMessage(context);
                    } else {
                      context
                          .read<MoedaDatabase>()
                          .addMoeda(textController.text, selectedKey);
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

  void editMoedaDialog(Moeda moeda) {
    textController.text = StringUtils.capitalize(moeda.nome);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.color4,
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
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(AppColors.color2),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancelar",
                      style: TextStyle(
                        color: Colors.white,
                      ))),
              const SizedBox(width: 10),
              TextButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(AppColors.color2),
                  ),
                  onPressed: () {
                    if (textController.text.trim().isEmpty) {
                      ErrorMessages.moedaNovoNomeErrorMessage(context);
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

  void deleteMoedaDialog(int id) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: AppColors.color4,
            title: const Text("Deseja mesmo excluir essa moeda ?",
                style: TextStyle(
                    color: AppColors.color2,
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(AppColors.color2),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancelar",
                          style: TextStyle(color: Colors.white))),
                  const SizedBox(width: 10),
                  TextButton(
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(AppColors.color2),
                      ),
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

  //READ
  void readMoeda() {
    context.read<MoedaDatabase>().fetchMoedas();
  }

  void readCotacao() {
    context.read<CotacaoDatabase>().fetchCotacoes();
  }

  //DELETE
  void deleteMoeda(int id) {
    context.read<MoedaDatabase>().deleteMoeda(id);
  }
}

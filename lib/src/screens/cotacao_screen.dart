import 'package:app_grafico_compartilhado/src/isar/cotacao_database.dart';
import 'package:app_grafico_compartilhado/src/isar/cotacao_model.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_database.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_model.dart';
import 'package:app_grafico_compartilhado/src/screens/grafico_screen.dart';
import 'package:app_grafico_compartilhado/src/screens/moeda_screen.dart';
import 'package:app_grafico_compartilhado/src/widgets/input.dart';
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
  @override
  void initState() {
    super.initState();
    readCotacao();
    readMoeda();
  }

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
              child: _buildPrimaryList(),
            ),
            const SizedBox(height: 16),
            _buildNavigatorButtons(),
          ],
        ),
      ),
      floatingActionButton: _buildAddCotacaoButton(),
    );
  }

  Widget _buildPrimaryList() {
    final moedaDatabase = context.watch<MoedaDatabase>();
    List<Moeda> currentMoeda = moedaDatabase.currentMoeda;

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
    List<Cotacoess> cotacoesDaMoeda = moeda.cotacoes; // subir

    return cotacoesDaMoeda.isEmpty
        ? const Center(
            child: Text(
              "Essa moeda ainda não possui uma cotação registrada",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cotacoesDaMoeda.length,
            itemBuilder: (context, index) {
              final cotacao = cotacoesDaMoeda[index];

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
  }

  void addCotacaoDialog() {
    final moedaDataBase = context.read<MoedaDatabase>();
    final cotacaoDataBase = context.read<CotacaoDatabase>();

    Moeda? selectedMoeda;
    TextEditingController valorController = TextEditingController();
    TextEditingController dataController = TextEditingController();
    TextEditingController horaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.color3,
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
                const Input(
                  label: "Valor da moeda",
                  labelTextColor: Colors.grey,
                  preffixIcon: Icon(Icons.attach_money_outlined),
                  cursorColor: Colors.grey,
                ),
                const SizedBox(height: 10),
                Input(
                  hint: StringUtils.formatDateSimple(DateTime.now()),
                  label: "Data de registro",
                  labelTextColor: Colors.grey,
                  preffixIcon: const Icon(Icons.calendar_month),
                  cursorColor: Colors.grey,
                  controller: dataController,
                ),
                const SizedBox(height: 10),
                Input(
                  hint: StringUtils.formatHoraeMinuto(DateTime.now()),
                  label: "Horario de registro",
                  labelTextColor: Colors.grey,
                  preffixIcon: const Icon(Icons.alarm_outlined),
                  cursorColor: Colors.grey,
                  borderColor: Colors.grey,
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
            const SizedBox(width: 10),
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(AppColors.color2),
              ),
              onPressed: () async {
                String valorText = valorController.text.trim();
                double valor = double.tryParse(valorText) ?? 0.0;

                String dataText = dataController.text.trim();
                DateTime? data;
                try {
                  data = dateFormat().parse(dataText);
                } catch (e) {
                  data = null;
                }

                String horaText = horaController.text.trim();
                DateTime? hora;
                try {
                  hora = horaFormat().parse(horaText);
                } catch (e) {
                  hora = null;
                }
                //showDatePicker(context: context, firstDate: firstDate, lastDate: lastDate)
                if (selectedMoeda != null && data != null && hora != null) {
                  await cotacaoDataBase.addCotacao(
                      selectedMoeda!.nome, data, hora, valor, selectedMoeda!);

                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Por favor, preencha todos os campos corretamente."),
                    ),
                  );
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

  //DELETE
  void deleteCotacao(int id) {
    context.read<CotacaoDatabase>().deleteCotacao(id);
  }

  void deleteCotacaoDialog(int id) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            backgroundColor: AppColors.color3,
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

  Widget _buildAddCotacaoButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 110,
          width: 50,
          child: FloatingActionButton(
            onPressed: () {
              addCotacaoDialog();
            },
            tooltip: "Adicionar cotação",
            backgroundColor: AppColors.color2,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, color: AppColors.color3),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigatorButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
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

  //READ
  void readCotacao() {
    context.read<CotacaoDatabase>().fetchCotacoes();
  }

  void readMoeda() {
    context.read<MoedaDatabase>().fetchMoedas();
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

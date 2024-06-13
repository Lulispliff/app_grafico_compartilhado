import 'package:app_grafico_compartilhado/src/api/repositories/moeda_repository.dart';
import 'package:app_grafico_compartilhado/src/api/http/exceptions.dart';
import 'package:app_grafico_compartilhado/src/isar/cotacao_model.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_model.dart';
import 'package:app_grafico_compartilhado/utils/string_utils.dart';
import 'package:flutter/material.dart';

class MoedaStore {
  final IMoedaRepository repository;
  //Variavel reativa para o loading
  final ValueNotifier<bool> isloading = ValueNotifier<bool>(false);

  //Variavel reativa para o state
  final ValueNotifier<List<Cotacoess>> state =
      ValueNotifier<List<Cotacoess>>([]);

  //Variavel reativa para o erro
  final ValueNotifier<String> erro = ValueNotifier<String>('');

  MoedaStore({required this.repository});

  Future getMoedas(
    Moeda? moeda,
    String? startDate,
  ) async {
    String formattedStartDate = '';

    if (startDate != null) {
      final DateTime startDateTime = DateTime.parse(startDate);
      formattedStartDate = StringUtils.formatDateApi(startDateTime);
    }
    //Dia atual
    final DateTime currentDate = DateTime.now();

    //Calcula a diferença entre a data atual e a data selecionada
    final DateTime startDateTime = DateTime.parse(startDate!);
    final int differenceDays = currentDate.difference(startDateTime).inDays;

    //Converte a diferença para dias
    final String formattedNumDias = differenceDays.toString();

    isloading.value = true;

    final String? moedaKey = moeda?.key;
    final String? moedaNome = moeda?.nome;

    try {
      final result = await repository.getMoedas(
        moedaCompleta: moeda,
        moedaKey: moedaKey,
        moedaNome: moedaNome,
        startDate: formattedStartDate,
        numDias: formattedNumDias,
      );
      state.value = result;
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    }
    isloading.value = false;
  }
}

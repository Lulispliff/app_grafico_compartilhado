import 'package:app_grafico_compartilhado/src/api/repositories/moeda_repository.dart';
import 'package:app_grafico_compartilhado/src/api/http/exceptions.dart';
import 'package:app_grafico_compartilhado/src/isar/cotacao_api_model.dart';
import 'package:app_grafico_compartilhado/src/isar/cotacao_database.dart';

import 'package:app_grafico_compartilhado/src/isar/cotacao_model.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_model.dart';
import 'package:app_grafico_compartilhado/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoedaStore {
  final IMoedaRepository repository;

  final ValueNotifier<bool> isloading = ValueNotifier<bool>(false);

  final ValueNotifier<List<CotacoesAPI>> apiCotacoes =
      ValueNotifier<List<CotacoesAPI>>([]);

  final ValueNotifier<List<Cotacoess>> manualCotacoes =
      ValueNotifier<List<Cotacoess>>([]);

  final ValueNotifier<List<Cotacoess>> combinedCotacoesList =
      ValueNotifier<List<Cotacoess>>([]);

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
    final DateTime currentDate = DateTime.now();
    final DateTime startDateTime = DateTime.parse(startDate!);
    final int differenceDays = currentDate.difference(startDateTime).inDays;
    final String formattedNumDias = differenceDays.toString();

    isloading.value = true;

    final String? moedaKey = moeda?.key;
    final String? moedaNome = moeda?.nome;

    try {
      final result = await repository.getMoedas(
        moedaKey: moedaKey,
        moedaNome: moedaNome,
        startDate: formattedStartDate,
        numDias: formattedNumDias,
      );
      apiCotacoes.value = result;

      // Converte CotacoesAPI para Cotacoess e armazena em apiCotacoes
      final apiCotacoessList =
          result.map((cotacao) => cotacao.toCotacoess()).toList();
      combinedCotacoesList.value = [
        ...manualCotacoes.value,
        ...apiCotacoessList
      ];
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    }
    isloading.value = false;
  }

  void addManualCotacao(Cotacoess cotacao) {
    manualCotacoes.value = [...manualCotacoes.value, cotacao];
    combinedCotacoesList.value = [
      ...manualCotacoes.value,
      ...apiCotacoes.value.map((cotacao) => cotacao.toCotacoess())
    ];
  }

  Future<void> saveCotacoes(BuildContext context, Moeda selectedMoeda) async {
    var lista = apiCotacoes.value;
    if (lista.isEmpty) {
      return;
    }
    final cotacaoDatabase = context.read<CotacaoDatabase>();

    for (final c in lista) {
      await cotacaoDatabase.save(c.toCotacoess(), selectedMoeda);
    }
  }
}

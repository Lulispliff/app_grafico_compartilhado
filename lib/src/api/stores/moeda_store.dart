import 'package:app_grafico_compartilhado/src/api/repositories/moeda_repository.dart';
import 'package:app_grafico_compartilhado/src/api/models/moeda_api.dart';
import 'package:app_grafico_compartilhado/src/api/http/exceptions.dart';
import 'package:app_grafico_compartilhado/utils/string_utils.dart';
import 'package:flutter/material.dart';

class MoedaStore {
  final IMoedaRepository repository;
  //Variavel reativa para o loading
  final ValueNotifier<bool> isloading = ValueNotifier<bool>(false);

  //Variavel reativa para o state
  final ValueNotifier<List<MoedaApi>> state = ValueNotifier<List<MoedaApi>>([]);

  //Variavel reativa para o erro
  final ValueNotifier<String> erro = ValueNotifier<String>('');

  MoedaStore({required this.repository});

  Future getMoedas(
    String? moeda,
    String? startDate,
    String? endDate,
  ) async {
    String formattedStartDate = '';
    String formattedEndDate = '';

    if (startDate != null) {
      final DateTime startDateTime = DateTime.parse(startDate);
      formattedStartDate = StringUtils.formatDateApi(startDateTime);
    }

    if (endDate != null) {
      final DateTime endDateTime = DateTime.parse(endDate);
      formattedEndDate = StringUtils.formatDateApi(endDateTime);
    }

    isloading.value = true;

    try {
      final result = await repository.getMoedas(
        moeda: moeda,
        startDate: formattedStartDate,
        endDate: formattedEndDate,
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

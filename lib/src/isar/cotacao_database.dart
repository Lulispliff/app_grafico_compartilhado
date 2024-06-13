import 'package:app_grafico_compartilhado/src/isar/cotacao_model.dart';
import 'package:app_grafico_compartilhado/src/isar/isar_service.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_model.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

// CRUD
class CotacaoDatabase extends ChangeNotifier {
  //
  // Lista de cotações
  final List<Cotacoess> currentCotacao = [];

  // Método estático para inicializar o Isar
  static Future<void> initialize() async {
    await IsarService.initialize(); // Inicialize o IsarService uma vez
  }

  // Método para adicionar uma nova cotação
  Future<void> addCotacao(
      DateTime data, DateTime hora, double valor, Moeda moeda) async {
    final newCotacao =
        Cotacoess(data: data, hora: hora, valor: valor, moeda: moeda)
          ..data = data
          ..hora = hora
          ..valor = valor
          ..moeda = moeda;

    await IsarService.isar
        .writeTxn(() => IsarService.isar.cotacoess.put(newCotacao));
    moeda.cotacoes.add(newCotacao);
    await fetchCotacoes();
  }

  Future<void> save(Cotacoess cotacoes, Moeda moeda) async {
    await IsarService.isar
        .writeTxn(() => IsarService.isar.cotacoess.put(cotacoes));
    moeda.cotacoes.add(cotacoes);
    await fetchCotacoes();
  }

  // Método para buscar todas as cotações
  Future<void> fetchCotacoes() async {
    List<Cotacoess> fetchCotacoes =
        await IsarService.isar.cotacoess.where().findAll();
    currentCotacao.clear();
    currentCotacao.addAll(fetchCotacoes);
    notifyListeners();
  }

  // Método para buscar cotações por intervalo de tempo
  Future<List<Cotacoess>> fetchCotacoesByInterval(
      String nomeMoeda, Duration intervalo) async {
    DateTime now = DateTime.now();
    DateTime startDate = now.subtract(intervalo);

    return await IsarService.isar.cotacoess
        .filter()
        .nomeEqualTo(nomeMoeda)
        .and()
        .dataBetween(startDate, now)
        .findAll();
  }

  // Método para buscar cotações por moeda
  Future<List<Cotacoess>> fetchCotacoesByMoeda(String nomeMoeda) async {
    return await IsarService.isar.cotacoess
        .filter()
        .nomeEqualTo(nomeMoeda)
        .findAll();
  }

  // Método para deletar uma cotação pelo ID
  Future<void> deleteCotacao(int id) async {
    await IsarService.isar
        .writeTxn(() => IsarService.isar.cotacoess.delete(id));
    await fetchCotacoes();
  }
}

import 'package:app_grafico_compartilhado/src/isar/cotacao_model.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

//CRUD
class CotacaoDatabase extends ChangeNotifier {
  static late Isar isar;

  //Lista de cotações
  final List<Cotacoess> currentCotacao = [];

  //Create cotacao
  Future<void> addCotacao(String nome, DateTime dataHora, double valor) async {
    final newCotacao = Cotacoess()
      ..nome = nome
      ..dataHora = dataHora
      ..valor = valor;

    await isar.writeTxn(() => isar.cotacoess.put(newCotacao));
    await fetchCotacoes();
  }

  //Read cotacao
  Future<void> fetchCotacoes() async {
    List<Cotacoess> fetchCotacoes = await isar.cotacoess.where().findAll();
    currentCotacao.clear();
    currentCotacao.addAll(fetchCotacoes);
    notifyListeners();
  }

  //Delete cotacao
  Future<void> deleteCotacao(int id) async {
    await isar.writeTxn(() => isar.cotacoess.delete(id));
    await fetchCotacoes();
  }
}

import 'package:app_grafico_compartilhado/src/isar/moeda_model.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

//CRUD
class MoedaDatabase extends ChangeNotifier {
  static late Isar isar;

  // Initialize
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [MoedaSchema],
      directory: dir.path,
    );
  }

  //Lista de Moeda
  final List<Moeda> currentMoeda = [];

  //Create meoda
  Future<void> addMoeda(String nome) async {
    //Cria um novo objeto moeda
    final newMoeda = Moeda()..nome = nome;
    //Salvar no BD
    await isar.writeTxn(() => isar.moedas.put(newMoeda));
    // Re-read from BD
    await fetchMoedas();
  }

  //Read moeda
  Future<void> fetchMoedas() async {
    List<Moeda> fetchedMoedas = await isar.moedas.where().findAll();
    currentMoeda.clear();
    currentMoeda.addAll(fetchedMoedas);
    notifyListeners();
  }

  //Update moeda
  Future<void> updateMoeda(int id, String newMoeda) async {
    final existingMoeda = await isar.moedas.get(id);
    if (existingMoeda != null) {
      existingMoeda.nome = newMoeda;
      await isar.writeTxn(() => isar.moedas.put(existingMoeda));
      await fetchMoedas();
    }
  }

  //Delete moeda
  Future<void> deleteMoeda(int id) async {
    await isar.writeTxn(() => isar.moedas.delete(id));
    await fetchMoedas();
  }

  //Lista de cotações
  final List<Moeda> currentCotacao = [];

  //Create cotacao
  Future<void> addCotacao(String nome, DateTime dataHora, double valor) async {
    final newCotacao = Moeda()
      ..nome = nome
      ..dataHora = dataHora
      ..valor = valor;

    await isar.writeTxn(() => isar.moedas.put(newCotacao));
    await fetchCotacoes();
  }

  //Read cotacao
  Future<void> fetchCotacoes() async {
    List<Moeda> fetchCotacoes = await isar.moedas.where().findAll();
    currentCotacao.clear();
    currentCotacao.addAll(fetchCotacoes);
    notifyListeners();
  }

  //Delete cotacao
  Future<void> deleteCotacao(int id) async {
    await isar.writeTxn(() => isar.moedas.delete(id));
    await fetchCotacoes();
  }
}

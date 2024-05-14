import 'package:flutter/material.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_model.dart';
import 'package:app_grafico_compartilhado/src/isar/isar_service.dart';
import 'package:isar/isar.dart'; // Importe o IsarService

// CRUD
class MoedaDatabase extends ChangeNotifier {
  // Lista de Moeda
  final List<Moeda> currentMoeda = [];

  // Método estático para inicializar o Isar
  static Future<void> initialize() async {
    await IsarService.initialize(); // Inicialize o IsarService uma vez
  }

  // Método para adicionar uma nova moeda
  Future<void> addMoeda(String nome) async {
    final newMoeda = Moeda()..nome = nome;

    await IsarService.isar
        .writeTxn(() => IsarService.isar.moedas.put(newMoeda));
    await fetchMoedas();
  }

  // Método para buscar todas as moedas
  Future<void> fetchMoedas() async {
    List<Moeda> fetchedMoedas = await IsarService.isar.moedas.where().findAll();
    currentMoeda.clear();
    currentMoeda.addAll(fetchedMoedas);
    notifyListeners();
  }

  // Método para atualizar uma moeda pelo ID
  Future<void> updateMoeda(int id, String newMoeda) async {
    final existingMoeda = await IsarService.isar.moedas.get(id);
    if (existingMoeda != null) {
      existingMoeda.nome = newMoeda;
      await IsarService.isar
          .writeTxn(() => IsarService.isar.moedas.put(existingMoeda));
      await fetchMoedas();
    }
  }

  // Método para deletar uma moeda pelo ID
  Future<void> deleteMoeda(int id) async {
    await IsarService.isar.writeTxn(() => IsarService.isar.moedas.delete(id));
    await fetchMoedas();
  }
}

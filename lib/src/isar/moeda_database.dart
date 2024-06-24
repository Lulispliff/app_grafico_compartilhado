import 'package:app_grafico_compartilhado/src/isar/cotacao_model.dart';
import 'package:app_grafico_compartilhado/src/isar/isar_service.dart';
import 'package:app_grafico_compartilhado/src/isar/moeda_model.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

// CRUD
class MoedaDatabase extends ChangeNotifier {
  //
  // Lista de Moeda
  final List<Moeda> currentMoeda = [];

  // Método estático para inicializar o Isar
  static Future<void> initialize() async {
    await IsarService.initialize(); // Inicialize o IsarService uma vez
  }

  // Método para adicionar uma nova moeda
  Future<void> addMoeda(String nome, String key) async {
    final newMoeda = Moeda()
      ..nome = nome
      ..key = key;

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
    final isar = IsarService.isar;
    await isar.writeTxn(() async {
      final existingMoeda = await isar.moedas.get(id);
      if (existingMoeda != null) {
        // Deleta todas as cotações associadas à moeda
        final cotacoes = await isar.cotacoess
            .filter()
            .nomeEqualTo(existingMoeda.nome)
            .findAll();
        await isar.cotacoess.deleteAll(cotacoes.map((e) => e.id).toList());

        // Atualiza a moeda
        existingMoeda.nome = newMoeda;
        await isar.moedas.put(existingMoeda);
      }
    });
    await fetchMoedas();
  }

  // Método para deletar uma moeda pelo ID
  Future<void> deleteMoeda(int id) async {
    final isar = IsarService.isar;
    await isar.writeTxn(() async {
      // Obtém a moeda pelo ID
      final moeda = await isar.moedas.get(id);
      if (moeda != null) {
        // Deleta todas as cotações que têm o mesmo nome da moeda
        final cotacoes =
            await isar.cotacoess.filter().nomeEqualTo(moeda.nome).findAll();
        await isar.cotacoess.deleteAll(cotacoes.map((e) => e.id).toList());
        // Deleta a moeda
        await isar.moedas.delete(id);
      }
    });
    await fetchMoedas();
  }
}

import 'package:app_grafico_compartilhado/src/api/http/http_client.dart';
import 'package:app_grafico_compartilhado/src/api/http/exceptions.dart';
import 'package:app_grafico_compartilhado/src/isar/cotacao_model.dart';
import 'dart:convert';

abstract class IMoedaRepository {
  Future<List<Cotacoess>> getMoedas({
    String? startDate,
    String? moedaKey,
    String? moedaNome,
    String? numDias,
  });
}

class MoedaRepository implements IMoedaRepository {
  final IhhtpClient client;

  MoedaRepository({required this.client});

  @override
  Future<List<Cotacoess>> getMoedas({
    String? moedaKey,
    String? moedaNome,
    String? startDate,
    String? numDias,
  }) async {
    final url =
        'https://economia.awesomeapi.com.br/json/daily/$moedaKey/$numDias';
    final response = await client.get(url: url);

    if (response.statusCode == 200) {
      // "jsonDecode(response.body) as List" recebe a resposta JSON e converte em uma lista de maps
      final body = jsonDecode(response.body) as List;

      final List<Cotacoess> moedas = [];

      // É realizado um loop para iterar sobre cada map da lista e criar objetos "Cotacoess"
      for (var map in body) {
        moedas.add(Cotacoess.fromJson(map as Map<String, dynamic>));
      }

      return moedas;
    } else if (response.statusCode == 404) {
      throw NotFoundException('A url informada não é válida!');
    } else {
      throw Exception('Não foi possível carregar as moedas!');
    }
  }
}

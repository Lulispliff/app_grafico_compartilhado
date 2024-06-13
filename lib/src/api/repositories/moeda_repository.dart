import 'package:app_grafico_compartilhado/src/api/http/http_client.dart';
import 'package:app_grafico_compartilhado/src/api/http/exceptions.dart';
import 'package:app_grafico_compartilhado/src/isar/cotacao_model.dart';
import 'dart:convert';
import 'package:app_grafico_compartilhado/src/isar/moeda_model.dart';

import 'package:app_grafico_compartilhado/src/isar/cotacao_modelAPI.dart';

abstract class IMoedaRepository {
  Future<List<CotacoesAPI>> getMoedas({
    String? startDate,
    String? moedaKey,
    String? moedaNome,
    String? numDias,
    Moeda? moedaCompleta,
  });
}

class MoedaRepository implements IMoedaRepository {
  final IhhtpClient client;

  MoedaRepository({required this.client});

  @override
  Future<List<CotacoesAPI>> getMoedas({
    String? moedaKey,
    String? moedaNome,
    String? startDate,
    String? numDias,
    Moeda? moedaCompleta,
  }) async {
    final url =
        'https://economia.awesomeapi.com.br/json/daily/$moedaKey/$numDias';
    final response = await client.get(url: url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as List;
      return CotacoesAPI.fromJsonList(body);
    } else if (response.statusCode == 404) {
      throw NotFoundException('A url informada não é válida!');
    } else {
      throw Exception('Não foi possível carregar as moedas!');
    }
  }
}

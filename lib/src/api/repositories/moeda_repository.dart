import 'package:app_grafico_compartilhado/src/api/http/http_client.dart';
import 'package:app_grafico_compartilhado/src/api/http/exceptions.dart';
import 'package:app_grafico_compartilhado/src/isar/cotacao_api_model.dart';
import 'dart:convert';

abstract class IMoedaRepository {
  Future<List<CotacoesAPI>> getMoedas({
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
  Future<List<CotacoesAPI>> getMoedas({
    String? moedaKey,
    String? moedaNome,
    String? startDate,
    String? numDias,
  }) async {
    final url =
        'https://economia.awesomeapi.com.br/json/daily/$moedaKey/$numDias';
    final response = await client.get(url: url);

    if (response.statusCode == 200) {
      // "jsonDecode(response.body) as List" recebe diretamente a resposta JSON e converte para uma lista de maps
      final body = jsonDecode(response.body) as List;

      // "CotacoesAPI.fromJsonList(body)" converte cada map em um objeto "CotacaoesAPI"
      return CotacoesAPI.fromJsonList(body);
      ////////
    } else if (response.statusCode == 404) {
      throw NotFoundException('A url informada não é válida!');
    } else {
      throw Exception('Não foi possível carregar as moedas!');
    }
  }
}

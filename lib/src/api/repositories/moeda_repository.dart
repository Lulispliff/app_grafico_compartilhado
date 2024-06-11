import 'package:app_grafico_compartilhado/src/api/http/http_client.dart';
import 'package:app_grafico_compartilhado/src/api/http/exceptions.dart';
import 'dart:convert';
import 'package:app_grafico_compartilhado/src/isar/cotacao_model.dart';

abstract class IMoedaRepository {
  Future<List<Cotacoess>> getMoedas(
      {String? moeda, String? startDate, String? endDate});
}

class MoedaRepository implements IMoedaRepository {
  final IhhtpClient client;

  MoedaRepository({required this.client});

  @override
  Future<List<Cotacoess>> getMoedas({
    String? moeda,
    String? startDate,
    String? endDate,
  }) async {
    final url =
        'https://economia.awesomeapi.com.br/$moeda/10?start_date=$startDate&end_date=$endDate';
    final response = await client.get(url: url);

    if (response.statusCode == 200) {
      //body recebe os maps que contem os itens
      final body = jsonDecode(response.body) as List;
      final List<Cotacoess> moedas = [];

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

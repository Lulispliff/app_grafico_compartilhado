import 'dart:convert';

import 'package:app_grafico_compartilhado/src/api/http/exceptions.dart';
import 'package:app_grafico_compartilhado/src/api/http/http_client.dart';
import 'package:app_grafico_compartilhado/src/api/models/moeda_api.dart';

abstract class IMoedaRepository {
  Future<List<MoedaApi>> getMoedas({
    required String moeda,
    required String quantidade,
    required String startDate,
    required String endDate,
  });
}

class MoedaRepository implements IMoedaRepository {
  final IhhtpClient client;

  MoedaRepository({required this.client});

  @override
  Future<List<MoedaApi>> getMoedas({
    required String moeda,
    required String quantidade,
    required String startDate,
    required String endDate,
  }) async {
    final url =
        'https://economia.awesomeapi.com.br/$moeda/$quantidade?start_date=$startDate&end_date=$endDate';
    final response = await client.get(url: url);

    if (response.statusCode == 200) {
      final List<MoedaApi> moedas = [];

      //body recebe os maps que contem os itens
      final body = jsonDecode(response.body);

      (body as List).map((item) {
        final MoedaApi moeda = MoedaApi.fromMap(item);
        moedas.add(moeda);
      }).toList();

      return moedas;
    } else if (response.statusCode == 404) {
      throw NotFoundException('A url informada não é válida!');
    } else {
      throw Exception('Não foi possível carregar as moedas!');
    }
  }
}

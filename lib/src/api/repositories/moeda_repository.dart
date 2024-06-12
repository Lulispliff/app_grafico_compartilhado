import 'package:app_grafico_compartilhado/src/api/http/http_client.dart';
import 'package:app_grafico_compartilhado/src/api/http/exceptions.dart';
import 'package:app_grafico_compartilhado/src/isar/cotacao_model.dart';
import 'dart:convert';

abstract class IMoedaRepository {
  Future<List<Cotacoess>> getMoedas({
    String? startDate,
    String? moedaKey,
    String? moedaNome,
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
    
    //Dia atual
    final DateTime currentDate = DateTime.now();

    //Calcula a diferença entre a data atual e a data selecionada
    final DateTime startDateTime = DateTime.parse(startDate!);
    final int differenceDays = currentDate.difference(startDateTime).inDays;

    //Converte a diferença para dias
    final String formattedNumDias = differenceDays.toString();

    final url =
        'https://economia.awesomeapi.com.br/json/daily/$moedaKey/$formattedNumDias';
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

import 'package:http/http.dart' as http;

abstract class IhhtpClient {
  Future get({required String url});
}

class HttpClient implements IhhtpClient {
  final client = http.Client();

  @override
  Future get({required String url}) async {
    return await client.get(Uri.parse(url));
  }
}

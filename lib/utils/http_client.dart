import 'package:http/http.dart' as http;
import 'package:mintness/repositories/local_storage.dart';
import 'package:mintness/repositories/httpClient.dart' as DioClient;

class HttpClientOld extends http.BaseClient {
  final _localStorage = LocalStorage();
  final _client =  http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = "Bearer ${_localStorage.accessToken}";
    // request.headers['accept'] = "application/json";
    // request.headers['Content-Type'] = "application/json";
    // print("${DateTime.now()} request: ${request.url}");
    // print("${DateTime.now()} request: ${request.headers}");
    return _client.send(request);
  }
}

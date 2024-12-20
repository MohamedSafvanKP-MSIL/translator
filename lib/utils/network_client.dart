import 'package:http/http.dart' as http;
import 'package:translator_app/contants/api_constants.dart';
import 'package:translator_app/utils/app_logs.dart';

class NetworkClient {
  final http.Client _client = http.Client();
  final String baseUrl;

  NetworkClient({required this.baseUrl});

  Future<http.Response> get({required String url}) async {
    String requestUrl = baseUrl + url;
    Uri requestUri = Uri.parse(requestUrl);

    AppLogs.printLog("=============== REQUEST START =======================");
    AppLogs.printLog("METHOD : GET");
    AppLogs.printLog("URL : $requestUrl");
    AppLogs.printLog("================ REQUEST END ======================");

    var response =
        await _client.get(requestUri, headers: ApiConstants.commonHeader);

    AppLogs.printLog("=============== RESPONSE START =======================");
    AppLogs.printLog("METHOD : GET");
    AppLogs.printLog("BODY : ${response.body}");
    AppLogs.printLog("================ RESPONSE END ======================");
    return response;
  }

  Future<http.Response> post(
      {required String url,
      required dynamic body,
      Map<String, String>? headers}) async {
    String requestUrl = baseUrl;
    Uri requestUri = Uri.parse(requestUrl);
    Map<String, String> header = {};
    header.addAll(ApiConstants.commonHeader);

    if (headers != null) {
      header.addAll(headers);
    }

    AppLogs.printLog("=============== REQUEST START =======================");
    AppLogs.printLog("METHOD : POST");
    AppLogs.printLog("URL : $requestUrl");
    AppLogs.printLog("HEADERS : $header");
    AppLogs.printLog("BODY : $body");
    AppLogs.printLog("================ REQUEST END ======================");

    var response = await _client.post(requestUri, headers: header, body: body);

    AppLogs.printLog("=============== RESPONSE START =======================");
    AppLogs.printLog("METHOD : POST");
    AppLogs.printLog("BODY : ${response.body}");
    AppLogs.printLog("================ RESPONSE END ======================");
    return response;
  }
}

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../models/app_config.dart';

class HttpService {
  final Dio dio = Dio();
  final GetIt getIt = GetIt.instance;

  String? baseUrl;
  String? apiKey;

  HttpService() {
    AppConfig config = getIt.get<AppConfig>();
    baseUrl = config.baseApiUrl;
    apiKey = config.apiKey;
  }

  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    try {
      String url = "$baseUrl$path";
      Map<String, dynamic> queryParams = {
        'api_key': apiKey,
        'language': 'ar-eg',
      };
      if (query != null) {
        queryParams.addAll(query);
      }
      return await dio.get(url, queryParameters: queryParams);
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? 'Unable to perform GET request');
    }
  }
}

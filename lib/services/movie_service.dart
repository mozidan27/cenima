import 'package:cenima/services/http_service.dart';
import 'package:get_it/get_it.dart';

class MovieService {
  final GetIt getIt = GetIt.instance;

  HttpService? http;

  MovieService() {
    http = getIt.get<HttpService>();
  }
}

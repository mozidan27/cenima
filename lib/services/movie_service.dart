import 'package:cenima/models/movie.dart';
import 'package:cenima/services/http_service.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class MovieService {
  final GetIt getIt = GetIt.instance;

  HttpService? http;

  MovieService() {
    http = getIt.get<HttpService>();
  }

  Future<List<Movie>> getPopularMovies({int? page}) async {
    Response response = await http!.get(
      "/movie/popular",
      query: {'page': page},
    );
    if (response.statusCode == 200) {
      Map data = response.data;
      List<Movie> movies = data['results'].map<Movie>((moviedata) {
        return Movie.fromJson(moviedata);
      }).toList();
      return movies;
    } else {
      throw Exception("couldn't load the movies");
    }
  }
}
